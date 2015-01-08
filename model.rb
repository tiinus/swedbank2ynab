require 'yaml'

# Representation of categories used for transactions. 
class Categories
  
  def initialize()
    # structure contaning patterns to identify a category.
    @lookup = YAML.load_file("categories.yml")
  end

  def category_for(payee)
    return if !@lookup
    @lookup.keys.find{|category|
      @lookup[category].any?{|pattern| 
        payee.upcase.include? pattern.upcase
      } 
    }
  end

end

# Transaction 
class Transaction

  attr_reader :date, :payee, :amount, :category

  @@categories = Categories.new()

  def initialize(date, payee, amount)
    @date = date
    @payee = payee
    @amount = amount
    @category = @@categories.category_for(payee)
  end

end