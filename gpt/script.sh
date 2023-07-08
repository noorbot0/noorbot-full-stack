#!/bin/bash

print_help_menu(){
    echo 'clear) clear
run) python my_model.py
parse) python parser/ParserRunner.py'
}

print_error(){
    echo "Unknown argument, enter 'help' for more info"
}

declare -t cmd

IFS=',' 
declare -t input="$@"
read -a input_arr <<< $input
for command in "${input_arr[@]}"
do
    command=`echo $command | sed 's/^ *//g' | sed 's/ *$//g'`
    if [ "${command}" = "clear" ]; then
        cmd+="clear;";
    elif [ "${command}" = "run" ]; then
        cmd+="python src/app.py;";
    elif [[ "${command}" = "parse"* ]]; then
        declare -t args="${command/parse/""}"
        args=`echo $args | sed 's/^ *//g' | sed 's/ *$//g'`
        cmd+="python parser/ParserRunner.py ${args};";
    elif [ "${command}" = "help" ]; then print_help_menu;
    else
        print_error;
    fi
done

eval $cmd