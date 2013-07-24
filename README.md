# pg-xml

Heavily based on `pg-hstore` and `activerecord-postgres-hstore` gems.

Use:

`gem 'pg-xml'`

to include it.

This does two things:

##Nice XML-object attribute
  
Define an XML column type in your model

```ruby
class User < ActiveRecord::Base
  has_xml_column :properties
end
```

This will

* validate the XML before saving
* serialize and deserialize it as an XML object
* allow you to use properties = '<xml/>' to set an XML object

  
##Nice xpath indexing
  
To me this is the whole point of XML as a datatype in postgres
is that you can index into it.

```ruby
class AddIndexToPersonFirstName < ActiveRecord::Migration
  def change
    add_xpath_index :users, :properties, '/xml/first_name'
  end 
end
```

##Known issues

I've used it with nokogiri. I sort of tried to make it work with Hpricot also
but I didn't follow through on that.

It also doesn't have specs to test.

And the migrations aren't properly reversible.
