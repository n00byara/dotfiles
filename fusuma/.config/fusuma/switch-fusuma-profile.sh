#!/bin/bash

CONFIG_DIR="$HOME/dotfiles/fusuma/.config/fusuma"
ACTIVE_LINK="$HOME/.config/fusuma/config.yml"

CURRENT_TARGET=$(readlink -f "$ACTIVE_LINK")

if [[ "$CURRENT_TARGET" == "$CONFIG_DIR/config.work.yml" ]]; then
    NEW_TARGET="$CONFIG_DIR/config.home.yml"
    PROFILE="home"
else
    NEW_TARGET="$CONFIG_DIR/config.work.yml"
    PROFILE="work"
fi

ln -sf "$NEW_TARGET" "$ACTIVE_LINK"
killall fusuma
fusuma &
echo "🌀 Fusuma profile switched to '$PROFILE'"