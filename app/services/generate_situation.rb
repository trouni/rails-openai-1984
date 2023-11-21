class GenerateSituation
  INSTRUCTIONS = <<~INSTRUCTIONS
  Create a prompt to generate a detailed superhero comic style image that illustrates the situation in the next message.
  The image description should be centered around the character described previously.
  You should include a detailed description of the character so that it can be drawn accurately.
  You can add details to the situation that are easy to draw and that build on the original situation to make it more interesting or fun.
  Start answering directly with the situation, without any introduction or explanation.
  INSTRUCTIONS

  def initialize(character_description, situation)
    @situation = situation
    @character_description = character_description
  end

  def call
    client = OpenAI::Client.new
    puts '-' * 50
    puts "Sending request to OpenAI API to generate a situation..."
    puts '-' * 50
    response = client.chat(
      parameters: {
        model: "gpt-4-1106-preview",
        messages: [
          { role: "user", content: "Here is a character description: #{@character_description}"},
          { role: "user", content: INSTRUCTIONS },
          { role: "user", content: "The character is #{@situation}" },
        ],
        temperature: 0.7,
    })
    p response.dig("choices", 0, "message", "content")
  end
end