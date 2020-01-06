#export JAVA_HOME=/home/joshliu/Developer/dev_tools/jdk1.7.0_79
export JAVA_HOME=/home/joshliu/Developer/jdk1.8.0_212
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib:$CLASSPATH
export NDK_HOME=/home/joshliu/Developer/dev_tools/android-ndk-r8e
export ANDROID_HOME=/home/joshliu/Developer/android_sdk
export PATH=$JRE_HOME:$NDK_HOME:$JAVA_HOME/bin:$JRE_HOME/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools:$PATH
export PATH=$PATH:/home/joshliu/Developer/depot_tools
#export CHROMIUM_BUILDTOOLS_PATH=/workdisk/git/blink_db_for_tbs_for_chromium_57/blink_core/lib/chromium_org/buildtools/

allcscope(){
find . \( -name "*.h" -o -name "*.dart" -o -name "*.cc" -o -name "*.cpp" -o -name "*.java" \) -a \( ! -path "*test*" -a ! -path "*Test*" -a ! -name "*test*" -a ! -name "*Test*" \) > cscope.files
cscope -Rbq -i cscope.files
}

allctags(){
args="-R --exclude=.git* --exclude=*test* --exclude=*Test* -f .tags"
if [ $# != 0 ]; then
    args="$args $*"
fi
ctags $args
}

so2tags(){
    rm gdb.txt
    gdb $1 -ex "set logging redirect on" -ex "set pagination off" -ex "set logging on" -ex "info sources" -ex "quit"
    sed 's/,\s*/\n/g' gdb.txt > file_list.txt
    ctags --c++-kinds=+p --c-kinds=+p --fields=+iaS --extra=+q -L file_list.txt
    rm file_list.txt gdb.txt
    echo "Done."
}

jlog(){
if [ $# == 1 ]; then
    if [ "$1" == "-c" ]; then
        adb logcat -c
    else
        adb logcat -v time|grep $1
    fi
elif [ $# == 2 ]; then
    if [ "$1" == "-c" ]; then
        adb logcat -c
        adb logcat -v time|grep $2
    fi
else
    adb logcat -v time
fi
}

run_nc(){
local_ip=`hostname -I`
nc_port=3456
echo "telnet $local_ip $nc_port"
nc -l $nc_port
}

make_proxy(){
export http_proxy="http://web-proxy.ten.com:8080/"
export https_proxy="https://web-proxy.ten.com:8080/"
}

clear_proxy(){
export http_proxy=""
export https_proxy=""
}

git_alias(){
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.chp cherry-pick
git config --global alias.jcl 'clean -fd -e cscope* -e .tags -e *sublime*'
}

git_proxy(){
if [ "$1" == "reset" ]; then
  git config --unset http.proxy
  git config --unset https.proxy
elif [ "$1" == "set" ]; then
  git config http.proxy http://web-proxy.ten.com:8080
  git config https.proxy https://web-proxy.ten.com:8080
fi
}

dump_git_log() {
git log -2 --pretty=format:%h,%an,%ae,%s > gitlog.txt
}

git_alias
clear_proxy

export PATH=$PATH:/home/joshliu/Developer/gradle-4.1/bin
export CCACHE_DIR=/harddisk/ccache_tmp/

source ~/git-completion.bash

# added by Anaconda3 4.3.1 installer
#export PATH="/home/joshliu/anaconda3/bin:$PATH"

export PATH=/workdisk/dev_tools/idea-IU-173.4548.28/bin:$PATH
export PATH=/workdisk/dev_tools/android-studio/bin:$PATH
export PATH=/harddisk/root/workdisk/git/flutter_repo/flutter/bin:$PATH
export PATH=/workdisk/dev_tools/ripgrep-0.8.1-x86_64-unknown-linux-musl:$PATH

#export PATH=/harddisk/root/workdisk/env/node-v8.11.1-linux-x64/:$PATH

export PATH=/workdisk/dev_tools/tldr:$PATH



export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/joshliu/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/joshliu/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/joshliu/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/joshliu/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"
export PATH="/workdisk/git/protoc-3.9.1-linux-x86_64:$PATH"

# Setup repeated key
xset r rate 300 40
