#!/bin/sh



echo "child $$: starting"

trap  "a" USR1
trap  "b" USR2


function a(){
    echo "Child $$: Success" ;
    exit 0 ;
}
function b(){
    echo "Child $$: failure" ;
    exit 1;
}
while true  ; do 
(sleep 1)
done

# whats the diff between this loop and sleep infinity