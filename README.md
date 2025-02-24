# AI in Rails & Service Objects

Note: 



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


Let's improve the prompt by asking GPT to generate a situation that is more detailed and interesting...



## Generating the prompt for the illustration

Let's create a GenerateSituation service object to generate the prompt, given a character description and a situation


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


```rb
# services/generate_situation.rb

  def call
    client = OpenAI::Client.new
    puts '-' * 50
    puts "Sending request to OpenAI API to generate a situation..."
    puts '-' * 50
    response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
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



## Updating the controller to use the new services

Let's add a method to attach the illustration to the character. This uses the same method as when [seeding images to Cloudinary from a URL](https://kitt.lewagon.com/camps/1885/lectures/content/lectures/rails/hosting-image-upload/index.html?title=Hosting+%26+Image+Upload#/5/8).

```rb
# character.rb

  def attach_illustration_from_url(url)
    illustrations.attach(io: URI.open(url), filename: "heroifyme_#{SecureRandom.hex(8)}.png")
  end
```

Don't forget to add `require "open-uri" at` the top of the file


Let's add a route to trigger it

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
    # 1. Find the character
    @character = Character.find(params[:character_id])

    # 2. Generate the prompt for the illustration
    detailed_situation = GenerateSituation.new(@character.description, @character.situation).call

    # 3. Generate the illustration
    illustration_url = GenerateIllustration.new(detailed_situation).call

    # 4. Attach the illustration to the character
    @character.attach_illustration_from_url(illustration_url)

    # 5. Redirect to the character show page
    redirect_to character_path(@character)
  end
```


## Generating the character description

Instead of having the user type out the character description, let's ask GPT to generate it from a photo.


Let's create a DescribePhoto service object

```rb
# services/describe_photo.rb

def call
    client = OpenAI::Client.new
    messages = [
      { role: "user", content: [
        { type: "text", text: INSTRUCTIONS },
        { type: "photo_url", image_url: { url: @photo_url } }
      ] }
    ]
    puts '-' * 50
    puts "Sending request to OpenAI API to describe the character photo..."
    puts '-' * 50
    response = client.chat(parameters: {
      model: "gpt-4o-mini",
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
class Character < ApplicationRecord
  after_commit :generate_description, on: :create

  # ...

  private

  def generate_description
    character_description = DescribePhoto.new(photo.url).call
    update(description: character_description)
  end
```


Update the form and the strong params to allow the photo upload

```rb
# characters/_form.html.erb
  <%= f.input :photo, as: :file, input_html: { accept: "image/*", capture: "camera" }, label: false %>
```

```rb
# characters_controller.rb
  def character_params
    params.require(:character).permit(:photo)
  end
```
