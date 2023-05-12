function pdOptionHelp {

  [[ ! -z "$*" ]] && echo -e "${C_RED}Unhandled arguments: $*" && exit 1

  echo -e "PockerDocker (pdocker) "
  echo -e ""
  echo -e "PocketDocker has been made to make docker images and envs development easier."
  echo -e "It allows to manage image projects and docker compose enviroments."
  echo -e ""
  echo -e "Usage: pdocker [arguments...] [option]"
  echo -e ""
  echo -e "Arguments:"
  pdToolHelpOptionPrint '--help|help|-?'        'print help info and exit'
  pdToolHelpOptionPrint 'version|--version|-v'  'print version info and exit'
  pdToolHelpOptionPrint '--totaltime'           'print total time at end'
  pdToolHelpOptionPrint '--docker-project-path' 'print docker project path variable and exit'
  echo -e ""
  echo -e "Options:"
  pdToolHelpOptionPrint 'image'   'PocketDocker images project management'
  pdToolHelpOptionPrint 'compose' 'PocketDocker composes project management'
  echo -e ""

}