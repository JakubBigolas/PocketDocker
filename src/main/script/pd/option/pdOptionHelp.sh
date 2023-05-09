function pdOptionHelp {

  [[ ! -z "$@" ]] && echo -e "${C_RED}Unhandled arguments: $@" && exit 1

  echo -e ""
  echo -e "Usage: dp [arguments...] [option]"
  echo -e ""
  echo -e "Display docker images information:"
  echo -e ""
  echo -e "Arguments:"
  pdToolHelpOptionPrint '-?'                'print this help info'
  pdToolHelpOptionPrint '--show-totaltime'  'print total execution time at end'
  pdToolHelpOptionPrint '--help'            'print this help info'
  echo -e ""
  echo -e "Options:"
  pdToolHelpOptionPrint 'version' 'print version info'
  pdToolHelpOptionPrint 'help'    'print this help info'
  pdToolHelpOptionPrint 'image'   'docker images project management'
  pdToolHelpOptionPrint 'compose' 'docker composes project management'
  echo -e ""

}