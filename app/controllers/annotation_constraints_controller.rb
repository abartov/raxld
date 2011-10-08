class AnnotationConstraintsController < ApplicationController
  # GET /annotation_constraints
  # GET /annotation_constraints.json
  def index
    @annotation_constraints = AnnotationConstraint.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @annotation_constraints }
    end
  end

  # GET /annotation_constraints/1
  # GET /annotation_constraints/1.json
  def show
    @annotation_constraint = AnnotationConstraint.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @annotation_constraint }
    end
  end

  # GET /annotation_constraints/new
  # GET /annotation_constraints/new.json
  def new
    @annotation_constraint = AnnotationConstraint.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @annotation_constraint }
    end
  end

  # GET /annotation_constraints/1/edit
  def edit
    @annotation_constraint = AnnotationConstraint.find(params[:id])
  end

  # POST /annotation_constraints
  # POST /annotation_constraints.json
  def create
    @annotation_constraint = AnnotationConstraint.new(params[:annotation_constraint])

    respond_to do |format|
      if @annotation_constraint.save
        format.html { redirect_to @annotation_constraint, notice: 'Annotation constraint was successfully created.' }
        format.json { render json: @annotation_constraint, status: :created, location: @annotation_constraint }
      else
        format.html { render action: "new" }
        format.json { render json: @annotation_constraint.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /annotation_constraints/1
  # PUT /annotation_constraints/1.json
  def update
    @annotation_constraint = AnnotationConstraint.find(params[:id])

    respond_to do |format|
      if @annotation_constraint.update_attributes(params[:annotation_constraint])
        format.html { redirect_to @annotation_constraint, notice: 'Annotation constraint was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @annotation_constraint.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /annotation_constraints/1
  # DELETE /annotation_constraints/1.json
  def destroy
    @annotation_constraint = AnnotationConstraint.find(params[:id])
    @annotation_constraint.destroy

    respond_to do |format|
      format.html { redirect_to annotation_constraints_url }
      format.json { head :ok }
    end
  end
end
