#!/bin/bash
shopt -s extglob

tmp="$HOME/.bwsession"

pick() {
    mode="$1"
    # if no token set prompt password and set token
    if [[ -z "$BW_SESSION" ]]; then
        master="$(rofi -m -1 -lines 0 -password -dmenu -p 'Unlock Vault')"
        session="$(bw unlock --raw "$master")" # get session token
        # export token as env variable for the session
        #echo -e "#!/bin/bash\nexport BW_SESSION=\"$session\"" >| $tmp
        #sed -i "/^export BW_SESSION=/s/=.*$/=$session/" "$HOME/.bashrc"
        #source "$HOME/.bashrc"
        #source $tmp
        info="$(bw list items --session "$session")"
    else
        info="$(bw list items)"
    fi
    entries="$(echo "$info" | jq .[].name)"
    entry="$(echo "$entries" | tr -d '"' | rofi -m -1 -width 25 -lines "$(echo "$entries" | wc -l)" -dmenu -p 'Pick Account')"
    index="$(echo "$entries" | grep -n "$entry" | cut -d':' -f1)"
    password="$(echo "$info" | jq .[$(($index-1))].login.password)"
    echo "$password" | tr -d '"' | xclip -sel clip # copy to clip board
}

pick
