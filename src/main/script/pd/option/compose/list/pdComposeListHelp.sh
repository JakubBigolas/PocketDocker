function pdComposeListHelp {

    echo -e ""
    echo -e "List PocketDocker composes project"
    echo -e ""
    echo -e "Usage: list [args...]"
    echo -e ""
    echo -e "Arguments:"
    pdToolHelpOptionPrint '--help|help|-?'  'print this help info'
    pdToolHelpOptionPrint '-x'              'add package name to every record'
    pdToolHelpOptionPrint '-N'              'hide project name in every record'
    pdToolHelpOptionPrint '-p'              'add absolute path to every record'
    pdToolHelpOptionPrint '--project'       'select project by name'
    pdToolHelpOptionPrint '--package|*'     'select projects by package'
    echo -e ""

}