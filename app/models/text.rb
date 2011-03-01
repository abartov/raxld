class Text < ActiveRecord::Base
  has_many :annotations, :class_name => 'TextAnnotation'
  
end
