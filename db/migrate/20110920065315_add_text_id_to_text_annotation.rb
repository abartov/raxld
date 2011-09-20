class AddTextIdToTextAnnotation < ActiveRecord::Migration
  def change
    add_column :text_annotations, :text_id, :integer
  end
end
