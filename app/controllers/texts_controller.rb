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
    xslt.xsl = RAILS_ROOT+'/public/'+"tei_to_xhtml.xsl"
  
    @xhtml = xslt.serve()
  end

  def harvest
    my_uri = 'http://raxld.benyehuda.org/texts/'+params[:id]
    repo = "http://benyehuda.org/~asaf/raxld.nt"
    Spira.add_repository(:default, RDF::Repository.load(repo))
    
  end

  def reset
    @text = Text.find_by_id(params[:id])
    Text.annotations.delete_all
  end

end
