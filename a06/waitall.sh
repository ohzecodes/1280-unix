#!/bin/sh

if [ $# -eq 0 ];then 
    printf "please enter only 1 arg like waitall.sh 5  ";
    exit 2; 
fi

echo -n "started: "
for i in `seq 1 $1`; do 
    ./child.sh 1> /dev/null &
    echo -n  "$! "
    x[$i]=$! ;

# todo this.
    if [ ${#x[@]} -eq $1 ]; then
       wait
       
    # for m in `seq 1 $1`; do
        if [ $? -eq 0 ]; then
            a[$m]=$! ;
           
        fi
        if [ $? -eq 1 ] ; then 
            b[$m]=$! ;
           
         
        fi
# done 
fi
done 

echo
echo "Successes: " ${a[*]}
echo "Failures: " ${b[*]}

if [ ${#b[@]} -eq 0 ]; then 
exit 0;
else 
exit 1;
fi