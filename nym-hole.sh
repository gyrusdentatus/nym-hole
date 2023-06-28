#!/bin/bash

function print_help() {
    echo "Usage: $0 [OPTIONS] FILE"
    echo "Options:"
    echo "--relay RELAY           Use a custom relay for croc."
    echo "--test                  Check if croc and nym-socks5-client are installed and running."
    echo "--install               Install nym-socks5-client."
    echo "--service-provider SP   Use a custom service provider for nym."
    echo "--dry-test              Run croc without --socks and --relay flags."
    echo "--help                  Print this help message."
    exit 0
}

# Default values
RELAY="37.235.105.22:9009"
SOCKS="127.0.0.1:1080"
PROVIDER="4V8euNmD7oBtvQ9RaVGBLK9s2jVDLT7vxkg4iHWfFqza.HGMiWr7zPFohiyFGLzP82jDnVXodLvpjvjKyVvNJ33Uv@Bkq5KLDMRiL9vAaHqwCN7LJ16ecvhU7WsJoeWqk6PYjG"
FILEPATH=""

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --relay)
            RELAY="$2"
            shift; shift ;;
        --test)
            TEST=1
            shift ;;
        --install)
            INSTALL=1
            shift ;;
        --service-provider)
            PROVIDER="$2"
            shift; shift ;;
        --dry-test)
            DRY_TEST=1
            shift ;;
        --help)
            print_help ;;
        *)
            FILEPATH="$1"
            shift ;;
    esac
done

if [[ ! -z "$TEST" ]]; then
    echo "Checking if croc is installed..."
    if ! command -v croc &> /dev/null; then
        echo "croc is not installed."
    else
        echo "croc is installed."
    fi

    echo "Checking if nym-socks5-client is running..."
    if ! pgrep -f nym-socks5-client &> /dev/null; then
        echo "nym-socks5-client is not running."
    else
        echo "nym-socks5-client is running."
    fi
    exit 0
fi

if [[ ! -z "$INSTALL" ]]; then
    echo "Installing nym-socks5-client..."
    # Replace with the correct download URL for the release
    wget https://github.com/nymtech/nym/releases/download/v1.1.23/nym-socks5-client-1.1.23.zip【17†source】
    unzip nym-socks5-client-1.1.23.zip
    chmod +x nym-socks5-client
    exit 0
fi

if [[ ! -f "$FILEPATH" ]]; then
    echo "File does not exist or permission denied: $FILEPATH"
    exit 1
fi

if ! command -v croc &> /dev/null; then
    echo "croc is not installed, do you want to install it now? (y/n)"
    read answer
    if [[ "$answer" == "y" ]]; then
        curl https://getcroc.schollz.com | bash
    fi
fi

if ! pgrep -f nym-socks5-client &> /dev/null; then

    echo "nym-socks5-client is not running, initializing..."
    nym-socks5-client init --id dialout_sp1 --provider "$PROVIDER" && sleep 5 && nym-socks5-client run --id dialout_sp1

    if ! pgrep -f nym-socks5-client &> /dev/null; then
        echo "Failed to start nym-socks5-client."
        exit 1
    fi
fi

if [[ ! -z "$DRY_TEST" ]]; then
    croc send "$FILEPATH"
else
    croc --relay "$RELAY" --socks5 "$SOCKS" send "$FILEPATH"
fi

