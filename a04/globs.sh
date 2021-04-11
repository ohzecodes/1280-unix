#!/bin/sh

# printf 'abc\n123\nabc123\n123abc\na3isok\na   3\n' | ./globs.sh 'a*' '*3*'

if [ $# -eq 0 ];then 
    printf "please enter arguments like: glob.sh 'a*' '*3*' :)\n"; exit 1; 
fi
glob=$@ 

while IFS=" " read line;  do
    count=0;
    for  i in $@  ; do
    
        case "$line" in 
        $i) 

        count=$(( $count+1))

            ;;
        esac 
    done 

    # echo $count
    if [ $count -eq $# ]; then
        echo $line
    fi
done


