;= @echo off
;= rem Call DOSKEY and use this file as the macrofile
;= %SystemRoot%\system32\doskey /listsize=1000 /macrofile=%0%
;= rem In batch mode, jump to the end of the file
;= goto:eof
;= Add aliases below here
e.=explorer .
gl=git log --oneline --all --graph --decorate  $*
ls=ls --show-control-chars -F --color $*
pwd=cd
clear=cls
unalias=alias /d $1
vi=vim $*


cmder-start=cmder /REGISTER USER

readelf=llvm-readelf $*
addr2line=llvm-addr2line $*
a2l=addr2line -C -f -e $1 -i $2
objdump=llvm-objdump $*

kc=adb shell pkill camera*
lc=adb logcat -c
logcat=adb logcat | grep -iE --color $*
