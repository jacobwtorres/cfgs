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

capture_note()
{
dbxcli get /JACT/Notes/CLINOTES.txt .CLINOTES.txt.tmp
echo "-" $(date) $1 >> .CLINOTES.txt.tmp
dbxcli put .CLINOTES.txt.tmp /JACT/Notes/CLINOTES.txt
rm .CLINOTES.txt.tmp
}
alias nn='capture_note'

