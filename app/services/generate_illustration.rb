class GenerateIllustration
  def initialize(situation)
    @situation = situation
  end

  def call
    client = OpenAI::Client.new
    puts '-' * 50
    puts "Sending request to OpenAI API to generate an illustration..."
    puts '-' * 50
    response = client.images.generate(parameters: { model: 'dall-e-3', prompt: @situation })

    p response.dig("data", 0, "url")
  end
end