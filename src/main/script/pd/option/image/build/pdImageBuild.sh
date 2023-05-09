function pdImageBuild {

  local imagesToBuild=()
  local paramSilent=false

  while [[ $# -gt 0 ]]; do
    case $1 in
      --help|"-?")
        shift
        [[ ! -z "$@" ]] && echo -e "${C_RED}Unhandled arguments: $@" && exit 1
        echo -e ""
        echo -e "Usage: list [parameters] [project list]"
        echo -e ""
        echo -e "Run docker image build process for selected images."
        echo -e "If any project name were not selected then global project name will be used."
        echo -e "If there is no global project name set then all available projects will be used."
        echo -e ""
        echo -e "Arguments:"
        pdToolHelpOptionPrint '-s'       'print build log to logfile instead of stdout'
        pdToolHelpOptionPrint '-?'       'print this help info'
        pdToolHelpOptionPrint '--help'   'print this help info'
        echo -e ""
        exit 0
        ;;
      -s)
        paramSilent=true
        shift
        ;;
      *)
        imagesToBuild=(${imagesToBuild[@]} $1)
        shift
        ;;
    esac
  done

  [[ -z "$imagesToBuild" ]] && imagesToBuild=($(pdImageList))

  local imageBuildQueue=()

  local image=
  for image in ${imagesToBuild[@]}
  do
    imageBuildQueue=(${imageBuildQueue[@]} $(pdImageList -a -I --image $image))
  done

  imageBuildQueue=($(stdArraysUnique ${imageBuildQueue[@]}))

  echo ""
  echo "Image build queue:"
  local image=
  for image in ${imageBuildQueue[@]}
  do
    echo -e " - ${C_WHITE}$image${C_RESET}"
  done
  for image in ${imageBuildQueue[@]}
  do
    pdImageBuildItem $image $paramSilent
  done

}