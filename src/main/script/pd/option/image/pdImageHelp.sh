function pdImageHelp {

  [[ ! -z "$@" ]] && echo -e "${C_RED}Unhandled arguments: $@" && exit 1
  echo -e ""
  echo -e "Usage: help [option]"
  echo -e ""
  echo -e "Arguments:"
  pdToolHelpOptionPrint '--help|help|-?'   'print this help info'
  echo -e ""
  echo -e "Options:"
  pdToolHelpOptionPrint 'list'             'print docker images info'
  pdToolHelpOptionPrint 'build'            'build docker images projects'
  echo -e ""
  exit 0

}