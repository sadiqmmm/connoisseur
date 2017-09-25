class Connoisseur::Comment::Definition
  def initialize
    @attributes = {}
  end

  def blog(url: nil, lang: nil, charset: nil)
    define blog: url, blog_lang: lang, blog_charset: charset
  end

  def post(url: nil, updated_at: nil)
    define permalink: url, comment_post_modified_gmt: format_time(updated_at)
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
    define comment_date_gmt: format_time(created_at)
  end

  def test!
    define is_test: true
  end

  def to_hash
    @attributes
  end

  private

  def define(attributes)
    @attributes.merge!(attributes.compact)
  end

  def format_time(time)
    return if time.nil?

    if time.respond_to?(:utc)
      time.utc.iso8601
    else
      time.to_s
    end
  end
end
