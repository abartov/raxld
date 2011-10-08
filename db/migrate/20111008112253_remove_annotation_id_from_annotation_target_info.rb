class RemoveAnnotationIdFromAnnotationTargetInfo < ActiveRecord::Migration
  def up
    remove_column :annotation_target_infos, :annotation_id
  end

  def down
    add_column :annotation_target_infos, :annotation_id, :int
  end
end
