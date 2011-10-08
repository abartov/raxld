class AddConstrainableIdAndConstrainableTypeToAnnotationConstraints < ActiveRecord::Migration
  def change
    add_column :annotation_constraints, :constrainable_id, :integer
    add_column :annotation_constraints, :constrainable_type, :string
  end
end
