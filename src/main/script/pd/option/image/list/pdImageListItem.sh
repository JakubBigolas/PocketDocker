function pdImageListItem {
  local imagesDir="$1"                ; shift
  local image="$1"                    ; shift
  local printFormatted="$1"           ; shift
  local printPackage="$1"             ; shift
  local printImageName="$1"           ; shift
  local printVersion="$1"             ; shift
  local printPath="$1"                ; shift
  local printInheritance="$1"         ; shift
  local printInheritanceInverted="$1" ; shift
  local previousPackage="$1"          ; shift
  local allImages=("$@")

  # unwrap image line for specific data
  local imagePackage=
  local imageName=
  local imageVersion=
  local imagePath=
  imagePackage="${image/":"*/}"
  imageName="${image/"$imagePackage:"/}"
  imageName="${imageName/":"*/}"
  imageVersion="${image/*":"/}"
  imagePath="$imagesDir/$imagePackage"

  # formatted printing
  if [[ $printFormatted = true ]] ; then

    # print package name as directory tree

    # unwrap packages to array of directory names
    local previousPackage=(${previousPackage//"/"/ }) # there is no missing "" in this line
    local currentPackage=(${imagePackage//"/"/ })     # there is no missing "" in this line
    local previousPath=
    local currentPath=
    local depth=0
    while [[ $depth -lt ${#currentPackage[@]} ]] ; do

      # get current and previous directory name for same depth
      local previousPackageItem="${previousPackage[$depth]}"
      local currentPackageItem="${currentPackage[$depth]}"

      # add it to previous and current path
      [[ -n "$previousPackageItem" ]] && previousPath+="$previousPackageItem/"
      [[ -n "$currentPackageItem" ]] && currentPath+="$currentPackageItem/"

      # if the difference occurred while comparing paths
      if [[ "$previousPath" != "$currentPath" ]] ; then

        # print package with depth empty space
        printf "%$((depth * 3 + 1))s %s" "-" "$currentPackageItem"

        # if it is last package dir append end line
        [[ $((depth + 1)) -lt ${#currentPackage[@]} ]] && echo

      fi

      # continue for another depth index
      depth=$((depth + 1))

    done

    local lineToPrint=""

    [[ $printImageName = true ]] && lineToPrint+="${C_YELLOW}:${C_WHITE}$imageName${C_RESET}"
    [[ $printVersion   = true ]] && lineToPrint+="${C_YELLOW}${lineToPrint:+":"}${C_BLUE}$imageVersion${C_RESET}"
    [[ $printPath      = true ]] && lineToPrint+="${C_YELLOW}${lineToPrint:+":"}${C_CYAN}{path:$imagePath}${C_RESET}"

    printf "$lineToPrint"
    echo
    [[ $printInheritance         = true ]] && pdImageListItemInheritance "$imagesDir" "$image" $printFormatted $printPackage $printImageName $printVersion $printPath false $depth "${allImages[@]}"

  # simple printing
  else
    local lineToPrint=""

    [[ $printPackage   = true ]] && lineToPrint+="$imagePackage"
    [[ $printImageName = true ]] && lineToPrint+="${lineToPrint:+":"}$imageName"
    [[ $printVersion   = true ]] && lineToPrint+="${lineToPrint:+":"}$imageVersion"
    [[ -n "$lineToPrint" ]] && [[ $printPath = true ]] && lineToPrint+="${lineToPrint:+":"}{path:$imagePath}"
    [[ -z "$lineToPrint" ]] && [[ $printPath = true ]] && lineToPrint+="$imagePath"

    [[ $printInheritanceInverted = true ]] && pdImageListItemInheritance "$imagesDir" "$image" $printFormatted $printPackage $printImageName $printVersion $printPath $printInheritanceInverted "" "${allImages[@]}"
    printf "$lineToPrint"
    echo
    [[ $printInheritance         = true ]] && pdImageListItemInheritance "$imagesDir" "$image" $printFormatted $printPackage $printImageName $printVersion $printPath $printInheritanceInverted "" "${allImages[@]}"
  fi

}