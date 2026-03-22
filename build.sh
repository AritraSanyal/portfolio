#!/bin/bash
set -e

# Install Flutter
if ! command -v flutter &> /dev/null; then
    echo "Installing Flutter..."
    git clone https://github.com/flutter/flutter.git -b stable --depth 1
    export PATH="$PATH:$PWD/flutter/bin"
fi

# Pre-cache Flutter
flutter precache --web

# Get dependencies
flutter pub get

# Build web
flutter build web

echo "Build complete!"
