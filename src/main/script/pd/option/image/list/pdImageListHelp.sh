function pdImageListHelp {

  echo -e ""
  echo -e "Print PocketDocker images info"
  echo -e ""
  echo -e "Usage: list [Arguments...]"
  echo -e ""
  echo -e "Arguments:"
  pdToolHelpOptionPrint '-f'               'print selected information in user friendly format'
  pdToolHelpOptionPrint '-i'               'print inheritance'
  pdToolHelpOptionPrint '-I'               'print inheritance inverted (working only for non formatted version)'
  pdToolHelpOptionPrint '-N'               'hide image names'
  pdToolHelpOptionPrint '-p'               'print images location path'
  pdToolHelpOptionPrint '-v'               'print version of docker image'
  pdToolHelpOptionPrint '-x'               'print packages'
  pdToolHelpOptionPrint '--image *'        'print information for specific image name'
  pdToolHelpOptionPrint '--package *|*'    'print information for specific package (and sub packages)'
  pdToolHelpOptionPrint '--help|help|-?'   'print this help info'
  echo -e ""
  exit 0

}