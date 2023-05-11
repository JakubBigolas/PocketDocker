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

  # split image line for specific data
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
    local depth=0
    local previousPackage=(${previousPackage//"/"/ }) # there is no missing "" in this line
    local currentPackage=(${imagePackage//"/"/ }) # there is no missing "" in this line
    local previousPath=
    local currentPath=
    while [[ $depth -lt ${#currentPackage[@]} ]] ; do
      local previousPackageItem="${previousPackage[$depth]}"
      local currentPackageItem="${currentPackage[$depth]}"

      [[ -n "$previousPackageItem" ]] && previousPath+="$previousPackageItem/"
      [[ -n "$currentPackageItem" ]] && currentPath+="$currentPackageItem/"

      [[ "$previousPath" != "$currentPath" ]] && printf "%$((depth * 3 + 1))s %s" "-" "$currentPackageItem" \
       && [[ $((depth + 1)) -lt ${#currentPackage[@]} ]] && echo

      depth=$((depth + 1))
    done

    # print info with colors
    local lineToPrint=""

    [[ $printImageName = true ]] && lineToPrint+="${C_YELLOW}:${C_WHITE}$imageName${C_RESET}"
    [[ $printVersion   = true ]] && lineToPrint+="${C_YELLOW}${lineToPrint:+":"}${C_BLUE}$imageVersion${C_RESET}"
    [[ $printPath      = true ]] && lineToPrint+="${C_YELLOW}${lineToPrint:+":"}${C_CYAN}{path:$imagePath}${C_RESET}"

    echo -e "$lineToPrint"
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
    echo "$lineToPrint"
    [[ $printInheritance         = true ]] && pdImageListItemInheritance "$imagesDir" "$image" $printFormatted $printPackage $printImageName $printVersion $printPath $printInheritanceInverted "" "${allImages[@]}"
  fi

}