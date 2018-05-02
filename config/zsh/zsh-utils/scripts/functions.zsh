source_scripts_in_tree()
{
  script_root=${1}
  utilities=($(find -L ${script_root} -type f -name "*.zsh"))

  osx_suffix=_osx.zsh
  win_suffix=_win.zsh
  linux_suffix=_linux.zsh

  case ${OSTYPE} in
    darwin*)
      #ここにMac向けの設定
      utilities=($(for ut in ${utilities}; echo ${ut}|grep -v $win_suffix|grep -v $linux_suffix))
      ;;
    linux*)
      #ここにLinux向けの設定
      utilities=($(for ut in ${utilities}; echo ${ut}|grep -v $win_suffix|grep -v $osx_suffix))
      ;;
    cygwin*|msys*)
      #ここにWindows向けの設定
      utilities=($(for ut in ${utilities}; echo ${ut}|grep -v $osx_suffix|grep -v $linux_suffix))
      ;;
  esac
  export utilities
  for utility in ${utilities}; do
    source ${utility}
  done
}
