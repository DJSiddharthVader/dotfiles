#!/bin/bash
scdl --download-archive /home/sidreed/dotfiles/.config/soundcloud_download_archive.txt -c -l https://soundcloud.com/sid-reed-871359466/sets/likedsongs
youtube-dl  --audio-quality 0 \
            --audio-format mp3 \
            --prefer-ffmpeg \
            -x \
            --yes-playlist \
            -i \
            --download-archive /home/sidreed/dotfiles/.config/youtube-dl_downloads.txt \
            "https://www.youtube.com/playlist?list=PLMU-V2Iwwq69O1QA3kOtw_YTQ2q-sD-gT"
