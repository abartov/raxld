require 'xml/xslt'
require 'spira'
require 'rdf/ntriples'

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
    repo = RDF::Repository.load("http://raxld.benyehuda.org/raxld.nt")
    Spira.add_repository(:default, repo)
    @annos = []
    Spira.repository(:default).subjects.each do |oac_anno|
      @annos.push Annotation.for(oac_anno)
    end
  end

  def reset
    @text = Text.find_by_id(params[:id])
    Text.annotations.delete_all
  end

end
