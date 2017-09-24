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
      .with(body: "comment_content=Hello%2C%20world%21", headers: { "User-Agent" => "Connoisseur Tests" })
      .to_return(status: 200, body: "false")

    result = @comment.check
    assert_not result.spam?
    assert_not result.discard?
  end

  test "check spam" do
    stub_request(:post, "https://secret.rest.akismet.com/1.1/comment-check")
      .with(body: "comment_content=Hello%2C%20world%21", headers: { "User-Agent" => "Connoisseur Tests" })
      .to_return(status: 200, body: "true")

    result = @comment.check
    assert result.spam?
    assert_not result.discard?
  end

  test "check discardable spam" do
    stub_request(:post, "https://secret.rest.akismet.com/1.1/comment-check")
      .with(body: "comment_content=Hello%2C%20world%21", headers: { "User-Agent" => "Connoisseur Tests" })
      .to_return(status: 200, body: "true", headers: { "X-Akismet-Pro-Tip" => "discard" })

    result = @comment.check
    assert result.spam?
    assert result.discard?
  end

  test "check returning error status" do
    stub_request(:post, "https://secret.rest.akismet.com/1.1/comment-check")
      .with(body: "comment_content=Hello%2C%20world%21", headers: { "User-Agent" => "Connoisseur Tests" })
      .to_return(status: 500, body: "false")

    assert_raises Connoisseur::Result::Invalid do
      @comment.check
    end
  end

  test "check returning unexpected body" do
    stub_request(:post, "https://secret.rest.akismet.com/1.1/comment-check")
      .with(body: "comment_content=Hello%2C%20world%21", headers: { "User-Agent" => "Connoisseur Tests" })
      .to_return(status: 200, body: "Oops!")

    assert_raises Connoisseur::Result::Invalid do
      @comment.check
    end
  end


  test "submit spam" do
    @comment.spam!

    assert_requested :post, "https://secret.rest.akismet.com/1.1/submit-spam",
      body: "comment_content=Hello%2C%20world%21", headers: { "User-Agent" => "Connoisseur Tests" }
  end

  test "submit ham" do
    @comment.ham!

    assert_requested :post, "https://secret.rest.akismet.com/1.1/submit-ham",
      body: "comment_content=Hello%2C%20world%21", headers: { "User-Agent" => "Connoisseur Tests" }
  end


  test "update to spam" do
    @comment.update! spam: true

    assert_requested :post, "https://secret.rest.akismet.com/1.1/submit-spam",
      body: "comment_content=Hello%2C%20world%21", headers: { "User-Agent" => "Connoisseur Tests" }
  end

  test "update to ham" do
    @comment.update! spam: false

    assert_requested :post, "https://secret.rest.akismet.com/1.1/submit-ham",
      body: "comment_content=Hello%2C%20world%21", headers: { "User-Agent" => "Connoisseur Tests" }
  end
end
