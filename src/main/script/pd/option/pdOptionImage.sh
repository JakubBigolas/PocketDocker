function pdOptionImage {

  # Default option is "Help"
  local option=Help

  while [[ $# -gt 0 ]]; do
    case $1 in
      --help|"-?")
        option=Help
        shift
        ;;
      build|list)
        option=$(pdToolUpperCaseFirstLetter "$1")
        shift
        break;
        ;;
      *)
        echo "Unknown option $1"
        exit 1
        ;;
    esac
  done

  eval pdImage$option "$@"

}