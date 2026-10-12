#!/bin/sh
ProgName=$(basename "$0")
subcommand=$1
RunPath="/home/gabriel/apps/radmin/"

sub_run(){
    printf 'Running Radmin VPN at \033[1m%s\033[0m\n' "$RunPath"
    "${RunPath}RadminVPN-Linux-x86_64.AppImage"
}

sub_update(){
    if ! ReleaseJson=$(curl -fsSL https://api.github.com/repos/baptisterajaut/radmin-vpn-linux/releases/latest); then
        printf "\033[1mError:\033[0m couldn't query GitHub release.\n" >&2
        exit 1
    fi
    if ! LatestVersion=$(printf '%s' "$ReleaseJson" |
        jq -er '.tag_name | select(type == "string" and length > 0)'); then
        printf "\033[1mError:\033[0m invalid release tag.\n" >&2
        exit 1
    fi
    
    InstalledVersion=""
    if [ -f "${RunPath}installed-version.txt" ]; then
        if ! InstalledVersion=$(cat "${RunPath}installed-version.txt"); then
            printf "\033[1mError:\033[0m couldn't read installed-version file.\n" >&2
            exit 1
        fi
    fi

    if [ "$LatestVersion" != "$InstalledVersion" ]; then
        # gets latest version
        if ! curl -fL -o "${RunPath}RadminVPN-Linux-x86_64.AppImage.new" \
            "https://github.com/baptisterajaut/radmin-vpn-linux/releases/latest/download/RadminVPN-Linux-x86_64.AppImage"; then
            printf "\033[1mError:\033[0m couldn't download AppImage latest version.\n" >&2
            rm -f "${RunPath}RadminVPN-Linux-x86_64.AppImage.new"
            exit 1
        fi
        # grants running permission
        if ! chmod +x "${RunPath}RadminVPN-Linux-x86_64.AppImage.new"; then
            printf "\033[1mError:\033[0m couldn't make new AppImage executable.\n" >&2
            rm -f "${RunPath}RadminVPN-Linux-x86_64.AppImage.new"
            exit 1
        fi
        # overwites old version
        if ! mv -v "${RunPath}RadminVPN-Linux-x86_64.AppImage.new" "${RunPath}RadminVPN-Linux-x86_64.AppImage"; then
            printf "\033[1mError:\033[0m couldn't overwrite old AppImage.\n" >&2
            rm -f "${RunPath}RadminVPN-Linux-x86_64.AppImage.new"
            exit 1
        fi
        # updates installed-version text file
        if ! printf "%s\n" "$LatestVersion" > "${RunPath}installed-version.txt"; then
            printf "\033[1mWarning:\033[0m couldn't change installed-version.txt.\n" >&2
            printf "         consider changing it as soon as possible.\n" >&2
        fi
    fi

    if command -v prime-run >/dev/null 2>&1; then
        prime-run "${RunPath}RadminVPN-Linux-x86_64.AppImage" --update
    else
        "${RunPath}RadminVPN-Linux-x86_64.AppImage" --update
    fi
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
        printf "\033[1mError:\033[0m '%s' is not a known subcommand\n" "$subcommand"
        printf "       Run \033[1m'%s --help'\033[0m for a list of known subcommands" "$ProgName" >&2
        exit 1
        ;;
esac