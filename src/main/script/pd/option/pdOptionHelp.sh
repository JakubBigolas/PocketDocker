function pdOptionHelp {

  [[ ! -z "$@" ]] && echo -e "${C_RED}Unhandled arguments: $@" && exit 1

  echo -e ""
  echo -e "Usage: dp [arguments...] [option]"
  echo -e ""
  echo -e "Display docker images information:"
  echo -e ""
  echo -e "Arguments:"
  pdToolHelpOptionPrint '-p <VALUE>'        'set <VALUE> as project name'
  pdToolHelpOptionPrint '-e <VALUE>'        'set <VALUE> as environment name'
  pdToolHelpOptionPrint '-H'                'hide header with project/env'
  pdToolHelpOptionPrint '-?'                'print this help info'
  pdToolHelpOptionPrint '--show-totaltime'  'print total execution time at end'
  pdToolHelpOptionPrint '--help'            'print this help info'
  echo -e ""
  echo -e "Options:"
  pdToolHelpOptionPrint 'version' 'print version info'
  pdToolHelpOptionPrint 'status'  'print current config info'
  pdToolHelpOptionPrint 'image'   'docker images project management'
  echo -e ""

}