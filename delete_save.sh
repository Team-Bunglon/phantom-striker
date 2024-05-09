#!/usr/bin/env bash
# This is a shell script that delete your save file for debugging purpose.
# We should include a function to delete it manually from the game itself through a secret button.
# This only works on Linux. IDK how do you do it on Windows.
rm -f ~/.local/share/godot/app_userdata/phantom/save.json
