function pdImageListHelp {

  [[ ! -z "$@" ]] && echo -e "${C_RED}Unhandled arguments: $@" && exit 1
  echo -e ""
  echo -e "Usage: list [parameters] [project/image list]"
  echo -e ""
  echo -e "Display docker images information for selected projects."
  echo -e "If any project name were not selected then global project name will be used."
  echo -e "If there is no global project name set then all available projects will be used."
  echo -e ""
  echo -e "Arguments:"
  pdToolHelpOptionPrint '-a'               'print info of all projects/images, overrides all configs'
  pdToolHelpOptionPrint '-f'               'print selected information in user friendly format'
  pdToolHelpOptionPrint '-i'               'print inheritance (only available in project docker)'
  pdToolHelpOptionPrint '-I'               'print inheritance inverted (only available in project docker)'
  pdToolHelpOptionPrint ''                 'starting from most base image to most specific'
  pdToolHelpOptionPrint '-p'               'print images location path in format: image-name{path}'
  pdToolHelpOptionPrint '-v'               'print version of docker image in format image-name:version'
  pdToolHelpOptionPrint '-?'               'print this help info'
  pdToolHelpOptionPrint '--image <VALUE>'  'print information for selected image <VALUE> name'
  pdToolHelpOptionPrint '--help'           'print this help info'
  echo -e ""
  exit 0

}


