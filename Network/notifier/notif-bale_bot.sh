#!/bin/bash
# Send message to Bale messenger
# Last modify 2025/01/22
# Version 1.0

# For Zabbix place on: /usr/lib/zabbix/alertscripts

# Bale bot token and chat ID
TOKEN="624030085:PEE25CbzeocWPGwonSY2CZiREdYoBF9syZWsheku"  # @sinaharaeeni_bot
DOMAIN="https://tapi.bale.ai"
CHAT_ID="1639070346"  # Personal accont id '1639070346'
SUBJECT="Notification"
MESSAGE="$1"

# Send notification via Bale API
curl --silent --max-time 10 \
--data "chat_id=$CHAT_ID" \
--data "disable_web_page_preview=1" \
--data "text=$SUBJECT $MESSAGE" \
"$DOMAIN/bot$TOKEN/sendMessage" > /dev/null 2>&1
