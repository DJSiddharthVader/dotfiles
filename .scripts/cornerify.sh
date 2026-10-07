#!/bin/bash
shopt -s extglob
# set -eo pipefail

############################################################
# Globals
############################################################
PARAMS_FILE="${HOME}/.varfiles/cornerify.mode"
DEFAULT_MONITOR="eDP-1"
declare -A WINDOW_HEIGHTS=(
    [small]=200
    [medium]=314 
    [large]=404 
)
declare -A WINDOW_WIDTHS=(
    [small]=375
    [medium]=558 
    [large]=718 
)
ALL_SIZE_MODES=(${!WINDOW_HEIGHTS[@]})
ALL_SIZE_ACTIONS=(${ALL_SIZE_MODES[@]})
ALL_SIZE_ACTIONS+=('next' 'prev')
ALL_POSITION_ACTIONS=(
    'toggle' 
    'stash' 
    'corner'
)
ALL_WINDOW_ACTIONS=(
    'unpause' 
    'pause' 
    'unhide' 
    'hide' 
    'unfloat' 
    'float' 
    'unsticky' 
    'sticky' 
    'resize' 
    'put.in.corner' 
    'cornerify'
)
ALL_WINDOW_FIELDS=(
    'id' 
    'json' 
    'width'
    'height'
    'is.floating' 
    'is.hidden' 
)
ALL_MONITOR_FIELDS=(
    'active.ws'
    'width'
    'height'
)

############################################################
# Misc
############################################################
help() {
    echo "
Usage: ./$(basename $0) \${ACTION}
    Window Sizes Actions: $(paste_array ${ALL_SIZE_ACTIONS[*]})
    Window Actions:       $(paste_array ${ALL_WINDOW_ACTIONS[*]})
    Window Info:          $(paste_array ${ALL_WINDOW_FIELDS[*]})
    help:                 print this message
    " | sed -e 's/@(/{/' | sed -e 's/)/}/'
}

set_param() {
    param="${1}"
    new_param_value="${2}"
    sed -i "/^${param}:/s/:.*/:${new_param_value}/" "${PARAMS_FILE}"
}

get_param() {
    param="${1}"
    grep "^${param}:" "${PARAMS_FILE}" | cut -d':' -f2
}

paste_array() {
    # array_to_paste=${1}
    array_to_paste=("$@")
    echo "@($(echo ${array_to_paste[@]} | sed -e 's/ /|/g'))"
}

############################################################
# Get Monitor Info
############################################################
get_monitor_width() {
    monitor=${1}
    xrandr | grep ${monitor} | sed -e 's/primary //' | awk '/ connected/{print $3}' | tr '+' 'x' | cut -d'x' -f1
}

get_monitor_height() {
    monitor=${1}
    xrandr | grep ${monitor} | sed -e 's/primary //' | awk '/ connected/{print $3}' | tr '+' 'x' | cut -d'x' -f2
}

get_monitor_info() {
    monitor_field=${1}
    monitor=${2}
    case ${monitor_field} in 
        active.ws)   get_workspace_to_put_mpv_on ${monitor};;
        width)       get_monitor_width ${monitor} ;;
        height)      get_monitor_height ${monitor} ;;
        *)
            valid_values="$(paste_array "${ALL_MONITOR_FIELDS[*]}")"
            echo "Invalid action: ${monitor_field}"
            echo "Use a valid value: ${valid_values[*]}"
            exit 1
            ;;
    esac
}

############################################################
# Get Window Info
############################################################
get_mpv_window_id() {
    xdotool search ' - mpv' 2> /dev/null
}

get_window_json() {
    window_id=${1}
    i3-msg -t get_tree | jq -r --argjson target "${window_id}" ' .. | objects | select(.window? == $target)'
}

is_window_floating() {
    window_id=${1}
    window_json="$(get_window_json ${window_id})"
    is_window_floating="$(echo "${window_json}" | jq '.floating' | tr -d '"')"
    [[ ${is_window_floating} == 'user_off' ]] && echo 'tiled' || echo 'floating'
}

is_window_hidden() {
    window_id=${1}
    window_json="$(get_window_json ${window_id})"
    is_window_hidden="$(echo "${window_json}" | jq '.output' | tr -d '"')"
    [[ ${is_window_hidden} == '__i3' ]] && echo 'hidden' || echo 'corner' 
}

get_workspace_to_put_mpv_on() {
    monitor="${1:-${DEFAULT_MONITOR}}"
    i3-msg -t get_workspaces | jq "map(select(.output == \"${monitor}\")) | map(select(.visible)) .[] .num"
}

get_window_width() {
    window_id=${1}
    xdotool getwindowgeometry ${window_id} | grep Geometry | tr 'x' ' ' | awk '{print $2}'
}

get_window_height() {
    window_id=${1}
    xdotool getwindowgeometry ${window_id} | grep Geometry | tr 'x' ' ' | awk '{print $3}'
}

get_winfo() {
    window_field=${1}
    window_id=${2}
    case ${window_field} in 
        id)          echo ${window_id} ;;
        json)        get_window_json ${window_id} ;;
        is.floating) is_window_floating ${window_id} ;;
        is.hidden)   is_window_hidden ${window_id} ;;
        width)       get_window_width ${window_id} ;;
        height)      get_window_height ${window_id} ;;
        *)
            valid_values="$(paste_array "${ALL_WINDOW_FIELDS[*]}")"
            echo "Invalid action: ${window_field}"
            echo "Use a valid value: ${valid_values[*]}"
            exit 1
            ;;
    esac
}

############################################################
# Interact with video window
############################################################
get_window_pos_x() {
    corner_mode=${1}
    monitor=${2}
    window_id=${3}
    monitor_width=$(get_monitor_info 'width' ${monitor})
    window_width=$(get_winfo 'width' ${window_id})
    case ${corner_mode} in
        'tl') echo '0' ;;
        'bl') echo '0' ;;
        'tr') echo $(( ${monitor_width} - ${window_width} )) ;;
        'br') echo $(( ${monitor_width} - ${window_width} )) ;;
        *) echo "Invalid corner mode: ${corner_mode}"
    esac
}

get_window_pos_y() {
    corner_mode=${1}
    monitor=${2}
    window_id=${3}
    monitor_height=$(get_monitor_info 'height' ${monitor})
    window_height=$(get_winfo 'height' ${window_id})
    case ${corner_mode} in
        'tl') echo '0' ;;
        'tr') echo '0' ;;
        'bl') echo $(( ${monitor_height} - ${window_height} )) ;;
        'br') echo $(( ${monitor_height} - ${window_height} )) ;;
        *) echo "Invalid corner mode: ${corner_mode}"
    esac
}

put_window_in_corner() {
    window_id=${1}
    monitor="${2:-${DEFAULT_MONITOR}}"
    # echo ${window_id} 
    # echo ${monitor}
    # put in corner of leftmost monitor on the right-bottom corner
    pos_x=$(get_window_pos_x 'br' ${monitor} ${window_id})
    pos_y=$(get_window_pos_y 'br' ${monitor} ${window_id})
    echo "${pos_x}, ${pos_y}"
    active_workspace="$(get_monitor_info 'active.ws' ${monitor})"
    # echo ${active_workspace}
    i3-msg "[id=${window_id}] move window to workspace ${active_workspace}"
    xdotool windowmove -sync "${window_id}" ${pos_x} ${pos_y}
}

resize_window() {
    window_id=${1}
    window_size_mode=$(get_param 'window_size_mode')
    width=${WINDOW_WIDTHS[${window_size_mode}]}
    height=${WINDOW_HEIGHTS[${window_size_mode}]}
    xdotool windowsize -sync "${window_id}" ${width} ${height}
}

window_action() {
    window_action=${1}
    window_id=${2}
    case ${window_action} in 
        unpause)       xdotool key --window "${window_id}" period p ;;
        pause)         xdotool key --window "${window_id}" comma ;;
        unhide)        i3-msg "[id=${window_id}] scratchpad show" ;;
        hide)          i3-msg "[id=${window_id}] move scratchpad" ;;
        unfloat)       i3-msg "[id=${window_id}] floating disable" ;;
        float)         i3-msg "[id=${window_id}] floating enable" ;;
        unsticky)      i3-msg "[id=${window_id}] sticky disable" ;;
        sticky)        i3-msg "[id=${window_id}] sticky enable" ;;
        resize)        resize_window ${window_id} ;;
        put.in.corner) put_window_in_corner ${window_id} ;;
        cornerify) 
            window_action 'float' ${window_id}
            window_action 'resize' ${window_id}
            window_action 'put.in.corner' ${window_id} 
            window_action 'sticky' ${window_id}
            ;;
        *)
            valid_values="$(paste_array "${ALL_WINDOW_ACTIONS[*]}")"
            echo "Invalid action: ${window_action}"
            echo "Use a valid value: ${valid_values[*]}"
            exit 1
            ;;
    esac
}

adjust_window_position() {
    window_position_mode=${1}
    window_id=${2}
    case ${window_position_mode} in 
        "toggle")
            is_hidden="$(get_winfo is.hidden ${window_id})"
            case ${is_hidden} in
                'corner') adjust_window_position 'stash' ${window_id} ;;
                'hidden') adjust_window_position 'corner' ${window_id} ;;
            esac
            ;;
        "corner") 
            window_action 'cornerify' ${window_id}
            mpc pause
            window_action 'unpause' "${window_id}"
            ;;
        "stash")
            window_action 'hide' "${window_id}"
            window_action 'pause' "${window_id}"
            ;;
        *)
            valid_values="$(paste_array "${ALL_POSITION_ACTIONS[*]}")"
            echo "Invalid window_position_mode: ${window_position_mode}"
            echo "Use a valid value: ${valid_values[*]}"
            exit 2
            ;;
    esac
}

cycle_window_sizes() {
    # cycle through modes either forwards or backwards
    # next mode index is:  (x+1) % n
    # prev mode index is:  (x+n-1) % n
    # x is current mode index, n is number of modes
    direction=${1}
    window_id=${2}
    window_size_mode="$(get_param 'window_size_mode')"
    idx="$(echo "${ALL_SIZE_MODES[*]}" | grep -o "^.*${window_size_mode}" | tr ' ' '\n' | wc -l)"
    # idx=$(($idx - 1)) #current mode idx
    case "${direction}" in
         'next') new_idx=$((${idx} + 1)) ;;
         'prev') new_idx=$((${idx} + ${#ALL_SIZE_MODES[@]} - 1)) ;;
         *) echo "Error cycle takes {next|prev}" && exit 1 ;;
    esac
    new_idx=$((${idx} % ${#ALL_SIZE_MODES[@]})) #modulo to wrap back
    set_param 'window_size_mode' "${ALL_SIZE_MODES[${new_idx}]}"
}

adjust_window_size() {
    window_size_action=${1}
    window_id=${2}
    window_size_mode=$(get_param 'window_size_mode')
    size_modes="$(paste_array "${ALL_SIZE_MODES[*]}")"
    case ${window_size_action} in
        'next')         cycle_window_sizes next ${window_id} ;;
        'prev')         cycle_window_sizes prev ${window_id} ;;
        ${size_modes} ) set_param 'window_size_mode' ${window_size_mode} ;;
        *)
            valid_values="$(paste_array "${ALL_SIZE_MODES[*]}")"
            echo "Invalid window size action: ${window_size_action}"
            echo "Use a valid value: ${valid_values[*]}"
            exit 2
            ;;
    esac
    resize_window ${window_id} 
    window_action 'cornerify' ${window_id}
}

############################################################
# Main
############################################################
main() {
    action=${1}
    # echo "action: ${action}"
    window_id="$(get_mpv_window_id)"
    # echo "window id: ${window_id}"
    position_actions="$(paste_array "${ALL_POSITION_ACTIONS[*]}")"
    size_actions="$(paste_array "${ALL_SIZE_ACTIONS[*]}")"
    window_actions="$(paste_array "${ALL_WINDOW_ACTIONS[*]}")"
    window_fields="$(paste_array "${ALL_WINDOW_FIELDS[*]}")"
    case ${action} in
        ${position_actions} )
            echo 'changing window position'
            adjust_window_position ${action} ${window_id} 
            ;;
        ${size_actions} )
            echo "setting window size"
            adjust_window_size ${action}  ${window_id} 
            ;;
        ${window_actions} ) 
            echo "acting on window"
            window_action ${action} ${window_id}  
            ;;
        ${window_fields} )  
            echo "getting window info"
            get_winfo ${action} ${window_id}  
            ;;
        # get)  get_param ${2} ;;
        # set)  set_param ${2} ${3} ;;
        help) help && exit 0 ;;
        *)    echo "Invalid action: ${action}" && help && exit 2 ;;
    esac
}

main ${@}

