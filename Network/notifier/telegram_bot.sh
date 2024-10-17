#!/bin/bash
# Send message to Telegram messenger
# Last modify 2024/10/17
# Version 1.0

# Place on: /usr/lib/zabbix/alertscripts

# Telegram bot token and chat ID
TOKEN="7320063839:AAH1TKVxGPvBQGnUd5kKH6yZuOkkW-2JLLU"
DOMAIN="https://api.telegram.org"
CHAT_ID="$1"  # Personal accont id '240221796'
SUBJECT="$2"
MESSAGE="$3"

# Send notification via Telegram API
curl --silent --max-time 10 \
--data "chat_id=$CHAT_ID" \
--data "disable_web_page_preview=1" \
--data "text=$SUBJECT $MESSAGE" \
"$DOMAIN/bot$TOKEN/sendMessage" > /dev/null 2>&1
