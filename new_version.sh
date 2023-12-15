#!/bin/bash


cteate_image () {
  docker tag tomcat_run nexus-registry.hrtov.xyz/stage/back:latest 
  docker tag nexus-registry.hrtov.xyz/stage/back:latest  nexus-registry.hrtov.xyz/stage/back:$1
  docker push nexus-registry.hrtov.xyz/stage/back:$1
  docker push nexus-registry.hrtov.xyz/stage/back:latest

}


#url="https://nexus-registry.hrtov.xyz/service/rest/repository/browse/stage/v2/stage/back/tags/"
url=$1

output=($(curl -s "$url" | grep -oP '<a href="\K[^"]+' | awk -F'/' '{print $NF}'))

if [ -z "$output" ]; then
    new_version="1.0.0"
    cteate_image "$new_version"
    echo "Create first version: $new_version"
else
    echo "All versions: $output"
    message=$(git log --pretty=format:%s -n 1)
    
    echo $message


    MINOR="Bug|Fixes"
    PATCH="New|Features"
    MAJOR="Breaking|Major"

    current_version=$(curl -s "$url" | grep -oP '<a href="\K[^"]+' | grep -oP '\/\K\d+\.\d+\.\d+' | sort -V | tail -n 1)
    echo "Smallest value: $current_version"


    if echo "$message" | grep -q -E -w $MINOR; then
       new_version=$(awk -v current_version="$current_version" 'BEGIN {split(current_version, ver, "."); ver[1]+=1; print ver[1] ".0.0"}')
    elif echo "$message" | grep -q -E -w $PATCH; then
       new_version=$(awk -v current_version="$current_version" 'BEGIN {split(current_version, ver, "."); ver[2]+=1; print ver[1] "." ver[2] ".0"}')
    elif echo "$message" | grep -q -E -w $MAJOR; then
       new_version=$(awk -v current_version="$current_version" 'BEGIN {split(current_version, ver, "."); ver[3]+=1; print ver[1] "." ver[2] "." ver[3]}')
    else
       echo "Not creating a new version."
       new_version="$current_version"
    fi

    echo "New version: $new_version"


    if [[ ! " ${output[@]} " =~ " $new_version " ]]; then
        echo "Version $new_version is not in the list."
        cteate_image "$new_version"
    else
        echo "Version $new_version is in the list."
    fi

fi

