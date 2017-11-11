class Connoisseur::Comment
  attr_reader :client, :parameters

  # Internal: Define a comment via a DSL.
  #
  # client - A Connoisseur::Client for issuing relevant API requests.
  #
  # Yields a Comment::Definition for declaring the comment's attributes.
  #
  # Returns a Connoisseur::Comment.
  def self.define(client, &block)
    new client, Definition.new.tap(&block).parameters
  end

  # Internal: Initialize a Connoisseur::Comment.
  #
  # client     - A Connoisseur::Client for issuing relevant API requests.
  # parameters - A Hash of POST parameters describing the comment for use in API requests.
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
  # Raises Connoisseur::Result::InvalidError if the Akismet API responds unexpectedly.
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

  # Public: Inform Akismet that it incorrectly classified the comment.
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
