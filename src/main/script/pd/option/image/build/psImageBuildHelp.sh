function pdImageBuildHelp {

  echo -e ""
  echo -e "Build PocketDocker images projects"
  echo -e ""
  echo -e "Usage: build [args...]"
  echo -e ""
  echo -e "Arguments:"
  pdToolHelpOptionPrint '-s'              'prevent of printing log file to standard output'
  pdToolHelpOptionPrint '--image *'       'build image specified by name'
  pdToolHelpOptionPrint '--package *|*'   'build all images for package (and sub packages)'
  pdToolHelpOptionPrint '--help|help|-?'  'print this help info'
  echo -e ""

}