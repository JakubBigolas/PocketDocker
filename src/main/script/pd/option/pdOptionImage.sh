function pdOptionImage {

  # Default option is "Help"

  while [[ $# -gt 0 ]]; do
    case $1 in
      --help|"-?"|help)
        shift
        pdImageHelp
        break;
        ;;

      build)
        shift
        pdImageBuild "$@"
        break;
        ;;

      list)
        shift
        pdImageList "$@"
        break;
        ;;

      *)
        echo "Unknown option $1"
        exit 1
        ;;
    esac
  done

}