class AnnotationBody < ActiveRecord::Base
  belongs_to :annotation
  has_one :annotation_constraint, :as => :constrainable
end
