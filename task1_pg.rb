require 'pg'
require 'rexml/document'
require 'open-uri'

include REXML

	#connect to postgres server with 'qbsitemap' as the database using the object ob
	db = PG.connect( dbname: 'qbsitemap' )
	
 
	#db.exec("CREATE TABLE sitemap(loc_id int,loc_data varchar(200))")
	count=1
	#xml file is stored in uri
	uri = URI.parse("http://www.qburst.com/sitemap.xml")
	#xml file is passed to xmldoc
	xmldoc  = Document.new (uri.open)
	#xml data is stored into Postgres database
	xmldoc.elements.each("urlset/url/loc") do 
		|location|   
		db.exec("INSERT INTO sitemap VALUES(#{count},'#{location.text}')")
		count += 1
	end