#!/bin/bash
youtube-dl  --audio-quality 0 \
            --audio-format mp3 \
            --prefer-ffmpeg \
            -x \
            --yes-playlist \
            --verbose \
            -i \
            --download-archive ~/.config/youtube-dl_downloads.txt \
            "https://www.youtube.com/playlist?list=PLMU-V2Iwwq69O1QA3kOtw_YTQ2q-sD-gT"
