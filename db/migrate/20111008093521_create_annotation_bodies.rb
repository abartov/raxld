class CreateAnnotationBodies < ActiveRecord::Migration
  def change
    create_table :annotation_bodies do |t|
      t.string :uri
      t.string :mime_type
      t.binary :content

      t.timestamps
    end
  end
end
