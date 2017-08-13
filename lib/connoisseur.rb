module Connoisseur
  class << self
    attr_accessor :api_key, :user_agent
  end
end

require "connoisseur/client"
