#!/bin/bash
# Send message to Bale messenger
# Last modify 2024/12/05
# Version 1.0

# For grafana place on: /usr/lib/zabbix/alertscripts

# Bale bot token and chat ID
TOKEN="624030085:PEE25CbzeocWPGwonSY2CZiREdYoBF9syZWsheku"  # @sinaharaeeni_bot
DOMAIN="https://tapi.bale.ai"
CHAT_ID="1639070346"  # Personal accont id '1639070346'
SUBJECT="Sina Cloud"

# Read the incoming JSON payload from Grafana
while IFS= read -r line; do
  PAYLOAD="${PAYLOAD}${line}"
done

# Extract information from the payload using `jq` (requires jq to be installed)
ALERT_NAME=$(echo "$PAYLOAD" | jq -r '.title')
ALERT_MESSAGE=$(echo "$PAYLOAD" | jq -r '.message')
ALERT_STATUS=$(echo "$PAYLOAD" | jq -r '.state')
ALERT_URL=$(echo "$PAYLOAD" | jq -r '.ruleUrl')

# Format the message for Telegram
MESSAGE="🚨 *Grafana Alert* 🚨
📌 *Alert Name:* $ALERT_NAME
🔔 *Status:* $ALERT_STATUS
📄 *Message:* $ALERT_MESSAGE
🔗 [View Alert](${ALERT_URL})"

# Send notification via Bale API
curl --silent --max-time 10 \
--data "chat_id=$CHAT_ID" \
--data "disable_web_page_preview=1" \
--data "text=$SUBJECT $MESSAGE" \
"$DOMAIN/bot$TOKEN/sendMessage" > /dev/null 2>&1
