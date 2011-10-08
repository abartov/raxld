class CreateAnnotationTargetInstances < ActiveRecord::Migration
  def change
    create_table :annotation_target_instances do |t|
      t.integer :annotation_id
      t.integer :annotation_target_info_id

      t.timestamps
    end
  end
end
