#!/bin/bash

~/.scripts/music_utils/download-music.sh
~/.scripts/music_utils/add-metadata.sh ~/Music/songs/*.mp3
~/.scripts/music_utils/organize-music.sh ~/Music/songs/*.mp3
~/.scripts/music_utils/playlists.sh
