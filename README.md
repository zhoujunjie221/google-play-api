# google-play-api

Turns [google-play-scraper](https://github.com/facundoolano/google-play-scraper/) into a RESTful API.

## Setup

To run locally:

```bash
# Install dependencies
npm install

# Create .env file and set your API key
echo "API_KEY=your_api_key_here" > .env
echo "PORT=8080" >> .env

# Start the server
npm start
```

## Local google-play-scraper Integration

This project includes a local copy of `google-play-scraper` (v10.0.0) with bug fixes applied directly to the source code.

### Bug Fix Applied

Fixed a bug in the `extractCategories` function that caused the following error for certain apps:

```
TypeError: Cannot read properties of undefined (reading 'length')
```

**Changes made:**
- Added `undefined` check before accessing `searchArray.length`
- Added `undefined` check for sub-arrays in recursive calls

**Location:** `google-play-scraper/lib/utils/mappingHelpers.js`

**Related Issue:** [google-play-scraper#720](https://github.com/facundoolano/google-play-scraper/issues/720)

**For detailed information about modifications, see [MODIFICATIONS.md](MODIFICATIONS.md)**

## Deployment

After cloning this repository:

```bash
# Install dependencies (this will NOT overwrite the local google-play-scraper)
npm install

# Configure your API key
echo "API_KEY=your_api_key_here" > .env
echo "PORT=8080" >> .env

# Start the server
npm start
```

The local `google-play-scraper` directory will be preserved during `npm install`.

## Authentication

All API endpoints require authentication using an API key. Include your API key in the request headers:

```bash
curl -H "x-api-key: your_api_key_here" http://localhost:8080/api/apps/
```

## Example requests

The parameters for each endpoint are taken directly from google-play-scraper. For a full reference check its [documentation](https://github.com/facundoolano/google-play-scraper/#usage).

Get the top free apps (default list)
```http
GET /api/apps/
```

Get the top free apps with full detail
```http
GET /api/apps/?fullDetail=true
```

Get the top selling action games in russia
```http
GET /api/apps/?collection=topselling_paid&category=GAME_ACTION&country=ru
```

Get an app detail
```http
GET /api/apps/org.wikipedia/
```

Get an app detail in spanish
```http
GET /api/apps/org.wikipedia/?lang=es
```

Get app required permissions with full descriptions
```http
GET /api/apps/org.wikipedia/permissions/
```

Get app required permissions (short list)
```http
GET /api/apps/org.wikipedia/permissions/?short=true
```

Get app data safety information
```http
GET /api/apps/org.wikipedia/datasafety/
```

Get similar apps
```http
GET /api/apps/org.wikipedia/similar/
```

Get an app's reviews
```http
GET /api/apps/org.wikipedia/reviews/
```

Search apps
```http
GET /api/apps/?q=facebook
```

Get search suggestions for a partial term
```http
GET /api/apps/?suggest=face
```

Get apps by developer
```http
GET /api/developers/Wikimedia%20Foundation/
```

Get categories
```http
GET /api/categories/
```

Note: Remember to include the `x-api-key` header in all requests.
