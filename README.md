# AI in Rails & Service Objects



## Service objects



## Generating the illustration

Let's create a GenerateIllustration service object

```rb
# services/generate_illustration.rb

  def call
    client = OpenAI::Client.new
    puts '-' * 50
    puts "Sending request to OpenAI API to generate an illustration..."
    puts '-' * 50
    response = client.images.generate(parameters: { model: 'dall-e-3', prompt: @situation })

    p response.dig("data", 0, "url")
  end
```


Let's add a method to attach the illustration to the character

```rb
# character.rb

  def attach_illustration_from_url(url)
    illustrations.attach(io: URI.open(url), filename: "heroifyme_#{SecureRandom.hex(8)}.png")
  end
```

Don't forget to add `require "open-uri" at` the top of the file


Let's add an endpoint to trigger it

```rb
# routes.rb

  resources :characters, only: %i[show create] do
    resources :illustrations, only: :create
  end
```


```rb
# characters_controller.rb

# POST characters/:character_id/illustrations#create
  def create
    @character = Character.find(params[:character_id])
    illustration_url = GenerateIllustration.new(detailed_situation).call
    @character.attach_illustration_from_url(illustration_url)
    redirect_to character_path(@character)
  end
```



## Generating the prompt for the illustration

Let's create a GenerateSituation service object to improve the prompt

```rb
# services/generate_situation.rb

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
```


```rb
# services/generate_situation.rb

  INSTRUCTIONS = <<~INSTRUCTIONS
  Create a prompt to generate a detailed superhero comic style image that illustrates the situation in the next message.
  The image description should take the character described previously and make it the main protagonist of the image as a superhero.
  You should include a detailed description of the character's facial features so that it can be drawn accurately.
  You can add details to the situation that are easy to draw and that build on the original situation to make it more interesting or fun.
  Start answering directly with the situation, without any introduction or explanation.
  INSTRUCTIONS
```



## Generating the character description

Let's create a DescribePhoto service object

```rb
# services/describe_photo.rb

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
```


```rb
# services/describe_photo.rb

  INSTRUCTIONS = <<~INSTRUCTIONS
  Please describe the facial and body features of a drawn character that looks like the person in the photo.
  The description should be detailed and include the gender, type of facial hair, ethnicity and other facial features.
  Only return the description, do not add any introduction or explanations to your answer.
  INSTRUCTIONS
```


Let's generate the description after the character is created

```rb
# Character#generate_description
after_commit :generate_description, on: :create

def generate_description
  character_description = DescribePhoto.new(photo.url).call
  update(description: character_description)
end
```



## Final touches

Let's add the photo to the character show page

```rb
<%= cl_image_tag @character.photo.key, width: 150, height: 150, crop: :thumb, gravity: :face, class: 'avatar' %>
```