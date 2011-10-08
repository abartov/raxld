class CreateAnnotations < ActiveRecord::Migration
  def change
    create_table :annotations do |t|
      t.string :uri
      t.string :author_uri

      t.timestamps
    end
  end
end
