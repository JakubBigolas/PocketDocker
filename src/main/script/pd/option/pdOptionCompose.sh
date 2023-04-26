function pdOptionCompose {

  local option=

  while [[ $# -gt 0 ]]; do
    case $1 in
      list)
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

  # Default option is "List"
  [[ -z "$option" ]] && option=List

  eval pdImage$option "$@"

}