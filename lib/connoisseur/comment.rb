class Connoisseur::Comment
  attr_reader :parameters

  # Internal: Define a comment via a DSL.
  #
  # service - A Connoisseur::Service for issuing relevant API requests.
  #
  # Yields a Comment::Definition for declaring the comment's attributes.
  #
  # Returns a Connoisseur::Comment.
  def self.define(service, &block)
    new service, parameters_for(&block)
  end

  # Internal: Generate a comment's parameters via the Definition DSL.
  #
  # Yields a Comment::Definition for declaring the comment's attributes.
  #
  # Returns a Hash of parameters.
  def self.parameters_for(&block)
    Definition.build(&block).parameters
  end

  # Internal: Initialize a Connoisseur::Comment.
  #
  # service    - A Connoisseur::Service for issuing relevant API requests.
  # parameters - A Hash of POST parameters describing the comment for use in API requests.
  def initialize(service, parameters)
    @service, @parameters = service, parameters
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
    @service.check(@parameters)
  end

  # Public: Inform Akismet that the comment should have been marked spam.
  #
  # Returns nothing.
  def spam!
    @service.spam!(@parameters)
  end

  # Public: Inform Akismet that the comment should have been marked ham.
  #
  # Returns nothing.
  def ham!
    @service.ham!(@parameters)
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
