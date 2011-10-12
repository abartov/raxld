class Annotation < ActiveRecord::Base
#  has_one :annotation_body, :dependent => :destroy
  has_one :annotation_body # since we are minting URIs for annotation bodies, we mustn't ever delete them
  #has_and_belongs_to_many :annotation_target_infos
  has_many :annotation_target_instances
  has_many :targets, :through => :annotation_target_instances, :source => :annotation_target_info

end
