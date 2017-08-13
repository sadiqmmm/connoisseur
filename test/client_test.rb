require "test_helper"

class Connoisseur::ClientTest < ActiveSupport::TestCase
  setup do
    @client = Connoisseur::Client.new
  end

  test "check ham" do
    stub_request(:post, "https://secret.rest.akismet.com/1.1/comment-check")
      .with(body: "comment_content=Hello%2C%20world%21", headers: { "User-Agent" => "Connoisseur Tests" })
      .to_return(status: 200, body: "false")

    result = @client.check(comment_content: "Hello, world!")
    assert_not result.spam?
    assert_not result.discard?
  end

  test "check spam" do
    stub_request(:post, "https://secret.rest.akismet.com/1.1/comment-check")
      .with(body: "comment_content=Hello%2C%20world%21", headers: { "User-Agent" => "Connoisseur Tests" })
      .to_return(status: 200, body: "true")

    result = @client.check(comment_content: "Hello, world!")
    assert result.spam?
    assert_not result.discard?
  end

  test "check discardable spam" do
    stub_request(:post, "https://secret.rest.akismet.com/1.1/comment-check")
      .with(body: "comment_content=Hello%2C%20world%21", headers: { "User-Agent" => "Connoisseur Tests" })
      .to_return(status: 200, body: "true", headers: { "X-Akismet-Pro-Tip" => "discard" })

    result = @client.check(comment_content: "Hello, world!")
    assert result.spam?
    assert result.discard?
  end

  test "check returning error status" do
    stub_request(:post, "https://secret.rest.akismet.com/1.1/comment-check")
      .with(body: "comment_content=Hello%2C%20world%21", headers: { "User-Agent" => "Connoisseur Tests" })
      .to_return(status: 500, body: "false")

    assert_raises Connoisseur::Result::Invalid do
      @client.check comment_content: "Hello, world!"
    end
  end

  test "check returning unexpected body" do
    stub_request(:post, "https://secret.rest.akismet.com/1.1/comment-check")
      .with(body: "comment_content=Hello%2C%20world%21", headers: { "User-Agent" => "Connoisseur Tests" })
      .to_return(status: 200, body: "Oops!")

    assert_raises Connoisseur::Result::Invalid do
      @client.check comment_content: "Hello, world!"
    end
  end


  test "submit spam" do
    @client.spam! comment_content: "Hello, world!"

    assert_requested :post, "https://secret.rest.akismet.com/1.1/submit-spam",
      body: "comment_content=Hello%2C%20world%21", headers: { "User-Agent" => "Connoisseur Tests" }
  end

  test "submit ham" do
    @client.ham! comment_content: "Hello, world!"

    assert_requested :post, "https://secret.rest.akismet.com/1.1/submit-ham",
      body: "comment_content=Hello%2C%20world%21", headers: { "User-Agent" => "Connoisseur Tests" }
  end
end
