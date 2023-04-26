function pdImageHelp {

  [[ ! -z "$@" ]] && echo -e "${C_RED}Unhandled arguments: $@" && exit 1
  echo -e ""
  echo -e "Usage: help [option]"
  echo -e ""
  echo -e "Arguments:"
  pdToolHelpOptionPrint '-?'   'print this help info'
  pdToolHelpOptionPrint '--help'   'print this help info'
  echo -e ""
  echo -e "Options:"
  pdToolHelpOptionPrint 'help'   'print this help info'
  pdToolHelpOptionPrint 'list'   'print docker images info'
  pdToolHelpOptionPrint 'build'  'build docker images projects'
  echo -e ""
  exit 0

}