class AnnotationTargetInstance < ActiveRecord::Base
  belongs_to :annotation
  belongs_to :annotation_target_info
  has_one :annotation_constraint, :as => :constrainable
end
