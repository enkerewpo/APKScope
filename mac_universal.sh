#!/bin/bash

# ./mac_universal.sh . APKScope

PROJECT_PATH=$1
PROJECT_NAME=$2

echo "Building universal binary for $PROJECT_NAME at $PROJECT_PATH"

OUTPUT_DIR="${PROJECT_PATH}/bin/Release/net9.0"
FINAL_OUTPUT_DIR="${PROJECT_PATH}/bin/Release/Universal"

cd "$PROJECT_PATH"

# Function to build for a specific architecture
build_for_arch() {
    local arch=$1
    echo "Building for $arch..."
    dotnet publish -r osx-$arch -c Release
}

# Build for both architectures
build_for_arch "x64"
build_for_arch "arm64"

# Create the final output directory
mkdir -p "$FINAL_OUTPUT_DIR"

# Create universal binary
echo "Creating universal binary..."
lipo -create \
    "$OUTPUT_DIR/osx-x64/publish/$PROJECT_NAME" \
    "$OUTPUT_DIR/osx-arm64/publish/$PROJECT_NAME" \
    -output "$FINAL_OUTPUT_DIR/$PROJECT_NAME"

echo "Universal binary created successfully"