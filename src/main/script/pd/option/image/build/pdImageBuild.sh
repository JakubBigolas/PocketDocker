function pdImageBuild {

  local selection=()
  local paramSilent=false

  while [[ $# -gt 0 ]]; do
    case $1 in

      --help|"-?"|help)
        shift
        [[ ! -z "$*" ]] && echo -e "${C_RED}Unhandled arguments: $*" && exit 1
        echo -e ""
        echo -e "Usage: list [parameters] [project list]"
        echo -e ""
        echo -e "Run docker image build process for selected images."
        echo -e ""
        echo -e "Arguments:"
        pdToolHelpOptionPrint '-s'              'prevent of printing log file to standard output'
        pdToolHelpOptionPrint '--image *'       'build image specified by name'
        pdToolHelpOptionPrint '--package *|*'   'build all images for package (and sub packages)'
        pdToolHelpOptionPrint '--help|help|-?'  'print this help info'
        echo -e ""
        exit 0
        ;;

      -s)
        paramSilent=true
        shift
        ;;

      # pick image by name
      --image|--package) selection+=("$1" "$2") ; shift ; shift ;;

      # pick all images from package
      *)                 selection+=("$1")      ; shift         ;;

    esac
  done

  # read image names using image list query
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