#!/bin/sh
ProgName=$(basename "$0")
subcommand=$1

sub_run(){
    run_path="/home/gabriel/apps/radmin/"
    echo "Running Radmin at $run_path"
    "${run_path}RadminVPN-Linux-x86_64.AppImage"
}

sub_update(){
    :
}

sub_help(){
    :
}

case $subcommand in
    "" | "run")
        sub_run
        ;;
    
    "update")
        sub_update
        ;;

    "--help" | "-h")
        sub_help
        ;;
    *)
        shift
        sub_${subcommand} "$@"
        if [ $? = 127 ]; then
            echo "Error: '$subcommand' is not a known subcommand" >&2
            echo "       Run '$ProgName --help' for a list of known subcommands" >&2
            exit 1
        fi
        ;;
esac