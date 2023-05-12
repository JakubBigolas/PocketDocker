function pdComposeHelp {

    echo -e ""
    echo -e "PocketDocker composes project management"
    echo -e ""
    echo -e "Usage: compose [options...] ["docker compose" args and options ...]"
    echo -e ""
    echo -e "Arguments:"
    pdToolHelpOptionPrint '--project'            'select PocketDocker compose project by name for "docker compose" command'
    pdToolHelpOptionPrint '--package'            'select PocketDocker compose package for "docker compose" command'
    echo -e ""
    echo -e "Options:"
    pdToolHelpOptionPrint 'list'            'List PocketDocker composes project'
    pdToolHelpOptionPrint '*'               'Any option or argument that is not listed in this help info'
    pdToolHelpOptionPrint ''                'will be redirected to "docker compose" command'
    pdToolHelpOptionPrint ''                'Working only if any other option listed in this help info'
    pdToolHelpOptionPrint ''                'has not been typed first'
    pdToolHelpOptionPrint '--help|help|-?'  'print this help info'
    echo -e ""


}