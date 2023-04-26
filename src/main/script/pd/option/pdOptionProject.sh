function pdOptionProject {

  local option=

  while [[ $# -gt 0 ]]; do
    case $1 in
      status)
        option=$(pdToolUpperCaseFirstLetter "$1")
        shift
        break;
        ;;
      *)
        echo "Unknown option $1"
        exit 1
        ;;
    esac
  done

  # Default option is "List"
  [[ -z "$option" ]] && option=List

  eval pdProject$option "$@"

}


function pdProjectStatus {

  local composeDir="$PD_DOCKER_PROJECT_DIR/compose"
  local imagesDir="$PD_DOCKER_PROJECT_DIR/images"

  local projects=()

  for file in `ls $composeDir` ; do [[ -d "$composeDir/$file" ]] && projects=(${projects[@]} $file) ; done
  for file in `ls $imagesDir` ;  do [[ -d "$imagesDir/$file"  ]] && projects=(${projects[@]} $file) ; done

  projects=(`stdArraysUnique ${projects[@]}`)

  for project in ${projects[@]}
  do
    echo -e ""
    echo -e "Project: $project"
    echo -e "   Images:"
    for image in `pdImageList $project`
    do
      echo -e "    - ${C_WHITE}$image${C_RESET}"
    done

    echo ""
    echo "   Environments:"


  done

  echo ""



}