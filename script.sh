#!/bin/bash

set -e

BLOG_HOST="blogs.namitoyokota.com"

GRAPHQL_QUERY='
query Publication {
  publication(host: "'$BLOG_HOST'") {
    posts(first: 30) {
      edges {
        node {
          title
          publishedAt
        }
      }
    }
  }
}
'

REQUEST_BODY=$(jq -n --arg query "$GRAPHQL_QUERY" '{query: $query}')

RESPONSE=$(curl -s -X POST https://gql.hashnode.com \
  -H "Content-Type: application/json" \
  -d "$REQUEST_BODY")

ERRORS=$(echo "$RESPONSE" | jq '.errors')
if [ "$ERRORS" != "null" ]; then
  echo "GraphQL error:"
  echo "$ERRORS" | jq
  exit 1
fi

YEAR=$(date +"%Y")
echo "Current year: $YEAR"

# Extract posts array length
POSTS_LENGTH=$(echo "$RESPONSE" | jq '.data.publication.posts.edges | length')
echo "Number of posts returned: $POSTS_LENGTH"

if [ "$POSTS_LENGTH" -eq 0 ]; then
  echo "No posts found in response."
  exit 1
fi

# Extract posts published this year
POST_COUNT=$(echo "$RESPONSE" | jq --arg year "$YEAR" '
  [.data.publication.posts.edges[].node 
    | select(.publishedAt | startswith($year))
  ] | length
')

echo "Posts published in $YEAR: $POST_COUNT"

# Create badge JSON only if post count is not empty
if [ -z "$POST_COUNT" ]; then
  echo "Post count is empty, setting to 0"
  POST_COUNT=0
fi

cat <<EOF > stats.json
{
  "schemaVersion": 1,
  "label": "Blogs written this year",
  "message": "$POST_COUNT",
  "color": "#2962FF"
}
EOF
