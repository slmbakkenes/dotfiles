#!/bin/bash

# Static 5 aerospace workspaces
SPACE_SIDS=(1 2 3 4 5)

sketchybar --add event aerospace_workspace_change

for sid in "${SPACE_SIDS[@]}"; do
  sketchybar --add item space.$sid left \
             --set space.$sid \
                   icon="$sid" \
                   icon.padding_left=10 \
                   icon.padding_right=10 \
                   label.font="sketchybar-app-font:Regular:16.0" \
                   label.padding_right=20 \
                   label.y_offset=-1 \
                   background.corner_radius=5 \
                   background.height=24 \
                   script="$PLUGIN_DIR/space.sh" \
             --subscribe space.$sid aerospace_workspace_change
done

sketchybar --add item space_separator left \
           --set space_separator icon="􀆊" \
                                 icon.color=$ACCENT_COLOR \
                                 icon.padding_left=4 \
                                 label.drawing=off \
                                 background.drawing=off \
                                 script="$PLUGIN_DIR/space_windows.sh" \
           --subscribe space_separator aerospace_workspace_change front_app_switched

# Trigger initial update
FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null || echo "1")
sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE="$FOCUSED"
