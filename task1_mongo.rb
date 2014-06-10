require 'rexml/document'
require 'open-uri'
require 'mongo'
include Mongo
include REXML

#connect to MongoDB server with database 'qbsitemap' using object 'conn'
conn = Mongo::Connection.new.db("qbsitemap")
#connect to collection 'sitemap' using object db
db = conn['sitemap']
count = 1
#xml file is stored in uri
uri = URI.parse("http://www.qburst.com/sitemap.xml")
#xml file is passed to xmldoc
xmldoc  = Document.new (uri.open)
#xml data is stored into MongoDB database
xmldoc.elements.each("urlset/url/loc") { 
		|location|   
		db.insert({id: count ,loc_data: location.text })
		count += 1
}