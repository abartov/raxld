require 'xml/xslt'

class TextsController < ApplicationController
  def index
    list
  end
  def list
    @texts = Text.find(:all)
  end

  def show
    @text = Text.find_by_id(params[:id])
    xslt = XML::XSLT.new()
    xslt.xml = RAILS_ROOT+'/public'+@text.filename
    xslt.xsl = RAILS_ROOT+'/public'+"tei_to_xhtml.xsl"
  
    @xhtml = xslt.serve()
  end

  def harvest
  end

  def reset
  end

end
