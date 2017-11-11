class Connoisseur::Result
  class InvalidError < StandardError; end

  # Internal: Initialize a Connoisseur::Result.
  #
  # response - An HTTParty::Response from a comment check request.
  def initialize(response)
    @response = response
  end

  # Public: Determine whether the comment is spam.
  #
  # Returns a boolean indicating whether Akismet recognizes the comment as spam.
  def spam?
    response.body == "true"
  end

  # Public: Determine whether the comment is egregious spam which should be discarded.
  #
  # Returns a boolean indicating whether Akismet recommends discarding the comment.
  def discard?
    response.headers["X-Akismet-Pro-Tip"] == "discard"
  end

  # Internal: Validate the response from the Akismet API.
  #
  # Ensures that the response has a successful status code (in the range 200...300) and that the
  # response body is a boolean ("true" or "false").
  #
  # Returns the receiving Result.
  # Raises Connoisseur::Result::InvalidError if the Akismet API provided an unexpected response.
  def validated
    require_successful_response
    require_boolean_response_body

    self
  end

  private

  attr_reader :response

  def require_successful_response
    raise InvalidError, "Expected successful response, got #{response.code}" unless response.success?
  end

  def require_boolean_response_body
    unless %w( true false ).include?(response.body)
      if message = response.headers["X-Akismet-Debug-Help"]
        raise InvalidError, "Expected boolean response body, got #{response.body.inspect} (#{message})"
      else
        raise InvalidError, "Expected boolean response body, got #{response.body.inspect}"
      end
    end
  end
end
