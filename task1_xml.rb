require 'mysql2'
require 'rexml/document'
require 'open-uri'

include REXML


begin
	#connects to MySQL server using the object db
	db = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "qburst")    
	#creates a new database 'qb_sitemap_task1' if it doesnt exist
	db.query("CREATE DATABASE IF NOT EXISTS qb_sitemap_task1")
	db.select_db('qb_sitemap_task1')
	#creates a new table 'sitemap' with the specified attributes if the same doesnt exist
	db.query("CREATE TABLE IF NOT EXISTS sitemap(loc_id integer,loc_data text)")
	count=1
	#xml file is stored in uri
	uri = URI.parse("http://www.qburst.com/sitemap.xml")
	#xml file is passed to xmldoc
	xmldoc  = Document.new (uri.open)
	#xml data is stored into MySQL database
	xmldoc.elements.each("urlset/url/loc") { 
		|location|   
		db.query("INSERT INTO sitemap VALUES(#{count},'#{location.text}')")
		count += 1
	}

rescue Mysql2::Error => e
  puts "Error code: #{e.errno}"
  puts "Error message: #{e.error}"
  puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
ensure
  db.close if db
end