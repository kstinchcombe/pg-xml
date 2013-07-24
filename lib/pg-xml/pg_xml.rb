# note: none of this is tested against Hpricot
# the goal was to allow either hpricot or nokogiri, but
# support for "using either" is half-assed at best

module PgXML
  
  # complex line of code determining whether we have access to nokogiri or hpricot.
  XML_PARSER_TYPE = ( require('nokogiri') || true rescue          # evaluates to true if we have nokogiri
                      require('hpricot') && false rescue          # evaluates to valse if we have hpricot
                      raise LoadError, "Either nokogiri or hpricot is required" # raises an error if we have neither
                    ) ? :nokogiri : :hpricot
  
  # get which XML parser we are using
  def self.parser_type
    XML_PARSER_TYPE
  end
  
  def self.load xml_str
    parse xml_str
  end
  
  def self.dump xml_document
    xml_document.to_s
  end
  
  # Valid xml requires a root node.
  def self.default
    parse '<xml></xml>'
  end
  
  # use our parser to create an XML document
  # warning: nokogiri is friendly -- if you feed it invalid XML it will fail silently
  # Nokogiri::XML.parse('<xml><xml>').to_s ~> <xml><xml/></xml>
  def self.parse xml_str
    XML_PARSER_TYPE == :nokogiri ? Nokogiri::XML.parse(xml_str) : Hpricot(xml_str)
  end
                   
end