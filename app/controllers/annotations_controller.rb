class AnnotationsController < ApplicationController
  # GET /annotations
  # GET /annotations.json
  def index
    @annotations = Annotation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @annotations }
    end
  end

  # GET /annotations/1
  # GET /annotations/1.json
  def show
    @annotation = Annotation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      #format.json { render json: @annotation.to_json(:include => [:annotation_body => {}, :annotation_target_instances => { :include => :annotation_constraint  }])}
      format.json #{ render json: @annotation } # rabl
    end
  end

  # GET /annotations/new
  # GET /annotations/new.json
  def new
    @annotation = Annotation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @annotation }
    end
  end

  # GET /annotations/1/edit
  def edit
    @annotation = Annotation.find(params[:id])
  end
  
  # GET /annotations/query?q=something
  def query
    uri = params[:q]
    t = AnnotationTargetInfo.find_by_uri(uri)
    annos = nil
    annos = t.annotations unless t.nil? 
    respond_to do |format|
      format.html # query.html.erb
      format.json { render json: annos }
    end
  end

  #OAC_CONSTRAINT_SVC = 'http://172.17.6.140:8182/oac-constraint/match'
  OAC_CONSTRAINT_SVC = 'http://87.106.12.254:8182/oac-constraint/match'
  # used to call Moritz and Marco's constraint validate service
  def validate_constraint(c, uri)
    # TODO: make the validation phase configureable
    # if config.validate? 
    # TODO: make the service address configurable
    res = RestClient.post OAC_CONSTRAINT_SVC, { 'uri' => uri, 'constraint' => { 'context' => c.context, 'checksum' => c.checksum, 'position' => c.position }}.to_json, :content_type => :json, :accept => :json
    return nil unless (not res.nil?) and res.code == 200 # service returns 409 if constraint invalid
    ret = ActiveSupport::JSON.decode(res.to_s)
    c.position = ret["constraint"]["position"]
    c.checksum = ret["constraint"]["checksum"]
    # TODO: _update_ the stored constraint with latest position and checksum, but into _separate_ fields.  So that the original annotation data is always present, just in case
    # end
  end

  # GET /annotations/render_annotated?uri=uri_to_render
  def render_annotated
    @text = ''
    @uri = params[:uri]
    t = AnnotationTargetInfo.find_by_uri(@uri)
    @msg = ''
    if t.nil?
      @msg = "No annotations known for URI: #{@uri}"
    else
      @text = fetch_url(t.uri, {})
      
      accumulated_offset = 0
      body = ''
      t.annotations.each { |a|
        if a.annotation_body.content.nil?
          body = fetch_url(a.annotation_body.uri, { 'Accept' => 'application/json' } )
          next if body.nil? # TODO: report the error
          body = ActiveSupport::JSON.decode(body)["annotation_body"]["content"]
        else
          body = a.annotation_body.content
        end
        @text += "</body>" if @text.rindex('</body>').nil?
        constraint = a.annotation_target_instances[0].annotation_constraint # TODO: support multiple targets in same document
        unless constraint.nil? # if there's no constraint, we'll just ignore the annotation.  TODO: eventually, place the annotation at the beginning of the URI -- i.e. treat frags correctly
          # call the M&M service to validate the integrity of the constraint and get an updated position
          validate_constraint(constraint, t.uri)
          unless constraint.nil?
            # insert the annotation
            #debugger
            before_pos = constraint.position[/\d+/].to_i
            after_pos = constraint.position[/\d+$/].to_i
            annid = "%013d" % (URI.parse(a.uri).path.slice(/\d+/))
            @text.insert(accumulated_offset + before_pos, "<span id=\"anno_#{annid}\" class=\"und\">") # including a 13-digit id
            accumulated_offset += 42
            @text.insert(accumulated_offset + after_pos, "</span><span class=\"anno\">***</span>")
            accumulated_offset += 36
            @text.insert(@text.rindex('</body>'), "<span class=\"anno_body\" id=\"anno_#{annid}_body\">#{body}</span>")
          end
        end
        @text.gsub!("\r\n\r\n",'<p/>') # happily, same character count!
        @text.gsub!("\n", '<p/>') # actually, we don't care about the offsets at this point...
        
      }
    end
  end
  
  # POST /annotations
  # POST /annotations.json
  def create
    body_uri = params["body_uri"]
    targets = params["targets"]
    #debugger
    if body_uri.nil? or targets.nil? or targets.empty?
      # invalid annotation
      # TODO: report the error
      flash[:error] = "Invalid input"
      return
    end
    @body = AnnotationBody.find_by_uri(body_uri)
    if @body.nil?
      # if the body is not already hosted on our server, we need to create a body record for it anyway, so we can represent the relationship correctly.  However, we won't be able to actually serve that URI ourselves.
      @body = AnnotationBody.new(:uri => body_uri)
    end
    @annotation = Annotation.new(:author_uri => params["author_uri"])
    @annotation.construct(@body, targets) # fill out the annotation and build relationships

    respond_to do |format|
      if @annotation.save
        @annotation.uri = url_for @annotation
        @annotation.save!
        format.html { redirect_to @annotation, notice: 'Annotation was successfully created.' }
        format.json { render json: @annotation, status: :created, location: @annotation }
      else
        format.html { render action: "new" }
        format.json { render json: @annotation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /annotations/1
  # PUT /annotations/1.json
  def update
    @annotation = Annotation.find(params[:id])

    respond_to do |format|
      if @annotation.update_attributes(params[:annotation])
        format.html { redirect_to @annotation, notice: 'Annotation was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @annotation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /annotations/1
  # DELETE /annotations/1.json
  def destroy
    @annotation = Annotation.find(params[:id])
    @annotation.destroy

    respond_to do |format|
      format.html { redirect_to annotations_url }
      format.json { head :ok }
    end
  end
end
