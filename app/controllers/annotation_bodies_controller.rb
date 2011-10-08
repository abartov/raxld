class AnnotationBodiesController < ApplicationController
  # GET /annotation_bodies
  # GET /annotation_bodies.json
  def index
    @annotation_bodies = AnnotationBody.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @annotation_bodies }
    end
  end

  # GET /annotation_bodies/1
  # GET /annotation_bodies/1.json
  def show
    @annotation_body = AnnotationBody.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @annotation_body }
    end
  end

  # GET /annotation_bodies/new
  # GET /annotation_bodies/new.json
  def new
    @annotation_body = AnnotationBody.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @annotation_body }
    end
  end

  # GET /annotation_bodies/1/edit
  def edit
    @annotation_body = AnnotationBody.find(params[:id])
  end

  # POST /annotation_bodies
  # POST /annotation_bodies.json
  def create
    @annotation_body = AnnotationBody.new(params[:annotation_body])

    respond_to do |format|
      if @annotation_body.save
        format.html { redirect_to @annotation_body, notice: 'Annotation body was successfully created.' }
        format.json { render json: @annotation_body, status: :created, location: @annotation_body }
      else
        format.html { render action: "new" }
        format.json { render json: @annotation_body.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /annotation_bodies/1
  # PUT /annotation_bodies/1.json
  def update
    @annotation_body = AnnotationBody.find(params[:id])

    respond_to do |format|
      if @annotation_body.update_attributes(params[:annotation_body])
        format.html { redirect_to @annotation_body, notice: 'Annotation body was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @annotation_body.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /annotation_bodies/1
  # DELETE /annotation_bodies/1.json
  def destroy
    @annotation_body = AnnotationBody.find(params[:id])
    @annotation_body.destroy

    respond_to do |format|
      format.html { redirect_to annotation_bodies_url }
      format.json { head :ok }
    end
  end
end
