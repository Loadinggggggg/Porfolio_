from PIL import Image
import os
import random

def randomize_colors(image_path, output_folder, num_variations):
    original_image = Image.open(image_path)
    width, height = original_image.size

    # Ensure the output folder exists
    os.makedirs(output_folder, exist_ok=True)

    for variation in range(num_variations):
        # Create a copy of the original image
        modified_image = original_image.copy()

        # Randomize RGB values for the entire image
        red_intensity = random.randint(0, 255)
        green_intensity = random.randint(0, 255)
        blue_intensity = random.randint(0, 255)

        # Process every pixel
        for x in range(width):
            for y in range(height):
                # Get pixel color
                current_color = modified_image.getpixel((x, y))

                # Apply the random intensities to each channel
                new_color = (
                    (current_color[0] + red_intensity) % 200,
                    (current_color[1] + green_intensity) % 100,
                    (current_color[2] + blue_intensity) % 50,
                )

                # Put the new color on the pixel
                modified_image.putpixel((x, y), new_color)

        # Save the modified image with a unique filename
        output_path = os.path.join(output_folder, f"variation_{variation + 1}.jpg")
        modified_image.save(output_path)

if __name__ == "__main__":
    # Specify the path to the input image
    input_image_path = "/Users/liliamarzougui/Desktop/Sample/sample.jpg"

    # Specify the folder where the output images will be saved
    output_folder = "/Users/liliamarzougui/Desktop/Sample/variations1"

    # Specify the number of variations
    num_variations = 100

    # Generate 100 different variations
    randomize_colors(input_image_path, output_folder, num_variations)

