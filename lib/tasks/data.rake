#require 'xml/xslt'
require 'spira'
require 'rdf/ntriples'
#require 'rexml/document'
#require 'net/http'
#require 'sparql/client'

desc "Process a large DBPedia N-triples file into a more compact form for the suggester"
task :prepare_articles => :environment do
  fname = ENV['DBP_TRIPLES'] || '/tmp/dbpedia_labels.nt'
  count = 0
  WikipediaLabel.delete_all # truncate the table before import
  articles = []
  IO.foreach(fname) { |line|
    /<http:\/\/dbpedia.org\/resource\/(.*)> <http:\/\/www.w3.org\/2000\/01\/rdf-schema#label> "(.*)"@en/.match(line) {|m|
      subject, object = m[1], m[2]
      articles << WikipediaLabel.new(:uri => subject, :label => object)
      count = count + 1
      if count % 1000 == 0
        WikipediaLabel.import articles
        articles = []
      end
      print "#{count} lines inserted.         \r" if count % 200 == 1
    }
    WikipediaLabel.import articles # final bit
  }
  print "Done importing Wikipedia article labels into lookup table.  #{count} lines inserted.\n"
end
