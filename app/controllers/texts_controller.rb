require 'xml/xslt'
require 'spira'
require 'rdf/ntriples'
require 'rexml/document'
require 'net/http'
require 'sparql/client'

class Annotation
  include Spira::Resource
  base_uri 'http://raxld.benyehuda.org/purl/oac'
  type URI.new('http://www.openannotation.org/ns/Annotation')
  property :target,  :predicate => URI.new('http://www.openannotation.org/ns/Target')
  property :body,  :predicate => URI.new('http://www.openannotation.org/ns/Body')
  property :title, :predicate => DC.title # URI.new('http://www.purl.org/dc/elements/1.1/title')
  property :author, :predicate => FOAF.name
end

class DBPItem
  include Spira::Resource
  base_uri "http://dbpedia.org/resource"
  default_source :dbpedia
  has_many :foafnames, :predicate => RDF::URI('http://xmlns.com/foaf/0.1/name')
  has_many :labels, :predicate => RDF::URI('http://www.w3.org/2000/01/rdf-schema#label')
  has_many :regions, :predicate => RDF::URI('http://dbpedia.org/ontology/region')
  has_many :categories, :predicate => RDF::URI('http://www.w3.org/2004/02/skos/core#subject')
  has_many :abstracts, :predicate => RDF::URI('http://dbpedia.org/ontology/abstract')
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
          @annos << 'URI: '+oac_anno.to_s+' dc:title -- '+anno.title.to_s + ' body: ' + anno.body.to_s
        else
          @existing += 1
        end
      end
    end
  end

  def reset
    @text = Text.find_by_id(params[:id])
    @text.annotations.clear
  end
  def suggest
    # call show to generate the text
    show
    #sparql = SPARQL::Client.new("http://dbpedia.org/sparql")
    @capitalized = @xhtml.scan(/[A-Z][a-z]+/)
    @suggestions = []
    @capitalized.each do |term|
      # grab N-Triples from DBPedia, if any
      res = Net::HTTP.get_response(URI.parse('http://dbpedia.org/data/'+term+'.ntriples'))
      next unless res.code == '200'
      # (manually grabbing, saving to a file, and then reading from it, because of a not-understood problem with loading a repo from a URI -- no time to look into it now)
      # TODO: yeah, this is not concurrency-safe
      fname = '/tmp/__temp_ntriples__.nt'
      File.open(fname,'w') { |f| 
        f.truncate(0)
        f.write(res.body)
        Spira.add_repository! :dbpedia, RDF::Repository.load(fname)
        dbp = DBPItem.for(term)
        label = ''
        if not dbp.foafnames.empty?
          label = dbp.foafnames.first
        elsif not dbp.labels.empty?
          label = dbp.labels.first
        else
          label = '(ERROR GETTING LABEL)'
        end
        abstract = ''
        dbp.abstracts.each do |ab|
          if ab.plain?
            abstract = ab.to_s
            break
          elsif ab.language == 'en'
            abstract = ab.to_s
            break
          end
        end
        @suggestions.push({ :label => label, :abstract => abstract })
      }
      debugger
      File.delete(fname)
    end
  end
end
