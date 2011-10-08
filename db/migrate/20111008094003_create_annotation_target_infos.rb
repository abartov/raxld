class CreateAnnotationTargetInfos < ActiveRecord::Migration
  def change
    create_table :annotation_target_infos do |t|
      t.string :uri
      t.string :mime_type

      t.timestamps
    end
  end
end
