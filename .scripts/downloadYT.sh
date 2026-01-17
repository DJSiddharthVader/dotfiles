#!/bin/bash
# YT playlists to download from
declare -A SOURCE_PLAYLISTS=(
    ["ASMR"]="https://www.youtube.com/playlist?list=PLMU-V2Iwwq68vV4VXC_FdMgfHq3MT0OuL"
    ["Background"]="https://www.youtube.com/playlist?list=PLMU-V2Iwwq6-wXjDFtmPVnjH5OAaxpCNv"
    ["Essays"]="https://www.youtube.com/playlist?list=PLMU-V2Iwwq6-1LcCUaPXlGu3zKw4lT-2u"
    ["Music"]="https://www.youtube.com/playlist?list=PLMU-V2Iwwq69O1QA3kOtw_YTQ2q-sD-gT"
)
# Where to download files
declare -A DOWNLOAD_DIRS=(
    ["ASMR"]="${HOME}/Phone/Audio.Content/ASMR"
    ["Background"]="${HOME}/Phone/Audio.Content/YT.Videos"
    ["Essays"]="${HOME}/Phone/Audio.Content/Essays"
    ["Music"]="${HOME}/Phone/Music/yt"
)
# How to format downloaded filepaths
FORMAT_DELIM="^"
declare -A FORMAT_STRS=(
    ["ASMR"]="./%(uploader)s/%(title)s.%(ext)s"
    ["Background"]="./%(uploader)s/%(title)s.%(ext)s"
    ["Essays"]="./%(uploader)s/%(title)s.%(ext)s"
    ["Music"]="./%(title)s${FORMAT_DELIM}%(uploader)s${FORMAT_DELIM}%(channel)s${FORMAT_DELIM}%(id)s${FORMAT_DELIM}%(artist)s${FORMAT_DELIM}%(album)s${FORMAT_DELIM}%(track)s${FORMAT_DELIM}%(release_year)s.%(ext)s"
)
# Record of downloaded videos, dont re-download stuff
ARCHIVE_DIR="${HOME}/Phone/Backups/.varfiles/"
declare -A DOWNLOAD_ARCHIVES=(
    ["ASMR"]="${ARCHIVE_DIR}/ASMR-youtube_dl-archive.txt"
    ["Background"]="${ARCHIVE_DIR}/Background-youtube_dl-archive.txt"
    ["Essays"]="${ARCHIVE_DIR}/Essays-youtube_dl-archive.txt"
    ["Music"]="${ARCHIVE_DIR}/Music-youtube_dl-archive.txt"
)

download_stuff() {
    stuff_name="${1}"
    # Check if stuff is in list
    playlist="${SOURCE_PLAYLISTS[${stuff_name}]}"
    [[ -n "${playlist}" ]] || (echo "invalid name ${stuff_name}" && return 1)
    echo "${playlist}"
    download_dir="${DOWNLOAD_DIRS[${stuff_name}]}"
    format_str="${FORMAT_STRS[${stuff_name}]}"
    archive_file="${DOWNLOAD_ARCHIVES[${stuff_name}]}"
    # Download new videos from each playlist to source dir with 
    echo ${download_dir}
    mkdir -p "${download_dir}"
    cd "${download_dir}" || return
    youtube-dl                               \
        -i                                   \
        -x                                   \
        --audio-quality 0                    \
        --audio-format 'mp3'                 \
        --prefer-ffmpeg                      \
        --geo-bypass                         \
        --yes-playlist                       \
        --playlist-reverse                   \
        --verbose                            \
        -o "${format_str}"                   \
        --skip-download                      \
        "${playlist}"
        # --download-archive "${archive_file}" \
    cd - || return
}

main(){
    for group in ${!SOURCE_PLAYLISTS[@]}; do
        [[ "${group}" == "Music" ]] && download_stuff "${group}"
        # download_stuff "${group}"
    done
}

main 
