# Generate 128 hex values from 0 to 128 in decimal
hex_values = [hex(i) for i in range(128)]

# Create a string with hex values separated by newline characters
hex_string = '\n'.join(hex_values)

# Write the hex values to a file
file_path = 'hex_values.txt'
with open(file_path, 'w') as file:
    file.write(hex_string)

print("Hex values have been written to {file_path}")
