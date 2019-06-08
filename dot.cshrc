source /tools/stabflow/iot/cshrc.iot
setenv ARMLMD_LICENSE_FILE 8224@armlmd-aus-prod-wan.licenses.cypress.com #8224@xpls7.design.cypress.com
setenv PERL5LIB "/projects/wpan_git/tools/perl5/lib/perl5"
setenv TOOLS_DIR "/projects/wpan_git/tools"

setenv CSCOPEVER OS

cd /proj_netapp/iot_ws/blth/jact

alias cs_setup 'rm cscope*; find . -name "*.c" -o -name "*.cpp" -o -name "*.h" -o -name "*.hpp" > cscope.files; cscope -q -R -b -i cscope.files;'

