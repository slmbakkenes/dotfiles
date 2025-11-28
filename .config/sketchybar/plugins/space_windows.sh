#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# Static 5 workspaces
WORKSPACES=(1 2 3 4 5)

# Function to get window icons for a specific workspace
get_workspace_icons() {
  local workspace="$1"
  local icon_strip=""

  # Get all windows in this workspace
  local windows=$(aerospace list-windows --workspace "$workspace" 2>/dev/null)

  if [ -n "$windows" ]; then
    while IFS='|' read -r window_id app_name window_title; do
      app_name=$(echo "$app_name" | xargs)
      if [ -n "$app_name" ]; then
        icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app_name")"
      fi
    done <<< "$windows"
  fi

  if [ -z "$icon_strip" ]; then
    icon_strip=" —"
  fi

  echo "$icon_strip"
}

# Update icons for all 5 workspaces
for workspace in "${WORKSPACES[@]}"; do
  icon_strip=$(get_workspace_icons "$workspace")
  sketchybar --set space.$workspace label="$icon_strip" 2>/dev/null
done
