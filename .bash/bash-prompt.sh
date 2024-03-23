# Prompt Symbols
text_font='07;40'
pow_sep="$(echo -e '\uE0B0')" # "
top="$(echo -e '╭\uE0B2')" # ┏
bot="$(echo -e '╰\uE0B2\uE0C6')" # ┗
clk="$(echo -e '\u231B')"
usr="$(echo -e '\u23FF')"
hst="$(echo -e '\u237E')"
dir="$(echo -e '\u26E9')"
# Module functions
status_cmd="$HOME/dotfiles/.scripts/commit-status.sh"
exit_status() {
    case "$?" in
        0) icon="✔" ;;
        1) icon="✖ " ;;
        *) icon="?" ;;
    esac
    echo "$icon"
}
conda_env() {
    snake_sym='\u2440'
    [[ -z "$CONDA_DEFAULT_ENV" ]]  && env="" || env="$snake_sym $CONDA_DEFAULT_ENV"
    echo -e "$env"
}
git_info() {
    #git symbols
    bsym='\u2325' # branch symbol
    committed_symbol='⇡' # dotted up arrow
    staged_symbol='' # node
    changed_symbol='∆' # delta
    added_symbol='+'

    prompt="$bsym "
    if [ -n "$(git branch 2> /dev/null)" ]; then
        branch="$(git branch 2> /dev/null | grep '\*' | cut -d' ' -f2)"
        [[ $branch = 'master' ]] && branch='m' # trim master to m
        prompt="$prompt($branch)" # current git branch

        commits="$(git status | grep -o 'by [0-9]\+ commit' | cut -d' ' -f2)"
        if [[ -n "$commits" ]]; then # non-zero commits
           prompt="$prompt$committed_symbol$commits"
        fi

        status="$("$status_cmd" short )"
        staged=$(echo "$status" | grep -c '^ [ADC]' | tr -d ' ')
        if [[ "$staged" != 0 ]]; then # non-zero staged files
           prompt="$prompt$staged_symbol$staged"
        fi
        changed=$(echo "$status" | grep -c '^ M' | tr -d ' ')
        if [[ "$changed" != 0 ]]; then # non-zero changed files
           prompt="$prompt$changed_symbol$changed"
        fi
        added=$(echo "$status" | grep -c '^??' | tr -d ' ')
        if [[ "$added" != 0 ]]; then # non-zero untracked files
           prompt="$prompt$added_symbol$added"
        fi
    fi
    echo -e "$prompt"
}

# Format prompt
setColor() {
    # pass a space deilimited string of promt formatting colors
    # produce PS1 formatting string
    # i.e. "07;40 0 31" -> \[\e[07:40m\]\[\e[0m\]\[\e[31m\]
    col_str=""
    for color in $@; do
        col_str="$col_str\[\\e[${color}m\]"
    done
    echo "$col_str"
}
build_prompt() {
    # pass a \t delimited string of of modules that are formatted into powerline prompy
    # each module is a string that corresponds to text,variables,commands
    # note, starting,connection,newline ending are handeled externally
    # this only builds the powerline string of modules
    prompt=""
    i=1
    for module in "$@"; do
        if [[ $i = 1 ]]; then
            f_prev="$(setColor "3$i 4$i")$pow_sep"
        else
            f_prev="$(setColor "3$i 4$((i-1))")$pow_sep"
        fi
        f_curr="$(setColor "4$i $text_font")"
        prompt="$prompt$f_prev$f_curr$module"
        i=$((1+i%8)) # modulo 7 since pywal colors go from 31-37, 41-47
    done
    echo "$prompt$(setColor "0 3$((i-1))")$pow_sep"
}
setOptions() {
    # Set how many dirs are shown in prompt path based on term width
    termwidth=${COLUMNS}
    case 1 in
        $(($termwidth < 20))) PROMPT_DIRTRIM=1 ;;
        $(($termwidth < 60))) PROMPT_DIRTRIM=2 ;;
        $(($termwidth < 80))) PROMPT_DIRTRIM=2 ;;
        $(($termwidth < 100))) PROMPT_DIRTRIM=3 ;;
        *) PROMPT_DIRTRIM=4 ;;
    esac
}
prompt_command() {
    # define modules to be shown based on term width and format them with powerline
    setOptions
    termwidth=${COLUMNS}
    case 1 in
        $(($termwidth < 40)))
            modules="$(build_prompt "\$(exit_status)" "$clk\@" "$dir \w" "\$(conda_env)")"
            ;;
        $(($termwidth < 120)))
            modules="$(build_prompt "\$(exit_status)" "$clk\@" "$dir \w" "\$(conda_env)" "\$(git_info)")"
            ;;
        *) # > 120
            modules="$(build_prompt "\$(exit_status)" "$clk\@" "$usr \u" "$hst \h" "$dir \w" "\$(conda_env)" "\$(git_info)")"
            ;;
    esac
    # format start and end of prompt to put info and entered text on different lines
    start="$(setColor "41 0 01;31")$top$(setColor "0")"
    end="$(setColor "0 01;31")\n$bot "
    term_text_formatting="$(setColor "0 01;36")"
    export PS1="$start$modules$end$term_text_formatting"
}

PROMPT_COMMAND=prompt_command
