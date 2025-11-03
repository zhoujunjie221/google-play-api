#!/bin/bash

# Verification script for the google-play-scraper bug fix
# This script verifies that the local integration is working correctly

set -e

echo "═══════════════════════════════════════════════════════"
echo "  Verifying google-play-scraper Local Integration"
echo "═══════════════════════════════════════════════════════"
echo ""

# Check if google-play-scraper directory exists
echo "✓ Checking for local google-play-scraper directory..."
if [ ! -d "google-play-scraper" ]; then
    echo "  ✗ ERROR: google-play-scraper directory not found!"
    exit 1
fi
echo "  ✓ Found: google-play-scraper/"

# Check if the fix is applied
echo ""
echo "✓ Checking if bug fix is applied..."
if grep -q "!searchArray || searchArray === null" google-play-scraper/lib/utils/mappingHelpers.js; then
    echo "  ✓ Bug fix is applied in mappingHelpers.js"
else
    echo "  ✗ ERROR: Bug fix not found in mappingHelpers.js!"
    exit 1
fi

# Check if lib/index.js uses local import
echo ""
echo "✓ Checking import path in lib/index.js..."
if grep -q 'from "../google-play-scraper/index.js"' lib/index.js; then
    echo "  ✓ Using local google-play-scraper import"
else
    echo "  ✗ ERROR: lib/index.js not using local import!"
    exit 1
fi

# Check if package.json has the right dependencies
echo ""
echo "✓ Checking package.json dependencies..."
if grep -q '"cheerio"' package.json && \
   grep -q '"got"' package.json && \
   grep -q '"memoizee"' package.json && \
   grep -q '"ramda"' package.json; then
    echo "  ✓ All required dependencies present"
else
    echo "  ✗ ERROR: Missing required dependencies in package.json!"
    exit 1
fi

# Check if google-play-scraper is NOT in dependencies
if grep -q '"google-play-scraper"' package.json; then
    echo "  ✗ WARNING: google-play-scraper still in package.json dependencies!"
    echo "            This should be removed."
fi

# Check if node_modules has required packages
echo ""
echo "✓ Checking installed dependencies..."
if [ -d "node_modules/cheerio" ] && \
   [ -d "node_modules/got" ] && \
   [ -d "node_modules/memoizee" ] && \
   [ -d "node_modules/ramda" ]; then
    echo "  ✓ All required packages installed"
else
    echo "  ✗ WARNING: Some dependencies not installed. Run 'npm install'"
fi

echo ""
echo "═══════════════════════════════════════════════════════"
echo "  ✓ Verification Complete!"
echo "═══════════════════════════════════════════════════════"
echo ""
echo "Next steps:"
echo "  1. Make sure .env file is configured with API_KEY"
echo "  2. Run 'npm start' to start the server"
echo "  3. Test with: curl -H 'x-api-key: YOUR_KEY' \\"
echo "     'http://localhost:8080/api/apps/magalingpeso.cash.loan?country=ph'"
echo ""

