#!/bin/bash

dec(){ openssl enc -d -aes-192-cbc -in $1 ; }

enc(){ openssl enc -aes-192-cbc -in $1 ; }

comp(){ tar -cvzf $1.tar.gz $1 ; }

decomp(){ tar -xvzf $1 ; }

nn(){ printf "MISC\nDISPERSE\n- $(date) $1\n" | dbnn ; }

todo(){ printf "MISC\nTODO\n- $(date) $1\n" | dbnn ; }

mig(){ printf "MISC\nMIG\n- $(date) $1\n" | dbnn ; }

vgrep(){ find ${1-.} -type f \( -iname \*.jpg -o -iname \*.png \) -exec tesseract {} stdout | grep ${2-"*"} $3 \; -exec echo {} \; ; }

lsop(){ lsof -iTCP -sTCP:LISTEN -n -P ; }

gl(){ git log --graph --oneline --decorate --color | less -SEXIER ; }

cs_setup()
{
    rm cscope*
    find . -name "*.c" -o -name "*.cpp" -o -name "*.h" -o -name "*.hpp" > cscope.files
    cscope -q -R -b -i cscope.files
}

gbva()
{
    echo 'Local Branches:'
    git for-each-ref --sort=-committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) (%(color:green)%(committerdate:relative)%(color:reset)) %(contents:subject) %(color:red)(%(authorname))'

    echo 'Remote Branches:'
    git for-each-ref --sort=-committerdate refs/remotes/origin/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) (%(color:green)%(committerdate:relative)%(color:reset)) %(contents:subject) %(color:red)(%(authorname))'
}

dbnn()
{
    local DBXKEYENC='\x53\x61\x6c\x74\x65\x64\x5f\x5f\x94\x6a\x71\x7f\xe2\xae\x3a\xdc\xb7\x93\x7b\x73\x09\xf7\xf4\x51\x7e\xbd\xfe\xee\x44\x7b\xe5\x10\xcd\x4b\x2a\xc5\xd2\xa3\xaa\x55\x0f\xba\xde\x12\x51\xaf\xe2\x47\xa8\xd4\xda\xbc\xd3\x55\xc7\x01\x87\x13\xee\xaf\x5b\x3d\x4c\x62\x2b\xd3\x1b\xed\x52\x43\x6e\x2e\xcb\x79\x72\xb4\xa0\x60\xe5\x68\x3d\x7a\xd5\xde\x18\x31\x63\x0b\xd8\x20\x2e\x6b\xba\xf7\xcd\x0c'
    local RAND=$RANDOM

    read -p "Enter directory name (optional): " notedir
    read -p "Enter note name: " notename
    read -p "Enter note: " notecontents

    local DBXKEY=$(openssl enc -d -aes-192-cbc -in <(echo -e -n $DBXKEYENC))

    if [[ $notename == "" ]]; then
        echo "File name required, aborintg"
        return
    fi

    if [[ $notedir != "" ]]; then
        local DBXPATH="/Notes/$notedir/$notename.txt"
    else
        local DBXPATH="/Notes/$notename.txt"
    fi

    local TMPFILE=".$notename$RAND.tmp"


    CURLRESP=$(curl -X POST https://content.dropboxapi.com/2/files/download \
                --header "Authorization: Bearer $DBXKEY" \
                --header "Dropbox-API-Arg: {\"path\": \"$DBXPATH\"}" 2> /dev/null)

    if [[ $? -ne 0 ]]; then
        echo "Error occured, aborting"
        return
    fi

    if [[ $CURLRESP =~ \{\"error_summary\":* ]]; then
        if [[ $CURLRESP =~ \"path\/not_found\/ ]]; then
            read -p "File not found, create new file? (y/N): " notecreate
            if [[ $notecreate =~ [^y^Y] ]]; then
                echo "Aborting"
                return
            fi
        else
            echo "Unknown error occured, aborting"
            return
        fi
    else
        echo $CURLRESP > $TMPFILE
    fi

    echo $notecontents >> $TMPFILE

    curl -X POST https://content.dropboxapi.com/2/files/upload \
        --header "Authorization: Bearer $DBXKEY" \
        --header "Dropbox-API-Arg: {\"path\": \"$DBXPATH\",\"mode\": \"overwrite\",\"autorename\": false,\"mute\": false,\"strict_conflict\": false}" \
        --header "Content-Type: application/octet-stream" \
        --data-binary @$TMPFILE &> /dev/null

    if [[ $? -ne 0 ]]; then
        echo "Error occured, aborting"
        return
    fi

    rm $TMPFILE

}

c_boiler_text="#include \"stdlib.h\"
#include \"stdio.h\"
#include \"string.h\"

int main( void )
{
    return 0;
}"
c_boiler(){ echo "$c_boiler_text" >> main.c ; }

#sudo scp username@0.0.0.0:path/starting/at/home/to/file.txt ~/Downloads #sends file.txt from remote to local Downloads dir

