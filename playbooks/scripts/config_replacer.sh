#!/bin/bash

env_file=".env"

if [ -f "$env_file" ]; then
  source "$env_file"
else
  echo "File $env_file not found in current directory"
  exit 1
fi

# environment variables
current_directory=$(pwd)
project_folder=$(dirname "$current_directory")

config_files=(
    "src/main/resources/cache.properties"
    "src/main/resources/cors.properties"
    "src/main/resources/hibernate.properties"
    "src/main/resources/jwt.properties"
    "src/main/resources/mail.properties"
    "src/main/resources/mongo.properties"
    "src/main/resources/social.properties"
    "src/test/resources/cors.properties"
    "src/test/resources/hibernatetest.properties"
    "src/test/resources/mail.properties"
)

replace_placeholders() {
  local file="$1"
  while IFS= read -r line; do
    key=$(echo "$line" | sed 's/\${//;s/}//')
    value=$(echo "${!key}")
    sed -i "s|\${$key}|$value|g" "$file"
  done < <(grep -o "\${[A-Za-z_][A-Za-z_0-9]*}" "$file")
}

for file in "${config_files[@]}"; do
  if [ -f "$project_folder/$file" ]; then
    replace_placeholders "$project_folder/$file"
    echo "Placeholders replaced in $file."
  else
    echo "Warning: $file not found."
  fi
done