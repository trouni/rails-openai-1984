
```rb
# Character#generate_description
after_commit :generate_description, on: :create

def generate_description
  character_description = DescribePhoto.new(photo.url).call
  update(description: character_description)
end
```

```rb
# DescribePhoto
  INSTRUCTIONS = <<~INSTRUCTIONS
  Please describe the facial and body features of a drawn character that looks like the person in the photo.
  The description should be detailed and include the gender, type of facial hair, ethnicity and other facial features.
  Only return the description, do not add any introduction or explanations to your answer.
  INSTRUCTIONS
```


`illustration#create`

```rb
# GenerateSituation
  INSTRUCTIONS = <<~INSTRUCTIONS
  Create a prompt to generate a detailed superhero comic style image that illustrates the situation in the next message.
  The image description should take the character described previously and make it the main protagonist of the image as a superhero.
  You should include a detailed description of the character's facial features so that it can be drawn accurately.
  You can add details to the situation that are easy to draw and that build on the original situation to make it more interesting or fun.
  Start answering directly with the situation, without any introduction or explanation.
  INSTRUCTIONS
```