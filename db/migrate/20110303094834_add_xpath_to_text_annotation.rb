class AddXpathToTextAnnotation < ActiveRecord::Migration
  def self.up
    add_column :text_annotations, :xpath, :string
  end

  def self.down
    remove_column :text_annotations, :xpath
  end
end
