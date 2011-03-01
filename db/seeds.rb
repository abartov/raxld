# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Text.create(:title => 'A Source Book for Ancient Church History / J. C. Ayer', :filename => 'asbach.xml')
Text.create(:title => 'Rambles and Studies in Greece / J. P. Mahaffy', :filename => 'rambles.xml')
#Text.create(:title => 'Another sample TEI doc', :filename => 'another_sample_TEI.xml')
