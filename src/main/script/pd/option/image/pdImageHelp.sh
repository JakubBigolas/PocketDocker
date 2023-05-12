function pdImageHelp {

  echo -e ""
  echo -e "PocketDocker images project management"
  echo -e ""
  echo -e "Usage: image [option]"
  echo -e ""
  echo -e "Options:"
  pdToolHelpOptionPrint '--help|help|-?'   'print this help info'
  pdToolHelpOptionPrint 'list'             'print PocketDocker images info'
  pdToolHelpOptionPrint 'build'            'build PocketDocker images projects'
  echo -e ""
  exit 0

}