class AnnotationTargetInfosController < ApplicationController
  # GET /annotation_target_infos
  # GET /annotation_target_infos.json
  def index
    @annotation_target_infos = AnnotationTargetInfo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @annotation_target_infos }
    end
  end

  # GET /annotation_target_infos/1
  # GET /annotation_target_infos/1.json
  def show
    @annotation_target_info = AnnotationTargetInfo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @annotation_target_info }
    end
  end

  # GET /annotation_target_infos/new
  # GET /annotation_target_infos/new.json
  def new
    @annotation_target_info = AnnotationTargetInfo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @annotation_target_info }
    end
  end

  # GET /annotation_target_infos/1/edit
  def edit
    @annotation_target_info = AnnotationTargetInfo.find(params[:id])
  end

  # POST /annotation_target_infos
  # POST /annotation_target_infos.json
  def create
    @annotation_target_info = AnnotationTargetInfo.new(params[:annotation_target_info])

    respond_to do |format|
      if @annotation_target_info.save
        format.html { redirect_to @annotation_target_info, notice: 'Annotation target info was successfully created.' }
        format.json { render json: @annotation_target_info, status: :created, location: @annotation_target_info }
      else
        format.html { render action: "new" }
        format.json { render json: @annotation_target_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /annotation_target_infos/1
  # PUT /annotation_target_infos/1.json
  def update
    @annotation_target_info = AnnotationTargetInfo.find(params[:id])

    respond_to do |format|
      if @annotation_target_info.update_attributes(params[:annotation_target_info])
        format.html { redirect_to @annotation_target_info, notice: 'Annotation target info was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @annotation_target_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /annotation_target_infos/1
  # DELETE /annotation_target_infos/1.json
  def destroy
    @annotation_target_info = AnnotationTargetInfo.find(params[:id])
    @annotation_target_info.destroy

    respond_to do |format|
      format.html { redirect_to annotation_target_infos_url }
      format.json { head :ok }
    end
  end
end
