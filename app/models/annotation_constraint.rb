class AnnotationConstraint < ActiveRecord::Base
  belongs_to :constrainable, :polymorphic => true
end
