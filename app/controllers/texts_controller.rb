require 'xml/xslt'
require 'spira'
require 'rdf/ntriples'

class Annotation
  include Spira::Resource
  base_uri 'http://raxld.benyehuda.org/purl/oac'
  type URI.new('http://www.openannotation.org/ns/Annotation')
  property :target,  :predicate => URI.new('http://www.openannotation.org/ns/hasTarget')
  property :body,  :predicate => URI.new('http://www.openannotation.org/ns/hasBody')
  property :title, :predicate => DC.title # URI.new('http://www.purl.org/dc/elements/1.1/title')
  property :author, :predicate => FOAF.name
end

class TextsController < ApplicationController
  def index
    list
  end
  def list
    @texts = Text.find(:all)
  end

  def show
    @text = Text.find(params[:id])
    xslt = XML::XSLT.new()
    xslt.xml = RAILS_ROOT+'/public/'+@text.filename
    #xslt.xsl = RAILS_ROOT+'/public/'+"vmachine.xsl"
    xslt.xsl = RAILS_ROOT+'/public/'+"tei.xsl"
    @xhtml = xslt.serve()
    #temporary, fugly hack
    @xhtml.gsub!(/\n/, '<br/>')
  end

  def harvest
    my_uri = 'http://raxld.benyehuda.org/texts/'+params[:id]
    @text = Text.find(params[:id])
    repo = RDF::Repository.load("http://raxld.benyehuda.org/raxld.nt")
    Spira.add_repository(:default, repo)
    @annos = []
    @existing = 0
    Spira.repository(:default).subjects.each do |oac_anno|
      anno = Annotation.for(oac_anno)
      if not anno.target.nil? and anno.target.to_s == my_uri
        if @text.annotations.find_by_annotation_uri(oac_anno.to_s).nil?
          new_anno = TextAnnotation.new(:annotation_uri => oac_anno.to_s)
          @text.annotations.push new_anno
	  new_anno.save!
          @text.save!
          @annos << 'URI: '+oac_anno.to_s+' dc:title -- '+anno.title.to_s + ' body: ' + anno.body.to_s
        else
          @existing += 1
        end
      end
    end
  end

  def reset
    @text = Text.find_by_id(params[:id])
    @text.annotations.delete_all
  end

end
