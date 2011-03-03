class AddBodyToTextAnnotation < ActiveRecord::Migration
  def self.up
    add_column :text_annotations, :body, :string
  end

  def self.down
    remove_column :text_annotations, :body
  end
end
