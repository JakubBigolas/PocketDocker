function pdOptionCompose {

  # Default option is "Help"

  while [[ $# -gt 0 ]]; do
    case $1 in

      --help|"-?"|help)
        shift
        pdComposeHelp
        break;
        ;;

      list)
        shift
        pdComposeList "$@"
        break;
        ;;

      *)
        pdCompose "$@"
        exit 0
        ;;

    esac
  done

}