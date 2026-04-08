#!/bin/bash

# Setup Flutter Environment
if [ ! -d "flutter" ]; then
    echo "Cloning Flutter SDK..."
    git clone https://github.com/flutter/flutter.git -b stable
fi
export PATH="$PATH:`pwd`/flutter/bin"

# Build Web App
echo "Building Flutter Web App..."
flutter config --enable-web
flutter pub get
flutter build web --release
