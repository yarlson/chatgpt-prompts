#!/bin/bash

display_help() {
  echo "Usage: $0 [-s SYSTEM_MESSAGE] USER_MESSAGE"
  echo "   or: cat YOUR_FILE | $0 [-s SYSTEM_MESSAGE]"
  echo "   -s: optional system message"
  echo "   USER_MESSAGE: message from the user (ignored if input is from a pipe)"
}

[ "$1" = "--help" ] || [ "$1" = "-h" ] && { display_help; exit 0; }
[ "$1" = "-s" ] && { SYSTEM_MESSAGE=$2; shift 2; }
[ -p /dev/stdin ] && USER_MESSAGE=$(cat) || USER_MESSAGE=$1
[ -z "$USER_MESSAGE" ] && { display_help; exit 1; }

USER_MESSAGE_JSON=$(echo -n "$USER_MESSAGE" | jq -Rs .)
SYSTEM_MESSAGE_JSON=$(echo -n "$SYSTEM_MESSAGE" | jq -Rs .)

MESSAGES="{\"role\": \"user\", \"content\": $USER_MESSAGE_JSON}"
[ -n "$SYSTEM_MESSAGE" ] && MESSAGES="{\"role\": \"system\", \"content\": $SYSTEM_MESSAGE_JSON}, $MESSAGES"

REQUEST_PAYLOAD="{\"model\": \"gpt-4\", \"messages\": [$MESSAGES], \"temperature\": 0.7}"

RESPONSE=$(curl -s -X POST "https://api.openai.com/v1/chat/completions" \
     -H "Content-Type: application/json" \
     -H "Authorization: Bearer $OPENAI_API_KEY" \
     -d "$REQUEST_PAYLOAD")

echo $RESPONSE | jq -r '.choices[0].message.content'
