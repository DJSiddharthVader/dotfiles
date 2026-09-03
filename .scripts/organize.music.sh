#!/bin/bash
set -euo pipefail

get_all_metadata() {
    song_filepath="${1}"
    ffprobe -loglevel error -show_entries format -i "${song_filepath}" 2>&1 
}

get_metadata_field() {
    metadata_field="${1}"
    song_metadata="${2}"
    data="$(echo "${song_metadata}" | sed -E -n "s|^TAG:${metadata_field}=(.*)$|\1|ip")"
    case ${metadata_field} in
        'track') data="$(echo "${data}" | cut -d'/' -f1)" ;;
    esac
    echo "${data}"
    # TAG:title=Headband
    # TAG:artist=billy woods
    # TAG:album=History Will Absolve Me (2012)
    # TAG:genre=Hip-Hop
    # TAG:track=9/21
    # TAG:album_artist=billy woods
    # TAG:VA Artist=Billy Woods
    # TAG:Rip date=2022-06-14
    # TAG:Source=WAV
    # TAG:Release type=Album
    # TAG:language=eng
    # TAG:publisher=Billy Woods
    # TAG:comment=UVU
    # TAG:encoder=Lame 3.100
    # TAG:date=2022-00-00
}

is_missing() {
    # fields_to_check=('title' 'album_artist' 'album' 'track')
    fields_to_check=('title' 'album_artist' 'album')
    song_filepath="${1}"
    song_metadata="$(get_all_metadata "${song_filepath}")"
    declare -A missing_fields=()
    n_missing=0
    for field in ${fields_to_check[@]}; do
        value="$(get_metadata_field "${field}" "${song_metadata}")"
        missing_fields["${field}"]="${value}"
        if [[ -z "${value}" ]]; then
            n_missing=$(( n_missing+1 ))
        fi
    done
    if [[ $n_missing -gt 0 ]]; then
        echo ${song_filepath}
        echo $n_missing
        for i in "${!missing_fields[@]}"; do
            echo "${i}=${missing_fields[$i]}"
        done
    fi
}

rename_song_by_template() {
    song_filepath="${1}"
    output_dir="${2}"
    # get song metadata
    file_extension="${song_filepath##*.}"
    song_metadata="$(get_all_metadata "${song_filepath}")"
    title="$(get_metadata_field "title" "${song_metadata}")"
    album_artist="$(get_metadata_field "album_artist" "${song_metadata}")"
    # artist="$(get_metadata_field "artist" "${song_metadata}")"
    album="$(get_metadata_field "album" "${song_metadata}")"
    track="$(get_metadata_field "track" "${song_metadata}")"
    # genre="$(get_metadata_field "genre" "${song_metadata}")"
    # VA_Artist="$(get_metadata_field "Artist" "${song_metadata}")"
    # Rip_date="$(get_metadata_field "date" "${song_metadata}")"
    # Source="$(get_metadata_field "Source" "${song_metadata}")"
    # Release_type="$(get_metadata_field "type" "${song_metadata}")"
    # language="$(get_metadata_field "language" "${song_metadata}")"
    # publisher="$(get_metadata_field "publisher" "${song_metadata}")"
    # comment="$(get_metadata_field "comment" "${song_metadata}")"
    # encoder="$(get_metadata_field "encoder" "${song_metadata}")"
    # date="$(get_metadata_field "date" "${song_metadata}")"
    # Move song to templated filepath name
    DELIM='~'
    FILEPATH_FORMAT_STR="${album_artist}/${album}/${track}_${title}"
    renameing_template="${output_dir}/${FILEPATH_FORMAT_STR}.${file_extension}"
    renameing_template="$(echo "${renameing_template}" | tr -d '[*&\?:"<>|]' | tr -s ' ')"
    # echo '-----------------------------------------------------------------------'
    # echo "${song_filepath}"
    # echo "${renameing_template}"
    mkdir -p "$(dirname "${renameing_template}")"
    cp "${song_filepath}" "${renameing_template}"
}

rename_all_songs() {
    input_music_dir="${1}"
    output_music_dir="${2}"
    find "${input_music_dir}" -maxdepth 99 -type f -regex '.*\.\(mp3\|mp4\|m4a\|ogg\|flac\|oga\)' -print0 |
    while IFS= read -r -d '' song_filepath; do 
        rename_song_by_template "${song_filepath}" "${output_music_dir}"
    done
}

check_missing_songs() {
    input_music_dir="${1}"
    find "${input_music_dir}" -maxdepth 99 -type f -regex '.*\.\(mp3\|mp4\|m4a\|ogg\|flac\|oga\)' -print0 |
    while IFS= read -r -d '' song_filepath; do 
        is_missing "${song_filepath}"
    done
}

rename_all_songs "${1}" "${2}"
# check_missing_songs "${1}"
