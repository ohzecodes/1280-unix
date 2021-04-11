#!/bin/sh


if [ $# -eq 0 ];then 
    printf "please enter only 1 arg like waitany.sh 5  ";
    exit 2; 
fi


success=0;
echo -n "started: "

for i in `seq 1 $1`; do 
    ./child.sh 1> /dev/null &
    
    echo -n  "$! "
    x[$i]=$! ;
# todo this.
# once is done then 

    if [ ${#x[@]} -eq $1 ]; then
       wait $!;
    # IF sucess sucess++ # else failed++
        if [ $? = 0 ]; then 
         
           success=$(($success+1));
           killall sleep 1> /dev/null
           killall bash 1> /dev/null
           exit 0;
           break;
        fi
        
        
        
        if [ $i = $1 ]; then 
             if [ $success -eq 0  ]; then 
                echo all failed
                exit 1;
            fi  
        fi
    fi
    
 
    
done 



       
      
