# Separators, Symbols and Colors
#git symbols
bsym='\u2325'
csym='\u21E1' #dotted up arrow
msym='+'
usym='\u26EC' #three trig dots
#Foreground Colors
F0='\[\e[07;40m\]'
F1b='\[\e[01;31m\]'
F1='\[\e[31m\]'
F2='\[\e[32m\]'
F3='\[\e[33m\]'
F4='\[\e[34m\]'
F5='\[\e[35m\]'
F6='\[\e[36m\]'
F7='\[\e[37m\]'
#Background Colors
B0='\[\e[0m\]'
B1='\[\e[41m\]'
B2='\[\e[42m\]'
B3='\[\e[43m\]'
B4='\[\e[44m\]'
B5='\[\e[45m\]'
B6='\[\e[46m\]'
B7='\[\e[47m\]'
# prompt symbols
#par=" "
#top="$(echo -e '\u250C') "
#bot="\n$(echo -e '\u2514')  "
par="$(echo -e '\uE0B0')"
top="$(echo -e '\u250C\uE0B2')"
bot="\n$(echo -e '\u2514\uE0B2\uE0C6')"
clk="$(echo -e '\u231B')"
usr="$(echo -e '\u23FF')"
hst="$(echo -e '\u237E')"
dir="$(echo -e '\u26E9')"
git="$(echo -e '\u2325')"
snk="$(echo -e '\u2440')"
tsk="$(echo -e '\u2713')"
#powerline
mSs="$B1$B0$F1b"
mSe="$B0$F1$B1$par"
m1s="$B1$F0"
m1e="$F2$B1$par"
m2s="$B2$F0"
m2e="$F3$B2$par"
m3s="$B3$F0"
m3e="$F4$B3$par"
m4s="$B4$F0"
m4e="$F5$B4$par"
m5s="$B5$F0"
m5e="$F6$B5$par"
m6s="$B6$F0"
m6e="$F7$B6$par"
m7s="$B7$F0"
m7e="$F1$B7$par"
mEs="$B0$F1b"
mEe="$B0$F1"
start="$mSs$top$mSe"
end="$mEs$bot$mEe "


condaenv() {
    if [[ "$CONDA_DEFAULT_ENV" = "" ]]; then
        cond=" "
    else
        cond=" $CONDA_DEFAULT_ENV"
    fi
    echo -e "$cond"
}
gitstats() {
    if `git branch > /dev/null 2>& 1 && exit 0`; then
        brnch=$(git branch 2> /dev/null | grep '\*' | cut -d' ' -f2)
        if [[ `git status 2> /dev/null | grep -o 'by [0-9]* commit'` = "" ]]; then
            cmmts='0'
        else
            cmmts=$(git status 2> /dev/null | grep -o 'by [0-9]* commit' | cut -d' ' -f2)
        fi
        moded=$(git status -s 2> /dev/null | grep '^ M' | wc -l)
        untrk=$(git status -s 2> /dev/null | grep '^\?\?' | wc -l)
        echo -e "$bsym ($brnch)$csym $cmmts$msym$moded$usym $untrk"
        #echo -e "$bsym $csym$cmmts$msym$moded$usym $untrk"
    else
        echo -e "$bsym "
    fi
}
prompt_command() {
    #initialize all modules as empty
    mod1=""
    mod2=""
    mod3=""
    mod4=""
    mod5=""
    mod6=""
    mod7=""
    mod8=""
    # define modules based on term width
    termwidth=${COLUMNS}
    case 1 in
        $(($termwidth < 20)))
            PROMPT_DIRTRIM=1
            mod1="$m1s$clk\@$m1e"
            mod2="$m2s$dir \w$m2e"
            mod3="$m3s$snk\$(condaenv)$B0$F3$par"
            ;;
        $(($termwidth < 80)))
            PROMPT_DIRTRIM=3
            mod1="$m1s$clk\@$m1e"
            mod2="$m2s$dir \w$m2e"
            mod3="$m3s$snk\$(condaenv)$m3e"
            mod4="$m4s\$(gitstats) $B0$F4$par"
            ;;
        *)
            PROMPT_DIRTRIM=4
            mod1="$m1s$clk\@$m1e"
            mod2="$m2s$usr \u$m2e"
            mod3="$m3s$hst \h$m3e"
            mod4="$m4s$dir $F0\w$m4e"
            mod5="$m5s$snk\$(condaenv)$m5e"
            mod6="$m6s\$(gitstats) $B0$F6$par"
            ;;
    esac
    export PS1="$start$mod1$mod2$mod3$mod4$mod5$mod6$mod7$end"
}
PROMPT_COMMAND=prompt_command
