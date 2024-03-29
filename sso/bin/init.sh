#!/usr/bin/env bash

export $(grep -v '^#' .env | xargs)

# Check Connection
function check_vpn_connection() {
  server=$1
  port=$2
  if nc -z "$server" "$port" 2>/dev/null; then
    echo -e "VPN Connection $server Passed ✅ \n"
    return 0
  else
    echo -e "VPN Connection $server Failed ❌ \n"
    return 1
  fi
}

function git_clone(){
    cd sso/bin/
    if [ ! -d duo-sso ];then 
        git clone https://$VPN_GIT_HOST/ATS-operations/duo-sso/
    fi
    cd -
}

function build_linux_bin(){
    cd sso/bin/duo-sso
    if [ ! -f build/duo-sso_linux_amd64 ];then 
        BUILD_IMAGE=golang:1.19
        mkdir -p build
        docker pull "$BUILD_IMAGE"
        docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp -e GOOS=linux -e GOARCH=amd64 "$BUILD_IMAGE" go build -o build/aws-sso
    fi
    cd -
}

function clean(){
    rm -fr sso/bin/duo-sso
}

function main(){
    if [ ! -f sso/bin/aws-sso ];then 
        check_vpn_connection "$VPN_GIT_HOST" 443 || return 1
        git_clone
        build_linux_bin
        mv sso/bin/duo-sso/build/aws-sso sso/bin/aws-sso
        clean
    else 
        echo -e "aws-sso binary exists"
    fi 
}

main $@





