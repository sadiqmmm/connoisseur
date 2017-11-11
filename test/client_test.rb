require "test_helper"

class Connoisseur::ClientTest < ActiveSupport::TestCase
  setup do
    @client = Connoisseur::Client.new

    @comment = @client.comment do |c|
      c.content "Hello, world!"
    end
  end

  test "check ham" do
    stub_request(:post, "https://secret.rest.akismet.com/1.1/comment-check")
      .with(body: "comment_content=Hello%2C+world%21", headers: { "User-Agent" => "Connoisseur Tests" })
      .to_return(status: 200, body: "false")

    result = @comment.check
    assert_not result.spam?
    assert_not result.discard?
  end

  test "check spam" do
    stub_request(:post, "https://secret.rest.akismet.com/1.1/comment-check")
      .with(body: "comment_content=Hello%2C+world%21", headers: { "User-Agent" => "Connoisseur Tests" })
      .to_return(status: 200, body: "true")

    result = @comment.check
    assert result.spam?
    assert_not result.discard?
  end

  test "check discardable spam" do
    stub_request(:post, "https://secret.rest.akismet.com/1.1/comment-check")
      .with(body: "comment_content=Hello%2C+world%21", headers: { "User-Agent" => "Connoisseur Tests" })
      .to_return(status: 200, body: "true", headers: { "X-Akismet-Pro-Tip" => "discard" })

    result = @comment.check
    assert result.spam?
    assert result.discard?
  end

  test "check returning error status" do
    stub_request(:post, "https://secret.rest.akismet.com/1.1/comment-check")
      .with(body: "comment_content=Hello%2C+world%21", headers: { "User-Agent" => "Connoisseur Tests" })
      .to_return(status: 500, body: "false")

    error = assert_raises Connoisseur::Result::InvalidError do
      @comment.check
    end

    assert_equal 'Expected successful response, got 500', error.message
  end

  test "check returning unexpected body without help" do
    stub_request(:post, "https://secret.rest.akismet.com/1.1/comment-check")
      .with(body: "comment_content=Hello%2C+world%21", headers: { "User-Agent" => "Connoisseur Tests" })
      .to_return(status: 200, body: "invalid")

    error = assert_raises Connoisseur::Result::InvalidError do
      @comment.check
    end

    assert_equal 'Expected boolean response body, got "invalid"', error.message
  end

  test "check returning unexpected body with help" do
    stub_request(:post, "https://secret.rest.akismet.com/1.1/comment-check")
      .with(body: "comment_content=Hello%2C+world%21", headers: { "User-Agent" => "Connoisseur Tests" })
      .to_return(status: 200, body: "invalid", headers: { "X-Akismet-Debug-Help" => "We were unable to parse your blog URI" })

    error = assert_raises Connoisseur::Result::InvalidError do
      @comment.check
    end

    assert_equal 'Expected boolean response body, got "invalid" (We were unable to parse your blog URI)', error.message
  end


  test "submit spam" do
    @comment.spam!

    assert_requested :post, "https://secret.rest.akismet.com/1.1/submit-spam",
      body: "comment_content=Hello%2C+world%21", headers: { "User-Agent" => "Connoisseur Tests" }
  end

  test "submit ham" do
    @comment.ham!

    assert_requested :post, "https://secret.rest.akismet.com/1.1/submit-ham",
      body: "comment_content=Hello%2C+world%21", headers: { "User-Agent" => "Connoisseur Tests" }
  end


  test "update to spam" do
    @comment.update! spam: true

    assert_requested :post, "https://secret.rest.akismet.com/1.1/submit-spam",
      body: "comment_content=Hello%2C+world%21", headers: { "User-Agent" => "Connoisseur Tests" }
  end

  test "update to ham" do
    @comment.update! spam: false

    assert_requested :post, "https://secret.rest.akismet.com/1.1/submit-ham",
      body: "comment_content=Hello%2C+world%21", headers: { "User-Agent" => "Connoisseur Tests" }
  end


  test "verify key successfully" do
    stub_request(:post, "https://rest.akismet.com/1.1/verify-key")
      .with(body: "key=secret&blog=https%3A%2F%2Fexample.com", headers: { "User-Agent" => "Connoisseur Tests" })
      .to_return(status: 200, body: "valid")

    assert @client.verify_key_for(blog: "https://example.com")
  end

  test "verify key unsuccessfully" do
    stub_request(:post, "https://rest.akismet.com/1.1/verify-key")
      .with(body: "key=secret&blog=https%3A%2F%2Fexample.com", headers: { "User-Agent" => "Connoisseur Tests" })
      .to_return(status: 200, body: "invalid")

    assert_not @client.verify_key_for(blog: "https://example.com")
  end
end
