class GeonameCity < ActiveRecord::Base
  @@cities = GeonameCity.find(:all, :select => :label).map(&:label) # init at load time
  # in-memory boolean lookup function; if it returns true, caller is expected to use activerecord methods to find the actual record, e.g. GeonameCity.find_by_label(:first, name)
  def self.lookup(name)
    return @@cities.include?(name)
  end
end
