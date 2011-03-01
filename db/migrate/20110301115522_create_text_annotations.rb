class CreateTextAnnotations < ActiveRecord::Migration
  def self.up
    create_table :text_annotations do |t|
      t.string :annotation_uri

      t.timestamps
    end
  end

  def self.down
    drop_table :text_annotations
  end
end
