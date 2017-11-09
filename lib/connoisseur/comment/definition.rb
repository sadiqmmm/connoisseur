class Connoisseur::Comment::Definition
  attr_reader :parameters

  def initialize
    @parameters = {}
  end

  def blog(url: nil, language: nil, charset: nil)
    define blog: url, blog_lang: language, blog_charset: charset
  end

  def post(url: nil, updated_at: nil)
    define permalink: url, comment_post_modified_gmt: updated_at&.utc&.iso8601
  end

  def request(ip_address: nil, user_agent: nil, referrer: nil)
    define user_ip: ip_address, user_agent: user_agent, referrer: referrer
  end

  def author(name: nil, email_address: nil, url: nil, role: nil)
    define comment_author: name, comment_author_email: email_address, comment_author_url: url, user_role: role
  end

  def type(type)
    define comment_type: type
  end

  def content(content)
    define comment_content: content
  end

  def created_at(created_at)
    define comment_date_gmt: created_at&.utc.iso8601
  end

  def test!
    define is_test: true
  end

  private

  def define(definitions)
    parameters.merge!(definitions.reject { |key, value| value.nil? })
  end
end
