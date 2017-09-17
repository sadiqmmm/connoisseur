require "httparty"
require "connoisseur/comment"
require "connoisseur/result"

class Connoisseur::Client
  attr_reader :key, :user_agent

  def initialize(key: Connoisseur.api_key, user_agent: Connoisseur.user_agent)
    @key, @user_agent = key, user_agent

    require_usable_key
  end

  def comment(&block)
    Connoisseur::Comment.new self, &block
  end


  def check(comment)
    validated_result_from post("comment-check", body: comment)
  end

  def spam!(comment)
    post "submit-spam", body: comment
  end

  def ham!(comment)
    post "submit-ham", body: comment
  end

  private

  def require_usable_key
    raise ArgumentError, "Expected Akismet API key, got #{key.inspect}" unless key.present?
  end


  def post(endpoint, body:)
    HTTParty.post "https://#{key}.rest.akismet.com/1.1/#{endpoint}",
      headers: { "User-Agent" => user_agent }, body: body
  end

  def validated_result_from(response)
    Connoisseur::Result.new(response).validated
  end
end
