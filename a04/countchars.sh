#!/bin/sh
# printf 'abcdcba\nabbcccdddd\n' | ./countchars.sh 'a' 'd' 'c' 'e'

if [ $# -eq 0 ];then 
    printf "please enter arguments thanks like:  ./countchars.sh 'a' 'd' 'c' 'e' :)\n"; exit 1; 
fi

args=$(echo "$@" | tr -d " ")
argslen=$(printf  $args | wc -c | tr -d " ");

while read  input ; do 
    inputlenght=$(printf  $input | wc -c | tr -d " ");

    # echo "check in $input for $args  "
    for x in `seq 0 $(($argslen-1))` ; do 
        countchar=0

        for i in `seq 0 $inputlenght`; do

            if [  "${input: $(echo $i):1}" = "${args:$(echo $x):1}"  ]; then 
            countchar=$(($countchar+1));
            # echo ${input: $(echo $i):1}
            fi 


        done

        printf "$countchar "
    done 
    printf '\n'
done

# echo




