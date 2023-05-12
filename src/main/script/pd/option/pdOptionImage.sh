function pdOptionImage {

  while [[ $# -gt 0 ]]; do
    case $1 in

      # print this help info and exit
      --help|"-?"|help) shift ; pdImageHelp ; exit 0 ;;

      # sub option select and break args loop
      build) shift ; pdImageBuild "$@" ; break ;;
      list)  shift ; pdImageList "$@"  ; break ;;

      # Error unknown
      *)     echo "Unknown option $1"  ; exit 1 ;;

    esac
  done

}