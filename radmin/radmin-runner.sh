#!/bin/sh
ProgName=$(basename "$0")
subcommand=$1

sub_run(){
    run_path="/home/gabriel/apps/radmin/"
    printf 'Running Radmin VPN at \033[1m%s\033[0m\n' "$run_path"
    "${run_path}RadminVPN-Linux-x86_64.AppImage"
}

sub_update(){
    :
}

sub_help(){
    printf "Usage: radmin [OPTION]\n"
    printf "Radmin VPN via radmin-vpn-linux baptisterajaut's Wine bash command.\n\n"
    printf "Options:\n"
    printf "    \033[1m-h, --help\033[0m\n"
    printf "      prints this help text\n"
    printf "    \033[1mrun\033[0m\n"
    printf "      runs radmin\n"
    printf "    \033[1mupdate\033[0m\n"
    printf "      checks if updates are available and pull a newer stable version from GitHub\n"
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
            printf "\033[1mError:\033[0m '%s' is not a known subcommand\n" "$subcommand"
            printf "       Run \033[1m'$ProgName --help'\033[0m for a list of known subcommands" >&2
            exit 1
        fi
        ;;
esac