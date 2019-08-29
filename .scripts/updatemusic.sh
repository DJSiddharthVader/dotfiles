#!/bin/bash
scdl --download-archive "$HOME/dotfiles/.varfiles/soundcloud_download_archive.txt" -c -l https://soundcloud.com/sid-reed-871359466/sets/likedsongs
youtube-dl  --audio-quality 0 \
            --audio-format mp3 \
            --prefer-ffmpeg \
            -x \
            --yes-playlist \
            -i \
            --verbose \
            --download-archive "$HOME/dotfiles/.varfiles/youtube-dl_downloads.txt" \
            "https://www.youtube.com/playlist?list=PLMU-V2Iwwq69O1QA3kOtw_YTQ2q-sD-gT"
            #"https://www.youtube.com/playlist?list=PLMU-V2Iwwq699kP0gmoOXyyk02eH4ZgEH"
