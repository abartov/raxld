class AddAnnotationIdToAnnotationBody < ActiveRecord::Migration
  def change
    add_column :annotation_bodies, :annotation_id, :integer
  end
end
