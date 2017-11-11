require "httparty"
require "connoisseur/comment"
require "connoisseur/result"

class Connoisseur::Client
  # Public: Initialize a Connoisseur client.
  #
  # key        - Your Akismet API key, obtained from https://akismet.com. The default
  #              is Connoisseur.api_key.
  # user_agent - The String value the client should provide in the User-Agent header when issuing
  #              HTTP requests to the Akismet API. The default is Connoisseur.user_agent.
  def initialize(key: Connoisseur.api_key, user_agent: Connoisseur.user_agent)
    @key, @user_agent = key, user_agent

    require_usable_key
  end

  # Public: Build a comment.
  #
  # Yields a Connoisseur::Comment::Definition for declaring the comment's attributes.
  #
  # Examples
  #
  #   client.comment do |c|
  #     c.blog url: "https://example.com"
  #     c.post url: "https://example.com/posts/hello-world"
  #     c.author name: "Jane Smith"
  #     c.content "Nice post!"
  #   end
  #   # => #<Connoisseur::Comment ...>
  #
  # Returns a Connoisseur::Comment.
  def comment(&block)
    Connoisseur::Comment.define self, &block
  end

  # Public: Verify the client's Akismet API key.
  #
  # blog - The URL of the blog associated with the key.
  #
  # Returns true or false indicating whether the key is valid for the given blog.
  def verify_key_for(blog:)
    post_without_subdomain("verify-key", body: { key: key, blog: blog }).body == "valid"
  end

  # Internal: Determine whether a comment is spam or ham.
  #
  # comment - A Hash of POST parameters describing the comment.
  #
  # Returns a Connoisseur::Result.
  # Raises Connoisseur::Result::Invalid if the Akismet API provides an unexpected response.
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

  private

  attr_reader :key, :user_agent

  def require_usable_key
    raise ArgumentError, "Expected Akismet API key, got #{key.inspect}" if !key || key =~ /\A[[:space:]]*\z/
  end


  def post(endpoint, body:)
    HTTParty.post "https://#{key}.rest.akismet.com/1.1/#{endpoint}", headers: headers, body: body
  end

  def post_without_subdomain(endpoint, body:)
    HTTParty.post "https://rest.akismet.com/1.1/#{endpoint}", headers: headers, body: body
  end

  def headers
    { "User-Agent" => user_agent }
  end
end
