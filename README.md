# Connoisseur

Connoisseur is a Ruby client for the [Akismet](https://akismet.com) spam filtering service.

## Installation

Add Connoisseur to your app’s Gemfile and run `bundle install`:

```ruby
gem "connoisseur"
```

## Usage

Initialize a Connoisseur client:

```ruby
client = Connoisseur::Client.new(key: "...", user_agent: "...")
```

Build a comment:

```ruby
comment = client.comment do |c|
  c.blog url: "...", language: "en", charset: "UTF-8"
  c.post url: "...", updated_at: Time.now
  c.request ip_address: "127.0.0.1", user_agent: "...", referrer: "..."
  c.author name: "...", email_address: "..." #, role: :administrator

  c.type       "comment"
  c.content    "..."
  c.created_at Time.now

  # Flag the comment for use in test queries:
  # c.test!
end
```

Determine whether a comment is spam or ham:

```ruby
result = comment.check
result.spam?
result.discard?
```

Inform Akismet that a comment should have been marked spam:

```ruby
comment.spam!
comment.update! spam: true
```

Inform Akismet that a comment should have been marked ham:

```ruby
comment.ham!
comment.update! spam: false
```

Verify your Akismet API key:

```ruby
if client.verify_key_for(blog: "https://example.com")
  # All's well.
else
  # The key is invalid for the given blog.
end
```

For convenience, set your Akismet API key and user agent globally (e.g. in a Rails initializer):

```ruby
Connoisseur.key = "..."
Connoisseur.user_agent = "..."

client = Connoisseur::Client.new
```

## Requirements

Connoisseur requires Ruby 2.4.0 or newer. It has no third-party dependencies.

## License

Copyright (c) 2017 George Claghorn.

Connoisseur is released under the terms of the MIT license. See `LICENSE` for details.
