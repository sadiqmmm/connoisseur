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
client = Connoisseur::Client.new(api_key: "...", user_agent: "...")
```

Build a comment:

```ruby
comment = client.comment do |c|
  c.blog "..."
  c.user_ip "..."
  c.user_agent "..."
  c.referrer "..."
  c.comment_content "..."
  # ...
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

For convenience, set your Akismet API key and user agent globally (e.g. in a Rails initializer):

```ruby
Connoisseur.api_key = "..."
Connoisseur.user_agent = "..."

client = Connoisseur::Client.new
```

## License

Copyright (c) 2017 George Claghorn.

Connoisseur is released under the terms of the MIT license. See `LICENSE` for details.
