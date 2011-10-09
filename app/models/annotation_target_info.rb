class AnnotationTargetInfo < ActiveRecord::Base
  #has_and_belongs_to_many :annotations
  has_many :annotation_target_instances
  has_many :annotations, :through => :annotation_target_instances
  #has_one :annotation_constraint, :as => :constrainable

end
