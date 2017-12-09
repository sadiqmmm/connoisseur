module Connoisseur
  class << self
    attr_accessor :key, :user_agent
  end
end

require "connoisseur/client"
