require 'xml/xslt'
require 'rexml/document'
require 'spira'
require 'rdf/ntriples'
require 'net/http'
require 'uri'

class ApplicationController < ActionController::Base
  protect_from_forgery

before_filter :cors_preflight_check
after_filter :cors_set_access_control_headers

# For all responses in this controller, return the CORS access control headers.

def cors_set_access_control_headers
  headers['Access-Control-Allow-Origin'] = '*'
  headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
  headers['Access-Control-Max-Age'] = "1728000"
end

# If this is a preflight OPTIONS request, then short-circuit the
# request, return only the necessary headers and return an empty
# text/plain.

def cors_preflight_check
  if request.method == :options
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version'
    headers['Access-Control-Max-Age'] = '1728000'
    render :text => '', :content_type => 'text/plain'
  end
end
def options
  #cors_preflight_check
end
def fetch_url(url, options)
#    r = Net::HTTP.get( URI.parse( url ), options )
  u = URI.parse(url)
  h = Net::HTTP.new(u.host, u.port)
  r = h.get(u.path, options)
  if r.is_a? Net::HTTPSuccess
    r.body
  else
    nil
  end
end

  # this routine ASSUMES the annotation constraints are valid XPaths
  def annotate_xml_and_render_html(xml_uri) # gacked from the old code in texts_controller
    xslt = XML::XSLT.new()
    target = AnnotationTargetInfo.find_by_uri(xml_uri) # find annotations for target uri
    unless target.nil? || target.annotations.count == 0
      res = NET::HTTP.get_response(URI.parse(xml_uri))
      xmldoc = REXML::Document.new res.body
      if res.code == 200
        target.annotations.each do |anno|
          node = REXML::XPath.first xmldoc, anno.xpath
          unless node.nil?
            unless anno.annotation_body.nil? or anno.annotation_body.content.nil? or anno.annotation_body.content.empty?
              anno_body = REXML::Element.new('OAC_Annotation')
              anno_body.attributes['class'] = 'OAC_Annotation'
              if /.jpg$/.match(anno.body)
                img = REXML::Element.new('OAC_img')
                img.attributes['src'] = anno.body
                anno_body.add img
              else
                # assume we just dump the body content as-is in our DIV
                anno_body.add_text anno.annotation_body.content
              end
              node.parent.insert_after(node, anno_body)
            end
          end
        end
      end
    end
    xslt.xml = xmldoc
    xslt.xsl = REXML::Document.new File.read(::Rails.root.to_s+'/public/'+"min.xsl")
    #xslt.xsl = REXML::Document.new File.read( ::Rails.root.to_s+'/public/'+"tei.xsl")
    xhtml = xslt.serve()
    #temporary, fugly hack
    xhtml.gsub!(/\n/, '<br/>')
    return xhtml
  end
end

