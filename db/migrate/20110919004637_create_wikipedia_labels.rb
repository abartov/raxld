class CreateWikipediaLabels < ActiveRecord::Migration
  def change
    create_table :wikipedia_labels do |t|
      t.string :uri
      t.string :label
    end
  end
end
