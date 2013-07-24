module ActiveRecord
  module Coders
    class XML
      
      def self.load(xml_string)
        new(PgXML.default).load(xml_string)
      end

      def self.dump(xml_document)
        new(PgXML.default).dump(xml_document)
      end

      def initialize(default=nil)
        @default=default
      end

      def dump(xml_document)
        (xml_document.nil? && @default.nil?) ? nil : PgXML.dump( xml_document || @default )
      end

      def load(xml_string)
        xml_string.nil? ? @default : PgXML.load(xml_string)
      end

    end
  end
end

