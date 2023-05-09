function pdImageListItemInheritance {
  local imagesDir="$1"                ; shift
  local image="$1"                    ; shift
  local printFormatted="$1"           ; shift
  local printPackage="$1"             ; shift
  local printImageName="$1"           ; shift
  local printVersion="$1"             ; shift
  local printPath="$1"                ; shift
  local printInheritanceInverted="$1" ; shift
  local depth="$1"                    ; shift
  local allImages=("$@")

  # split image line for specific data
  local imagePackage="$image"
  local imageName="$image"
  local imageVersion="$image"
  local imagePath=
  imagePackage="${imagePackage/":"*/}"
  imageName="${imageName/"$imagePackage:"/}"
  imageName="${imageName/":"*/}"
  imageVersion="${imageVersion/*":"/}"
  imagePath="$imagesDir/$imagePackage"

  # find FROM clause in Dockerfile
  local fromWithVersion
  fromWithVersion=$(cat "$imagesDir/$imagePackage/Dockerfile" | grep -e "^FROM ")
  fromWithVersion=${fromWithVersion/FROM /}

  if [[ -n "$fromWithVersion" ]] ; then

    # retrieve inherited image name and version
    local fromImage=${fromWithVersion/:*/}
    local fromVersion="${fromWithVersion/"$fromImage"/}"
    fromVersion="${fromVersion/":"/}"

    # last found image data
    local itemPackage=
    local itemName=
    local itemVersion=
    local itemPath=
    local foundItem=

    # loop looking for matching image in index
    local item=
    for item in "${allImages[@]}" ; do

      itemPackage="${item/":"*/}"
      itemName="${item/"$itemPackage:"/}"
      itemName="${itemName/":"*/}"
      itemVersion="${item/*":"/}"
      itemPath="$imagesDir/$itemPackage"

      # check version only if inherited image has specified
      if [[ -z "$fromVersion" ]] || [[ "$fromVersion" = "$itemVersion" ]] ; then
        # compare by image name
        [[ "$fromImage" = "$itemName" ]] && foundItem="$item" && break
      fi

    done



    # print info if image has been found
    if [[ -n "$foundItem" ]] ; then
      if [[ $printFormatted = true ]] ; then
        printf "%$((depth * 3))s" ""
        local lineToPrint=""

        [[ $printImageName = true ]] && lineToPrint+="${C_YELLOW}FROM${C_RESET} $itemPackage${C_YELLOW}:${C_WHITE}$imageName${C_RESET}"
        [[ $printVersion   = true ]] && lineToPrint+="${C_YELLOW}${lineToPrint:+":"}${C_BLUE}$imageVersion${C_RESET}"
        [[ $printPath      = true ]] && lineToPrint+="${C_YELLOW}${lineToPrint:+":"}${C_CYAN}{path:$imagePath}${C_RESET}"

        echo -e "$lineToPrint"
        pdImageListItemInheritance "$imagesDir" "$foundItem" $printFormatted $printPackage $printImageName $printVersion $printPath $printInheritanceInverted $((depth + 1)) "${allImages[@]}"
      else
        local lineToPrint=""

        [[ $printPackage   = true ]] && lineToPrint+="$itemPackage"
        [[ $printImageName = true ]] && lineToPrint+="${lineToPrint:+":"}$itemName"
        [[ $printVersion   = true ]] && lineToPrint+="${lineToPrint:+":"}$itemVersion"
        [[ $printPath      = true ]] && lineToPrint+="${lineToPrint:+":"}{path:$itemPath}"

        [[ $printInheritanceInverted = true  ]] && pdImageListItemInheritance "$imagesDir" "$foundItem" $printFormatted $printPackage $printImageName $printVersion $printPath $printInheritanceInverted "" "${allImages[@]}"
        echo "$lineToPrint"
        [[ $printInheritanceInverted = false ]] && pdImageListItemInheritance "$imagesDir" "$foundItem" $printFormatted $printPackage $printImageName $printVersion $printPath $printInheritanceInverted "" "${allImages[@]}"

      fi

    # or if there is no matching image in index print inheritance only for formatted version
    elif [[ $printFormatted = true ]] ; then
      printf "%$((depth * 3))s" ""
      echo "FROM :$fromWithVersion"
    fi

  fi

}