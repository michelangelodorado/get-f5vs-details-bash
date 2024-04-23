#!/bin/bash

vs_list_array=()

# Fetching virtual server names
array=($(tmsh list ltm virtual all | awk '/ltm virtual/ {print $3}'))

for ((i = 0; i < ${#array[@]}; i++)); do
    vs_name=${array[i]}
    vs_ip=$(tmsh list ltm virtual $vs_name destination | awk '/destination/ {split($2, parts, ":"); print parts[1]}')
    vs_port=$(tmsh list ltm virtual $vs_name destination | awk '/destination/ {split($2, parts, ":"); print parts[2]}')
    poolmbr_name=$(tmsh list ltm virtual $vs_name pool | awk '/pool/ {print $2}')
    poolmbr_ip=($(tmsh list ltm pool $poolmbr_name one-line | awk -F '[ {}]' '{for(i=1;i<=NF;i++){if($i~/^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/){print $i}}}'))

    # Constructing the vs_list for each virtual server
    vs_list=("${vs_name},${vs_ip},${vs_port},${poolmbr_name},${poolmbr_ip[@]}")
    vs_list_array+=("${vs_list[@]}")
done

echo ${vs_list_array[@]}
