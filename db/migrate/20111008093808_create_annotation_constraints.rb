class CreateAnnotationConstraints < ActiveRecord::Migration
  def change
    create_table :annotation_constraints do |t|
      t.string :position
      t.string :checksum
      t.string :context
      t.string :constrained_uri

      t.timestamps
    end
  end
end
