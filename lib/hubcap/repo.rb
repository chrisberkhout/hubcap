module Hubcap
  class Repo < Hash
    
    def initialize(data)
      super().merge!(data)
    end

    def first_commit_week
      ensure_has_participation_data
      self["participation"].index{ |x| x != 0 } || self["participation"].length
    end

    def last_commit_week
      ensure_has_participation_data
      reversed_index = self["participation"].reverse.index{ |x| x != 0 } || -self["participation"].length
      (self["participation"].length-1) - reversed_index
    end

    protected
    
    def ensure_has_participation_data
      raise "No participation data in repo #{self['name']}!" unless self["participation"]
    end
    
  end
end
