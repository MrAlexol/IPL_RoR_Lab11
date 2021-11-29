require 'nokogiri'
doc = Nokogiri::XML(File.read('src.xml'))
xslt = Nokogiri::XSLT(File.read('style.xsl'))
puts xslt.transform(doc)