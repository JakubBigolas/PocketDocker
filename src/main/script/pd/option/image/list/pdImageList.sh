function pdImageList {

  local printVersion=false
  local printFormatted=false
  local printAll=false
  local printPath=false
  local printInheritance=false
  local printInheritanceinverted=false

  # images directory from config.sh
  local imagesDir="$PD_DOCKER_PROJECT_DIR/images"

  local selectedImages=()
  local items=()

  while [[ $# -gt 0 ]]; do
    case $1 in
      --help|"-?")
        shift
        eval pdImageListHelp "$@"
        exit 0
        ;;
      -v)
        printVersion=true
        shift
        ;;
      -f)
        printFormatted=true
        shift
        ;;
      -a)
        printAll=true
        shift
        ;;
      -p)
        printPath=true
        shift
        ;;
      -i)
        printInheritance=true
        shift
        ;;
      -I)
        printInheritance=true
        printInheritanceinverted=true
        shift
        ;;
      --image)
        selectedImages=(${selectedImages[@]} $2)
        shift
        shift
        ;;
      *) # Display docker images information for selected projects
        items=(${items[@]} $1)
        shift
        ;;
    esac
  done

  # If any project name were not selected then global project name will be used.
  [[ ! "${#items[@]}" -gt 0 ]] && items=($PD_PROJECT_NAME)

  # If there is no global project name set then all available projects will be used.
  [[ ! "${#items[@]}" -gt 0 ]] && printAll=true

  # print info of all projects/images, overrides all configs
  [[ $printAll = true ]] && items=$(ls $imagesDir)

  [[ $printFormatted = true ]] && echo ""

  # for each project name
  for item in ${items[@]}
  do
    if [[ -d "$imagesDir/$item" ]]; then
      [[ $printFormatted = true ]] && echo "Project: $item"
      pdImageListItem "$imagesDir" "$item" $printVersion $printFormatted $printPath $printInheritance $printInheritanceinverted ${selectedImages[@]}
      [[ $printFormatted = true ]] && echo ""
    else
      [[ $printFormatted = true ]] && echo -e "${C_RED}There is no project $item${C_RESET}"
      [[ $printFormatted = true ]] && echo ""
    fi
  done

}