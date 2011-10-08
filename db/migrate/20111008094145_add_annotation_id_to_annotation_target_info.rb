class AddAnnotationIdToAnnotationTargetInfo < ActiveRecord::Migration
  def change
    add_column :annotation_target_infos, :annotation_id, :integer
  end
end
