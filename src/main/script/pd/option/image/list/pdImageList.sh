function pdImageList {

  # flag set
  local printVersion=false
  local printFormatted=false
  local printPath=false
  local printPackage=false
  local printImageName=true
  local printInheritance=false
  local printInheritanceInverted=false

  # images directory from config.sh
  local imagesDir="$PD_DOCKER_PROJECT_DIR/images"

  # --- LOAD IMAGES INDEX

  # find all images dockerfiles
  local dockerfiles=()
  readarray -t dockerfiles < <(find "$imagesDir" -regex .*/Dockerfile$)

  # convert dockerfiles paths to packages
  local packages=("${dockerfiles[@]}")
  packages=("${packages[@]//"$imagesDir/"/}")
  packages=("${packages[@]//"/Dockerfile"/}")
  packages=("${packages[@]//"\\"/"/"}")

  # add images names and version info to every package
  local allImages=()
  local package=
  for package in "${packages[@]}" ; do

    # by default image name is package with "-" sign instead of / and \
    local imageName="$package"
    imageName="${imageName//"/"/-}"
    imageName="${imageName//"\\"/-}"

    # try retrieve specified image name from file /repository
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

  # --- HANDLE USER ARGUMENTS

  local selectedImages=()     # user selected fully-qualified image names
  local selectedPackages=()   # user selected packages / sub-packages

  while [[ $# -gt 0 ]]; do
    case $1 in

      # print help info
      --help|"-?"|help) pdImageListHelp ; exit 0 ;;

      # flags
      -f) printFormatted=true           ; shift ;;
      -x) printPackage=true             ; shift ;;
      -N) printImageName=false          ; shift ;;
      -v) printVersion=true             ; shift ;;
      -p) printPath=true                ; shift ;;
      -i) printInheritance=true         ; shift ;;
      -I) printInheritanceInverted=true ; shift ;;

      # pick image by name
      --image)    selectedImages+=("$2")   ; shift ; shift ;;

      # pick all images from package
      --package)  selectedPackages+=("$2") ; shift ; shift ;;
      *)          selectedPackages+=("$1") ; shift ;;

    esac
  done

  # --- APPLY USER PACKAGE/IMAGE FILTERS

  local filteredImages=()

  # select all images if there are no filter
  if [[ ${#selectedPackages[@]} = 0 ]] && [[ ${#selectedImages[@]} = 0 ]] ; then
    filteredImages=("${allImages[@]}")

  # or filter them by package or image name
  else

    local image=
    for image in "${allImages[@]}" ; do

      # unwrap image package and name information
      local imagePackage="${image/":"*/}"
      local imageName="${image/"$imagePackage:"/}"
      imageName="${imageName/":"*/}"

      # not selected by default
      local selected=false

      # packages filter, add image if it`s package starts with any user selected package
      local selectedPackage=
      for selectedPackage in "${selectedPackages[@]}" ; do
        [[ "$imagePackage/" =~ ^$selectedPackage//* ]] && selected=true && continue
      done
      [[ $selected = true ]] && filteredImages+=("$image") && continue

      # image names filter, add image if its whole name equals with any user selected image
      local selectedImage=
      for selectedImage in "${selectedImages[@]}" ; do
        [[ "$imageName" = "$selectedImage" ]] && selected=true && continue
      done
      [[ $selected = true ]] && filteredImages+=("$image") && continue

    done

  fi

  # --- PRINT EACH FILTERED IMAGE

  local prevItem=
  local item=
  for item in "${filteredImages[@]}" ; do
    pdImageListItem "$imagesDir" "$item" $printFormatted $printPackage $printImageName $printVersion $printPath $printInheritance $printInheritanceInverted "${prevItem/":"*/}" "${allImages[@]}"
    prevItem="$item"
  done

}