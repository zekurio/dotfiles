#!/usr/bin/env bash

# Output artist and title for Waybar music module, escaping curly braces for chezmoi
playerctl metadata --format='{{artist}} - {{title}}'