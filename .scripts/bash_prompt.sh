count_tasks(){
    ~/apps/t/t.py --task-dir ~/dotfiles/tasks/ --l tasks | wc -l | sed -e"s/ *//"
}
condaenv() {
    if [[ "$CONDA_DEFAULT_ENV" = "" ]]; then
        cond=" "
    else
        cond=" $CONDA_DEFAULT_ENV"
    fi
    echo -e "$cond"
}
#git symbols
bsym='\u2325'
csym='\u21E1' #dotted up arrow
#msym='\u2795' #bold plus
msym='+'
usym='\u26EC' #three trig dots
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
        echo -e "$bsym ($brnch)$csym$cmmts$msym$moded$usym $untrk"
        #echo -e "$bsym $csym$cmmts$msym$moded$usym $untrk"
    else
        echo -e "$bsym "
    fi
}
[[ -f $HOME/.dircolors_256 ]] && eval $(dircolors -b $HOME/.dircolors_256)
#Foreground Colors
end='\[\e[0m\]'
F0='\[\e[30m\]'
fb='\[\e[30m\]'
F1='\[\e[31m\]'
Fb='\[\e[01;31m\]'
F2='\[\e[32m\]'
F3='\[\e[33m\]'
FB='\[\e[01;33m\]'
F4='\[\e[34m\]'
F5='\[\e[35m\]'
F6='\[\e[36m\]'
F7='\[\e[37m\]'
F8='\[\e[38m\]'
#Background Colors
B0='\[\e[40m\]'
B1='\[\e[41m\]'
B2='\[\e[42m\]'
B3='\[\e[43m\]'
B4='\[\e[44m\]'
B5='\[\e[45m\]'
B6='\[\e[46m\]'
B7='\[\e[47m\]'
#Symbols
top=$(echo -e '\u250C\uE0B2')
par=$(echo -e '\uE0B0')
clk=$(echo -e '\u231B')
usr=$(echo -e '\u23FF')
hst=$(echo -e '\u237E')
dir=$(echo -e '\u26E9')
git=$(echo -e '\u2325')
snk=$(echo -e '\u2440')
tsk=$(echo -e '\u2713')
bot=$(echo -e '\u2514')
#→↠↣⇝⇢⇥⮡⭬
#pen=$(echo -e '\u0F3B')
pen=" "
#Set prompt by terminal width
function prompt_command() {
    termwidth=${COLUMNS}
    if [ "$termwidth" -gt "80" ]; then
        #wide terminal
        #Modules
        strt="$end$B0$Fb$top$end$B1"
        time="$B1$F0$clk\@$F1$B2$par"
        user="$B2$F0$usr \u$F2$B3$par"
        host="$B3$F0$hst\h$F3$B4$par"
        dirc="$B4$F0$dir $F0\w$F4$B5$par"
        #task="$B4$F0$tsk\$(count_tasks)$F4$B5$par"
        cond="$B5$F0$snk\$(condaenv)$F5$B6$par"
        gits="$B6$F0\$(gitstats)$F6$B0$par"
        endd="\n$B0$Fb$bot$end$F1$pen$FB"
        PROMPT_DIRTRIM=99
        export PS1="$strt$time$user$host$dirc$cond$gits$endd"
    else
        #small terminal
        #Modules
        strt="$end$B0$Fb$top$end$B1"
        time="$B1$F0$clk\@$F1$B2$par"
        #user="$B3$F0$usr \u$F3$B4$par"
        host="$B2$F0$hst\h$F2$B5$par"
        dirc="$B5$F0$dir $F0\w$F5$B4$par"
        #task="$B4$F0$tsk\$(count_tasks)$F4$B5$par"
        #cond="$B4$F0$snk\$(condaenv)$F4$B6$par"
        gits="$B4$F0\$(gitstats)$F4$B0$par"
        endd="\n$B0$Fb$bot$end$F1$pen$FB"
        PROMPT_DIRTRIM=2
        export PS1="$strt$time$host$dirc$gits$endd"
    fi
}
PROMPT_COMMAND=prompt_command
