class Connoisseur::Comment
  attr_reader :client, :definition

  def initialize(client)
    @client, @definition = client, Definition.new

    yield @definition
  end

  def check
    client.check definition
  end

  def spam!
    client.spam! definition
  end

  def ham!
    client.ham! definition
  end

  def update!(spam:)
    if spam
      spam!
    else
      ham!
    end
  end
end

require "connoisseur/comment/definition"
