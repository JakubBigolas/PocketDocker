#function pdImageListItem {
#  local imagesDir=$1
#  shift
#  local dir=$1
#  shift
#  local printVersion=$1
#  shift
#  local printFormatted=$1
#  shift
#  local printPath=$1
#  shift
#  local printInheritance=$1
#  shift
#  local printInheritanceinverted=$1
#  shift
#  local selectedImages=($@)
#
#  local path="$imagesDir/$dir"
#  local dockerfile="$imagesDir/$dir/Dockerfile"
#  local version="$imagesDir/$dir/version"
#
#  local isSelected=true
#  if [[ ! ${#selectedImages[@]} -eq 0 ]]; then
#    isSelected=false
#    for selected in ${selectedImages[@]}
#    do
#      [[ $selected = $dir ]] && isSelected=true
#    done
#  fi
#
#
#  # if there is dockerfile it is image
#  if [[ -f "$dockerfile" ]] && [[ $isSelected = true ]]; then
#
#    # prepare version number
#    local versionNumber=
#    [[ $printVersion = true ]] && [[ -f "$version" ]] && versionNumber=":$(head -n 1 $version)"
#    [[ $printVersion = true ]] && [[ $printFormatted = true ]] && [[ -f "$version" ]] && versionNumber="${C_CYAN}:${C_BLUE}$(head -n 1 $version)${C_RESET}"
#
#    # prepare start and end format of line
#    local format=
#    [[ $printFormatted = true ]] && format=" - ${C_WHITE}"
#    local endingFormat=
#    [[ $printFormatted = true ]] && endingFormat="${C_RESET}"
#
#    # prepare path information
#    local pathToPrint=
#    [[ $printPath = true ]] && pathToPrint="{$path}"
#
#    [[ $printInheritance = true ]] && [[ $printInheritanceinverted = true ]] && pdImageListItemInheritance $printVersion $printFormatted $printPath $printInheritanceinverted "$dir" "$(pdImageList -a -p)"
#
#    # print
#    echo -e "$format$dir$versionNumber$endingFormat$pathToPrint"
#
#    # print ingeritance
#    [[ $printInheritance = true ]] && [[ ! $printInheritanceinverted = true ]] && pdImageListItemInheritance $printVersion $printFormatted $printPath $printInheritanceinverted "$dir" "$(pdImageList -a -p)"
#
#  else # if there is dockerfile it is subdirectory
#
#    items=$(ls $path)
#    for item in ${items[@]}
#    do
#      if [[ -d "$path/$item" ]]; then
#        pdImageListItem "$path" "$item" $printVersion $printFormatted $printPath $printInheritance $printInheritanceinverted ${selectedImages[@]}
#      fi
#    done
#
#  fi
#
#}