
FILE="/etc/os-release"

if [[ -f $FILE ]]; then
    source $FILE

    case "$ID" in
        ubuntu)
            echo "ubuntu"
            ;;
        arch)
            echo "archlinux"
            ;;
        fedora)
            echo "fedora"
            ;;
        *)
            echo "rest of all"
            ;;
    esac

else
    echo "$FILE doesn't exists!"
fi

