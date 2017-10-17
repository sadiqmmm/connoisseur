class Connoisseur::Comment
  attr_reader :client, :parameters

  # Internal: Define a comment via a DSL.
  #
  # client - A Connoisseur::Client through which API requests concerning the comment can be issued.
  #
  # Yields a Comment::Definition which can be used to declare the comment's attributes.
  #
  # Returns a Connoisseur::Comment.
  def self.define(client)
    new client, Definition.new.tap { |definition| yield definition }.parameters
  end

  def initialize(client, parameters)
    @client, @parameters = client, parameters
  end

  # Public: Determine whether a comment is spam or ham.
  #
  # Examples
  #
  #   result = comment.check
  #   result.spam?
  #   result.valid?
  #
  # Returns a Connoisseur::Result.
  # Raises Connoisseur::Result::Invalid if the Akismet API provides an unexpected response.
  def check
    client.check parameters
  end

  # Public: Inform Akismet that the comment should have been marked spam.
  #
  # Returns nothing.
  def spam!
    client.spam! parameters
  end

  # Public: Inform Akismet that the comment should have been marked ham.
  #
  # Returns nothing.
  def ham!
    client.ham! parameters
  end

  # Public: Inform Akismet that the comment was incorrectly classified.
  #
  # spam - A boolean indicating whether the comment should have been marked spam.
  #
  # Returns nothing.
  def update!(spam:)
    if spam
      spam!
    else
      ham!
    end
  end
end

require "connoisseur/comment/definition"
