class Connoisseur::Comment
  attr_reader :client, :definition

  def initialize(client)
    @client, @definition = client, Definition.new

    yield @definition
  end

  def check
    client.check parameters
  end

  def spam!
    client.spam! parameters
  end

  def ham!
    client.ham! parameters
  end

  def update!(spam:)
    if spam
      spam!
    else
      ham!
    end
  end

  private

  def parameters
    definition.parameters
  end
end

require "connoisseur/comment/definition"
