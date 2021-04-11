# see files for differences 

hasDupes() {
   file1="$1"
   if [ -f  $file1 ]; then 
   
   
        echo -n "$file1 "
        shift
        for file2 in "$@"; do 
        
        # handle same filename
            if [ "$file1" = "$file2" ];then 
                continue;
            fi
            if [ -f "$file2" ]; then
                if [  -f "$file1" ]; then
                    if cmp -s "$file1" "$file2" ;then 
                        echo -n ": $file2" 
                        status=0;
                    fi
                fi 
            fi
        done
        echo    
     
     [ $status=0 ] && return 0 || return 1

    fi
    
}



# mode 1 
if [ $# != 0 ]; then
    for file1 in $@; do 
        
        hasDupes "$file1" "$@"
    done 
    # mode 2
    else 
        
        
     for file1 in * ; do 
    
        hasDupes "$file1" * 
    done
    
   
fi



 