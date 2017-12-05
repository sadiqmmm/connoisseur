require "connoisseur/result"

class Connoisseur::Service
  # Internal: Initialize a Connoisseur service.
  #
  # key        - An Akismet API key, obtained from https://akismet.com.
  # user_agent - The String value the service should provide in the User-Agent header when issuing
  #              HTTP requests to the Akismet API.
  def initialize(key:, user_agent:)
    @key, @user_agent = key, user_agent

    require_usable_key
  end

  # Internal: Determine whether a comment is spam or ham.
  #
  # comment - A Hash of POST parameters describing the comment.
  #
  # Returns a Connoisseur::Result.
  # Raises Connoisseur::Result::InvalidError if the Akismet API provides an unexpected response.
  def check(comment)
    Connoisseur::Result.new(post("comment-check", body: comment)).validated
  end

  # Internal: Inform Akismet that a comment should have been marked spam.
  #
  # comment - A Hash of POST parameters describing the comment.
  #
  # Returns nothing.
  def spam!(comment)
    post "submit-spam", body: comment
  end

  # Internal: Inform Akismet that a comment should have been marked ham.
  #
  # comment - A Hash of POST parameters describing the comment.
  #
  # Returns nothing.
  def ham!(comment)
    post "submit-ham", body: comment
  end

  # Public: Verify the client's Akismet API key.
  #
  # blog - The URL of the blog associated with the key.
  #
  # Returns true or false indicating whether the key is valid for the given blog.
  def verify_key_for(blog:)
    post_without_subdomain("verify-key", body: { key: key, blog: blog }).body == "valid"
  end

  private

  attr_reader :key, :user_agent

  def require_usable_key
    raise ArgumentError, "Expected Akismet API key, got #{key.inspect}" if !key || key =~ /\A[[:space:]]*\z/
  end


  def post(endpoint, body:)
    Net::HTTP.post URI("https://#{key}.rest.akismet.com/1.1/#{endpoint}"),
      URI.encode_www_form(body), headers
  end

  def post_without_subdomain(endpoint, body:)
    Net::HTTP.post URI("https://rest.akismet.com/1.1/#{endpoint}"),
      URI.encode_www_form(body), headers
  end

  def headers
    { "User-Agent" => user_agent }
  end
end
