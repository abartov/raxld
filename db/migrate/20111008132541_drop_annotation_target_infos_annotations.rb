class DropAnnotationTargetInfosAnnotations < ActiveRecord::Migration
  def up
    drop_table :annotation_target_infos_annotations
  end

  def down
    create_table :annotation_target_infos_annotations, :id => false do |t|
      t.integer :annotation_id
      t.integer :annotation_target_info_id
    end
  end
end
