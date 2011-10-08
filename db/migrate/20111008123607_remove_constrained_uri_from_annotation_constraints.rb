class RemoveConstrainedUriFromAnnotationConstraints < ActiveRecord::Migration
  def up
    remove_column :annotation_constraints, :constrained_uri
  end

  def down
    add_column :annotation_constraints, :constrained_uri, :string
  end
end
