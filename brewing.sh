#!/bin/bash

# CASK directories
appdir=/Applications
caskroom=/usr/local/Caskroom
export HOMEBREW_CASK_OPTS="--appdir=$appdir --caskroom=$caskroom"

# packages
base=("ack" \
    "aspell --with-lang-en" \
    "bash-completion" \
    "emacs --cocoa --japanese" \
    "git" \
    "gnuplot" \
    "imagemagick" \
    "lv" \
    "nkf" \
    "openssl" \
    "python" \
    "rename" \
    "tree" \
    "vim")
opt=("autoconf" \
    "automake" \
    "binutils" \
    "boost" \
    "boost-python" \
    "byobu" \
    "ddrescue" \
    "erlang" \
    "gnu-sed" \
    "kindlegen" \
    "numpy" \
    "ode-drawstuff --enable-demos" \
    "opencv" \
    "pkg-config" \
    "readline" \
    "ruby" \
    "terminal-notifier" \
    "tiger-vnc" \
    "unrar" \
    "w3m" \
    "webkit2png" \
    "wget" \
    "xz")
cask_base=("atom" \
    "coteditor" \
    "flash-player" \
    "google-drive" \
    "google-japanese-ime" \
    "inkscape" \
    "iterm2" \
    "latexit" \
    "mactex" \
    "menumeters"
#    "microsoft-office" \
    "pandoc" \
    "sublime-text" \
    "spideroakone" \
    "texshop" \
    "the-unarchiver" \
    "vlc" \
    "xquartz")
cask_opt=("alfred" \
    "appcleaner" \
    "bathyscaphe" \	      
    "caffeine" \
    "displaylink" \
    "dropbox" \
    "evernote" \
    "firefox" \
    "flip4mac" \
    "github" \
    "google-chrome" \
    "google-earth" \
#    "google-music" \
    "grace" \
    "handbrake" \
    "handbrakecli" \
    "locko" \
    "mactracker" \
#    "name-mangler" \
    "odrive" \
    "omnidazzle" \
    "processing" \
    "skim" \
    "skype" \
    "sourcetree" \
    "virtualbox" \
    "xbench")

# checked install
function ck_install() {
    pkg=`echo $@ | cut -d " " -f 1`
    if [ -z `echo "$installed" | grep -x $pkg` ]; then
	$PRT brew install $@
    else
	$PRT echo "$pkg is already installed"
    fi
}
# checked cask install
function ck_cask_install() {
    pkg=`echo $@ | cut -d " " -f 1`
    if [ -z `echo "$cask_installed" | grep -x $pkg` ] ; then
	$PRT brew cask install $FORCE $@
    else
	echo "$pkg is already installed"
    fi
}
# cleaned cask upgrade
function cask_upgrade() {
    apps=($(brew cask list))
    for a in ${apps[@]};do
	info=$(brew cask info $a)
	if echo "$info"| grep -q "Not installed";then
	    brew cask uninstall $a
	    brew cask install $a
	fi
	current=$(echo "$info"|grep "${caskroom}/${a}"|cut -d' ' -f1)
	for dir in $(ls ${caskroom}/${a});do
	    testdir="${caskroom}/${a}/${dir}"
	    if [ "$testdir" != "$current" ];then
		rm -rf "$testdir"
	    fi
	done
    done
}

BASE=0
ALL=0
FORCE=""
PRT=""
while getopts uiafph opt; do
    case $opt in
	"u" ) BASE=0; ALL=0 ;;
	"i" ) BASE=1 ;;
	"a" ) ALL=1 ;;
	"f" ) FORCE="--force" ;;
	"p" ) PRT="echo" ;;
	"h" ) echo "usage: $0 [-uiafph]"
	    echo "  -u   Only Update & Upgrade installed packages [Default]"
	    echo "  -i   Install fundamental packages"
	    echo "  -a   Install all (fundamental & optional) packages"
	    echo "  -f   Force install cask packages"
	    echo "  -p   Print brew tasks (for check, not execute)"
	    echo "  -h   Show this help" ; exit ;;
	* ) ;;
    esac
done

# Add Repository
echo "* Tapping homebrew/binary"
$PRT brew tap homebrew/binary 2> /dev/null
echo "* Tapping homebrew/science"
$PRT brew tap homebrew/science 2> /dev/null
echo "* Tapping sanoakr/slab"
$PRT brew tap sanoakr/slab 2> /dev/null
#brew tap hirocaster/homebrew-mozc-emacs-helper

# Cask install
echo "* Install cask"
$PRT brew install caskroom/cask/brew-cask 2> /dev/null

installed=`brew list`
cask_installed=`brew cask list`

echo "brew updating..."
$PRT brew update

outdated=`brew outdated`
if [ -n "$outdated" ]; then
    cat << EOF
The following package(s) will upgrade.
$outdated

Are you sure?
If you do NOT want to upgrade, type Ctrl-c now.
EOF
	read -t 15 dummy
	$PRT brew upgrade
else
    cat <<EOF
No need upgrade packages.
EOF
fi

echo "Check cask upgrade."
cask_upgrade

if [ $BASE -eq 1 ]; then
    # install
    for e in "${base[@]}"; do ck_install $e; done

    # install cask
    for e in "${cask_base[@]}"; do ck_cask_install $e; done

    # optional install
    if [ $ALL -eq 1 ]; then
	for e in "${opt[@]}"; do ck_install $e; done
	for e in "${cask_opt[@]}"; do ck_cask_install $e; done
	#    brew cask alfred link
    fi
    cat <<EOF
*** Add following lisp lines to your ~/.emacs
*** if you want to use aspell on emacs.
(setq-default ispell-program-name "/usr/local/bin/aspell")
(eval-after-load "ispell"
  '(add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")))
EOF

fi
