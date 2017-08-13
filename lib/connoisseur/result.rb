class Connoisseur::Result
  class Invalid < StandardError; end

  def initialize(response)
    @response = response
  end

  def spam?
    response.body == "true"
  end

  def discard?
    response.headers["X-Akismet-Pro-Tip"] == "discard"
  end


  def validated
    require_successful_response
    require_boolean_response_body

    self
  end

  private

  attr_reader :response

  def require_successful_response
    raise Invalid, "Expected successful response, got #{response.code}" unless response.success?
  end

  def require_boolean_response_body
    raise Invalid, "Expected boolean response body, got #{response.body.inspect}" unless %w( true false ).include?(response.body)
  end
end
