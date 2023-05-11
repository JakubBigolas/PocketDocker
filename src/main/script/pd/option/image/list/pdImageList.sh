function pdImageList {

  local printVersion=false
  local printFormatted=false
  local printPath=false
  local printPackage=false
  local printImageName=true
  local printInheritance=false
  local printInheritanceInverted=false

  # images directory from config.sh
  local imagesDir="$PD_DOCKER_PROJECT_DIR/images"

  # find all images dockerfiles
  local dockerfiles=()
  readarray -t dockerfiles < <(find "$imagesDir" -regex .*/Dockerfile$)

  # dockerfiles paths to packages
  local packages=("${dockerfiles[@]}")
  packages=("${packages[@]//"$imagesDir/"/}")
  packages=("${packages[@]//"/Dockerfile"/}")
  packages=("${packages[@]//"\\"/"/"}")

  # add images name and version info to every package
  local allImages=()
  local package=
  for package in "${packages[@]}" ; do
    # by default image name is package with - sign instead of / and \
    local imageName="$package"
    imageName="${imageName//"/"/-}"
    imageName="${imageName//"\\"/-}"

    # try retrieve specified image name from file
    local repository="$imagesDir/$package/repository"
    if [[ -f "$repository" ]] ; then
      local repositoryName=
      repositoryName="$(head -n 1 "$repository")"
      [[ -n "$repositoryName" ]] && imageName="$repositoryName"
    fi

    # try load version from file
    local version="$imagesDir/$package/version"
    local versionNumber=
    [[ -f "$version" ]] && versionNumber="$(head -n 1 "$version")"

    # concatenate all info in one line and add to all images array
    allImages+=("$package:$imageName:$versionNumber")
  done



  local selectedImages=()
  local selectedPackages=()

  while [[ $# -gt 0 ]]; do
    case $1 in

      # flags
      -f) printFormatted=true           ; shift ;;
      -x) printPackage=true             ; shift ;;
      -N) printImageName=false          ; shift ;;
      -v) printVersion=true             ; shift ;;
      -p) printPath=true                ; shift ;;
      -i) printInheritance=true         ; shift ;;
      -I) printInheritanceInverted=true ; shift ;;

      # print help info
      --help|"-?"|help)
        shift
        eval pdImageListHelp "$@"
        exit 0
        ;;

      # pick image by name
      --image)    selectedImages+=("$2")   ; shift ; shift ;;

      # pick all images from package
      --package)  selectedPackages+=("$2") ; shift ; shift ;;

      # pick all images from package
      *)          selectedPackages+=("$1") ; shift ;;

    esac
  done



  local filteredImages=()

  # get all images if there are no filter
  if [[ ${#selectedPackages[@]} = 0 ]] && [[ ${#selectedImages[@]} = 0 ]] ; then
    filteredImages=("${allImages[@]}")

  # or filter them by package or image name
  else
    local image=
    for image in "${allImages[@]}" ; do
      local imagePackage="${image/":"*/}"
      local imageName="${image/"$imagePackage:"/}"
      imageName="${imageName/":"*/}"

      local selected=false

      # packages filter
      local selectedPackage=
      for selectedPackage in "${selectedPackages[@]}" ; do
        [[ "$imagePackage/" =~ ^$selectedPackage//* ]] && selected=true && continue
      done
      [[ $selected = true ]] && filteredImages+=("$image") && continue

      # image names filter
      local selectedImage=
      for selectedImage in "${selectedImages[@]}" ; do
        [[ "$imageName" = "$selectedImage" ]] && selected=true && continue
      done
      [[ $selected = true ]] && filteredImages+=("$image") && continue

    done
  fi

  # for each filtered position
  local prevItem=
  local item=
  for item in "${filteredImages[@]}" ; do
    pdImageListItem "$imagesDir" "$item" $printFormatted $printPackage $printImageName $printVersion $printPath $printInheritance $printInheritanceInverted "${prevItem/":"*/}" "${allImages[@]}"
    prevItem="$item"
  done

}