require "test_helper"

class Connoisseur::Comment::DefinitionTest < ActiveSupport::TestCase
  setup do
    @definition = Connoisseur::Comment::Definition.new
  end

  test "define blog" do
    @definition.blog url: "https://example.com", lang: "en", charset: "UTF-8"
    assert_equal({ blog: "https://example.com", blog_lang: "en", blog_charset: "UTF-8" }, @definition.to_hash)
  end

  test "define post" do
    @definition.post url: "https://example.com/posts/hello-world", updated_at: Time.parse("2017-09-24 12:00:00 EDT")

    assert_equal(
      {
        permalink: "https://example.com/posts/hello-world",
        comment_post_modified_gmt: "2017-09-24T16:00:00Z"
      },
      @definition.to_hash
    )
  end

  test "define request" do
    @definition.request ip_address: "24.29.18.175", user_agent: "Google Chrome", referrer: "https://example.com"

    assert_equal(
      {
        user_ip: "24.29.18.175",
        user_agent: "Google Chrome",
        referrer: "https://example.com"
      },
      @definition.to_hash
    )
  end

  test "define author without role" do
    @definition.author name: "Jane Smith", email_address: "jane@example.com"
    assert_equal({ comment_author: "Jane Smith", comment_author_email: "jane@example.com" }, @definition.to_hash)
  end

  test "define author with role" do
    @definition.author name: "Jane Smith", email_address: "jane@example.com", role: :administrator

    assert_equal(
      {
        comment_author: "Jane Smith",
        comment_author_email: "jane@example.com",
        user_role: :administrator
      },
      @definition.to_hash
    )
  end

  test "define type" do
    @definition.type "comment"
    assert_equal({ comment_type: "comment" }, @definition.to_hash)
  end

  test "define content" do
    @definition.content "Nice post!"
    assert_equal({ comment_content: "Nice post!" }, @definition.to_hash)
  end

  test "define creation time" do
    @definition.created_at Time.parse("2017-09-24 12:00:00 EDT")
    assert_equal({ comment_date_gmt: "2017-09-24T16:00:00Z" }, @definition.to_hash)
  end

  test "define test" do
    @definition.test!
    assert_equal({ is_test: true }, @definition.to_hash)
  end

  test "define everything" do
    @definition.blog url: "https://example.com", lang: "en", charset: "UTF-8"
    @definition.post url: "https://example.com/posts/hello-world", updated_at: Time.parse("2017-09-24 12:00:00 EDT")
    @definition.request ip_address: "24.29.18.175", user_agent: "Google Chrome", referrer: "https://example.com"
    @definition.author name: "Jane Smith", email_address: "jane@example.com", role: :administrator
    @definition.type "comment"
    @definition.content "Nice post!"
    @definition.created_at Time.parse("2017-09-24 12:00:00 EDT")
    @definition.test!

    assert_equal(
      {
        blog: "https://example.com",
        blog_lang: "en",
        blog_charset: "UTF-8",
        permalink: "https://example.com/posts/hello-world",
        comment_post_modified_gmt: "2017-09-24T16:00:00Z",
        user_ip: "24.29.18.175",
        user_agent: "Google Chrome",
        referrer: "https://example.com",
        comment_author: "Jane Smith",
        comment_author_email: "jane@example.com",
        user_role: :administrator,
        comment_type: "comment",
        comment_content: "Nice post!",
        comment_date_gmt: "2017-09-24T16:00:00Z",
        is_test: true
      },
      @definition.to_hash
    )
  end
end
