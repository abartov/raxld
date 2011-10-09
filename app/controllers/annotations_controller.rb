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
    annos = t.annotations unless t.nil? # TODO: return just URIs
    repond_to do |format|
      format.html # query.html.erb
      format.json { render json: annos }
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
    @annotation.annotation_body = @body
    @targets = []
    targets.each do |t|
      target = AnnotationTargetInfo.find_by_uri(t["uri"])
      if target.nil?
        # this one's new to us -- create it
        target = AnnotationTargetInfo.new(:uri => t["uri"])
      end
      @annotation.targets << target
      target.save
      @annotation.save
      constraint = t["constraint"]
      unless constraint.nil?
        instance = AnnotationTargetInstance.find_by_annotation_id_and_annotation_target_info_id(@annotation.id, target.id)
        c = AnnotationConstraint.new(constraint)
        instance.annotation_constraint = c
        instance.save!
      end
      target.save!
    end
    @body.save!

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
