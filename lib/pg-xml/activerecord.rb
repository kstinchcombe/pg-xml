# use, e.g.,
#   has_xml_column :properties
# in your ActiveRecord model

# in a migration, use e.g.
#   add_xpath_index :users, :properties, '/xml/first_name'
# to index into the XML

module ActiveRecord

  class Base
    
    # define the has_xml_column :col_name name
    def self.has_xml_column attr_name
      
      # serialize using the custom serializer
      serialize attr_name, ActiveRecord::Coders::XML
      # validate XML before saving
      validate "validate_#{attr_name}_xml"
      
      # define the attribute writer to accept a string
      # and convert it to XML
      define_method("#{attr_name}=") do |val|
        if val.is_a? String
          val = PgXML.load(val)
        end
        self[attr_name] = val
      end
      
      # validate XML before writing to database
      define_method("validate_#{attr_name}_xml") do
        # TODO make this work with hpricot
        return true if self[attr_name].nil? || self[attr_name].errors == []
        self[attr_name].errors.each do |e|
          errors.add(attr_name, e.to_s)
        end
        return false
      end
      
    end
  end

  # support the add_xpath_index and make it reversible
  module ConnectionAdapters
    module SchemaStatements
    
      # enable adding an xpath index
      def add_xpath_index table_name, column_name, path, index_name=nil
        # generate an index name
        index_name ||= "index_#{table_name}_on_#{column_name}__#{path}"
        index_name = index_name.downcase.gsub(/[^a-z0-9]/, '_')

        # create the index
        execute "CREATE INDEX #{index_name} ON #{table_name}(xpath('#{path}',#{column_name}))"
      end

    
      # can call in any of the following ways
      # remove_xpath_index :users, :properties, '/xml/name'
      # remove_xpath_index :index_users_on_properties__xml_name
      # remove_xpath_index :users, :properties, '/xml/name', :index_users_on_properties__xml_name
      def remove_xpath_index index_name_or_table_name, column_name=nil, path=nil, index_name=nil
        # figure out which version was called
        index_name = index_name_or_table_name if !column_name

        # transform index name
        index_name ||= "index_#{table_name}_on_#{column_name}__#{path}"
        index_name = index_name.downcase.gsub(/[^a-z0-9]/, '_')
      
        # drop the index
        execute "DROP INDEX #{index_name}"
      end
      
      # TODO this doesn't get called -- why?
      # adding the xpath index should be reversible
      def invert_add_xpath_index(args)
        # table_name, column_name, path, index_name = *args
        # [:remove_index, [table_name, column_name, path, index_name]]
        [:remove_xpath_index, args]
      end
      
    end
  end
  
end
