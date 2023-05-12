function pdImageBuild {

  local selection=()
  local paramSilent=false

  while [[ $# -gt 0 ]]; do
    case $1 in

      # print this help info and exit
      --help|"-?"|help) pdImageBuildHelp ; exit 0 ;;

      # set flags
      -s) paramSilent=true ; shift ;;

      # cache image and package selection
      --image|--package) selection+=("$1" "$2") ; shift ; shift ;;
      *)                 selection+=("$1")      ; shift         ;;

    esac
  done

  # read image names using image list query function
  local buildQueue=()
  readarray -t buildQueue < <(   pdImageList -v -I "${selection[@]}"   )

  # make queue distinct
  local list=("${buildQueue[@]}")
  local buildQueue=()
  local fromAll=
  for fromAll in "${list[@]}" ; do
    local exists=false
    local fromSet=
    for fromSet in "${buildQueue[@]}" ; do
      [[ "$fromSet" = "$fromAll" ]] && exists=true && break
    done
    [[ $exists = false ]] && buildQueue+=("$fromAll")
  done

  # print queue before build
  echo ""
  echo "Image build queue:"
  local image=
  for image in "${buildQueue[@]}" ; do    echo -e " - ${C_WHITE}$image${C_RESET}"    ; done
  for image in "${buildQueue[@]}" ; do    pdImageBuildItem $image $paramSilent       ; done

}