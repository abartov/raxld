module ApplicationHelper
  
  class Annotation
    include Spira::Resource
    type URI.new('http://www.openannotation.org/ns/Annotation')
    property :target,  :predicate => URI.new('http://www.openannotation.org/ns/hasTarget')
    property :body,  :predicate => URI.new('http://www.openannotation.org/ns/hasBody')
    property :title, :predicate => DC.title
  end
end
