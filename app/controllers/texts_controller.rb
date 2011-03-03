require 'xml/xslt'
require 'spira'
require 'rdf/ntriples'
require 'rexml/document'
require 'net/http'

class Annotation
  include Spira::Resource
  base_uri 'http://raxld.benyehuda.org/purl/oac'
  type URI.new('http://www.openannotation.org/ns/Annotation')
  property :target,  :predicate => URI.new('http://www.openannotation.org/ns/Target')
  property :body,  :predicate => URI.new('http://www.openannotation.org/ns/Body')
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
    debugger
    f = File.new(::Rails.root.to_s+'/public/'+@text.filename)
    xmldoc = REXML::Document.new f
    @text.annotations.each do |anno|
      debugger
      target = REXML::XPath.first xmldoc, anno.xpath
      unless target.nil?
        unless anno.body.nil? or anno.body.empty?
          anno_body = REXML::Element.new('OAC_Annotation') 
          anno_body.attributes['class'] = 'OAC_Annotation'
          if /.jpg$/.match(anno.body)
            img = REXML::Element.new('OAC_img')
            img.attributes['src'] = anno.body
            anno_body.add img
          else
            # assume we just read the URL and dump its contents as-is in our DIV
            res = Net::HTTP.get_response(URI.parse(anno.body))
            anno_body.add_text res.body
          end
          target.parent.insert_after(target, anno_body)
        end
      else
        # TODO: if target is nil, just add at the bottom
        print "moose"
      end
    end
    xslt.xml = xmldoc
    #xslt.xml = RAILS_ROOT+'/public/'+@text.filename
    #xslt.xsl = RAILS_ROOT+'/public/'+"vmachine.xsl"
    #xslt.xsl = ::Rails.root.to_s+'/public/'+"min.xsl"
    xslt.xsl = REXML::Document.new File.read( ::Rails.root.to_s+'/public/'+"min.xsl")
    #xslt.xsl = REXML::Document.new File.read( ::Rails.root.to_s+'/public/'+"tei.xsl")
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
      debugger
      anno = Annotation.for(oac_anno)
      (target_uri, target_frag) = anno.target.to_s.split('#')
      if not target_uri.nil? and target_uri == my_uri
        if @text.annotations.find_by_annotation_uri(oac_anno.to_s).nil?
          unless target_frag.nil?
            # strip the xpointer() wrapper
            m = /xpointer\((.*)\)/.match(target_frag)
            target_frag = m[1]
          end
          anno.body = '' if anno.body.nil?
          new_anno = TextAnnotation.new(:annotation_uri => oac_anno.to_s, :xpath => target_frag, :body => anno.body.to_s)
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
