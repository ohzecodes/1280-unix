#!/bin/sh
if [ -d  .snapshot ] ;then
echo "directory found "
cd ./.snapshot
else 
echo "directory not found will make dirrectory for you"
mkdir .snapshot
cd ./.snapshot
fi

IFS=" ";

if [ ! -z "`ls`" ]; then 
# move dir  

for dir in `ls -1 | tr "\n" " " | rev`; do 
    mv -v "$dir" "$(($dir+1))" 
done 

else 
echo "made folder for backup 01"
mkdir 0
fi 


# delete the tenth or ... backup
if [ -d 10 ]; then
printf "removing: "
rm -vR 1?*
fi 
echo "\n"



if [ ! -d 0 ]; then 
echo "making 0"
mkdir 0
fi
cd ..
IFS=" "

for file in ` ls -1 | tr "\n" " "`; do 
cp  $file .snapshot/0/$file
echo  "copying $file to .snapshot/0/$file" 
done

echo "" 


unset IFS




