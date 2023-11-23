class DescribePhoto
  INSTRUCTIONS = <<~INSTRUCTIONS
  Please describe the facial and body features of a drawn character that looks like the person in the photo.
  The description should be detailed and include the gender, type of facial hair, ethnicity and other facial features.
  Only return the description, do not add any introduction or explanations to your answer.
  INSTRUCTIONS

  def initialize(photo_url)
    @photo_url = photo_url
  end

  def call
    client = OpenAI::Client.new
    messages = [
      { type: "text", text: INSTRUCTIONS },
      { type: "photo_url", image_url: { url: @photo_url } }
    ]
    puts '-' * 50
    puts "Sending request to OpenAI API to describe the character photo..."
    puts '-' * 50
    response = client.chat(parameters: {
      model: "gpt-4-vision-preview",
      messages: [{ role: "user", content: messages }],
      max_tokens: 2000,
    })
    p response.dig("choices", 0, "message", "content")
  end
end