class GeonameCity < ActiveRecord::Base
  @@cities = GeonameCity.find(:all, :select => :label).map(&:label) # init at load time
  def self.lookup(name)
    return @@cities.include?(name)
  end
end
