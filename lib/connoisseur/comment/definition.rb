class Connoisseur::Comment::Definition
  def initialize
    @attributes = {}
  end

  def define(name, value)
    @attributes[name] = value
  end

  def to_hash
    @attributes
  end

  private

  def method_missing(name, *args)
    define name, *args
  end

  def respond_to_missing?(name, include_private = false)
    true
  end
end
