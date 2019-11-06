cscope_setup()
{
rm cscope*
find . -name "*.c" -o -name "*.cpp" -o -name "*.h" -o -name "*.hpp" > cscope.files
cscope -q -R -b -i cscope.files
}
alias cs_setup='cscope_setup'

git_branch_va()
{
echo 'Local Branches:'
git for-each-ref --sort=-committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) (%(co
lor:green)%(committerdate:relative)%(color:reset)) %(contents:subject) %(color:red)(%(authorname))'
echo 'Remote Branches:'
git for-each-ref --sort=-committerdate refs/remotes/origin/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:res
et) (%(color:green)%(committerdate:relative)%(color:reset)) %(contents:subject) %(color:red)(%(authorname))'
}
alias gbva='git_branch_va'

dec_file()
{
openssl enc -d -aes-192-cbc -in $1
}
alias dec='dec_file'

enc_file()
{
openssl enc -aes-192-cbc -in $1
}
alias enc='enc_file'

compress_recursively_gzip()
{
tar -cvzf $1.tar.gz $1
}
alias comp='compress_recursively_gzip'

decompress_gzip()
{
tar -xvzf $1 -C $1
}
alias decomp='decompress_gzip'

capture_note()
{
    printf "MISC\nDISPERSE\n- $(date) $1\n" | dbnn
}
alias nn='capture_note'

capture_todo()
{
    printf "MISC\nTODO\n- $(date) $1\n" | dbnn
}
alias todo='capture_todo'

capture_mig()
{
    printf "MISC\nMIG\n- $(date) $1\n" | dbnn
}
alias mig='capture_mig'

image_grep()
{
find ${1-.} -type f \( -iname \*.jpg -o -iname \*.png \) -exec tesseract {} stdout | grep ${2-"*"} $3 \; -exec echo {} \;
#find ${1-.} -type f \( -iname \*.jpg -o -iname \*.png \) -exec echo {} \; | echo $1 && tesseract $1 stdout | grep ${2-"*"} $3
}
alias vgrep='image_grep'

lsop_func()
{
lsof -iTCP -sTCP:LISTEN -n -P
}
alias lsop='lsop_func'


dbnn_func()
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
alias dbnn='dbnn_func'

