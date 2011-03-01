class CreateTexts < ActiveRecord::Migration
  def self.up
    create_table :texts do |t|
      t.string :title
      t.string :filename

      t.timestamps
    end
  end

  def self.down
    drop_table :texts
  end
end
