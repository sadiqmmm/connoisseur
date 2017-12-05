require "connoisseur/service"
require "connoisseur/comment"

class Connoisseur::Client
  # Public: Initialize a Connoisseur client.
  #
  # key        - Your Akismet API key, obtained from https://akismet.com. The default
  #              is Connoisseur.api_key.
  # user_agent - The String value the client should provide in the User-Agent header when issuing
  #              HTTP requests to the Akismet API. The default is Connoisseur.user_agent.
  def initialize(key: Connoisseur.api_key, user_agent: Connoisseur.user_agent)
    @service = Connoisseur::Service.new(key: key, user_agent: user_agent)
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
    Connoisseur::Comment.define(@service, &block)
  end

  # Public: Verify the client's Akismet API key.
  #
  # blog - The URL of the blog associated with the key.
  #
  # Returns true or false indicating whether the key is valid for the given blog.
  def verify_key_for(blog:)
    @service.verify_key_for(blog: blog)
  end
end
