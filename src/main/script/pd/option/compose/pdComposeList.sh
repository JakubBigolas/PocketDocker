#function pdImageList {
#
#  local printVersion=false
#  local printFormatted=false
#  local printAll=false
#  local printPath=false
#  local printInheritance=false
#  local printInheritanceinverted=false
#
#  # compose directory from config.sh
#  local composeDir="$PD_DOCKER_PROJECT_DIR/compose"
#
#  # project names from config.sh ahd params
#  local items=($PD_PROJECT_NAME)
#  local selectedImages=()
#
#  while [[ $# -gt 0 ]]; do
#    case $1 in
#      -v)
#        printVersion=true
#        shift
#        ;;
#      -f)
#        printFormatted=true
#        shift
#        ;;
#      -a)
#        printAll=true
#        shift
#        ;;
#      -p)
#        printPath=true
#        shift
#        ;;
#      -i)
#        printInheritance=true
#        shift
#        ;;
#      -I)
#        printInheritance=true
#        printInheritanceinverted=true
#        shift
#        ;;
#      --image)
#        selectedImages=($selectedImages $2)
#        shift
#        shift
#        ;;
#      --help)
#        echo -e ""
#        echo -e "Usage: dp ... image list [parameters] [projects]"
#        echo -e ""
#        echo -e "Display docker images information:"
#        echo -e ""
#        echo -e "Options:"
#        echo -e "${C_BLUE} -v          ${C_RESET}print version of docker image"
#        echo -e "${C_BLUE} -f          ${C_RESET}print formatted"
#        echo -e "${C_BLUE} -a          ${C_RESET}print info of all images"
#        echo -e "${C_BLUE} -p          ${C_RESET}print images location path"
#        echo -e "${C_BLUE} -i          ${C_RESET}print inheritance"
#        echo -e "${C_BLUE} -I          ${C_RESET}print inheritance inverted"
#        echo -e "${C_BLUE} --image     ${C_RESET}print information for selected image"
#        echo -e ""
#        exit 0
#        ;;
#      *)
#        items=(${items[@]} $1)
#        shift
#        ;;
#    esac
#  done
#
#  # or all available
#  [[ -z "$items" ]] && printAll=true
#  [[ $printAll = true ]] && items=$(ls $imagesDir)
#
#  [[ $printFormatted = true ]] && echo ""
#  # for each project name
#  for item in ${items[@]}
#  do
#    if [[ -d "$imagesDir/$item" ]]; then
#      [[ $printFormatted = true ]] && echo "Project: $item"
#      pdImageListItem "$imagesDir" "$item" $printVersion $printFormatted $printPath $printInheritance $printInheritanceinverted ${selectedImages[@]}
#      [[ $printFormatted = true ]] && echo ""
#    else
#      [[ $printFormatted = true ]] && echo -e "${C_RED}There is no project $item${C_RESET}"
#    fi
#  done
#
#}
#
## pd compose list
#
## pd compose list kzw
## pd -p arimr compose list
#
## pd compose list arimr s02
## pd -p arimr -e s02 compose list
#
## pd compose list -s -f --hide-services --show-networks kzw
#
#-s (statsu)
#-f (format)