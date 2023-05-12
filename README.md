# PocketDocker (pdocker)

PocketDocker has been made to make docker images and envs development easier.
It allows to manage image projects and docker compose enviroments.

### Usage: 
```bash
pdocker [arguments...] [option]
```

### Arguments:
- `--help|help|-?`        - print help info and exit
- `version|--version|-v`  - print version info and exit
- `--totaltime`           - print total time at end
- `--docker-project-path` - print docker project path variable and exit

### Options:
- `image`            - PocketDocker images project management
- `compose`          - PocketDocker composes project management

### PocketDocker project example structure

- `/$PD_DOCKER_PROJECT_DIR`
  - `/composes`
    - `/package-path`
      - `/to`
        - `/compose-project`
          - `/env1`
            - `/docker-compose.yml`
            - `/project-name` (optional single line file with custom docker compose project name, 
              for example: "my-compose-project")
          - `/evn2`
            - `/docker-compose.yml`
          - `/env3`
  - `/images`
    - `/package-path`
      - `/to`
        - `/image-project`
          - `/Dockerfile`
          - `/version` (optional single line file with custom image version, for example: "1.2.3")
          - `/repository` (optional single line file with custom image name, for example: "my-image-name")
        - `/another-image-project`
          - `/Dockerfile`
        - `/yet-another-image-project`

This example structure profides information about:
- two docker composes:
  - docker compose in path `$PD_DOCKER_PROJECT_DIR/composes/package-path/to/compose-project/env1` with:
    - package `package-path/to/compose-project/env1`
    - project name `my-compose-project`
  - docker compoes in path `$PD_DOCKER_PROJECT_DIR/composes/package-path/to/compose-project/env2` with:
    - package `package-path/to/compose-project/env1`
    - project name `package-path-to-compose-project-env1`
- two docker image projects
  - docker image in path `$PD_DOCKER_PROJECT_DIR/images/package-path/to/image-project` with
    - package `package-path/to/image-project`
    - version `1.2.3`
    - image name (repository) `my-image-name`
  - docker image in path `$PD_DOCKER_PROJECT_DIR/images/package-path/to/another-image-project` with
    - package `package-path/to/another-image-project`
    - version `1.0`
    - image name (repository) `package-path-to-another-image-project`

# Sub options

## - pdocker image

PocketDocker images project management

### Usage: 
```bash
pdocker image [option]
```

### Options:
- `--help|help|-?`   - print this help info
- `list`             - print PocketDocker images info
- `build`            - build PocketDocker images projects

## - pdocker image list

Print PocketDocker images info

### Usage: 
```bash
pdocker image list [Arguments...]
```

### Arguments:
- `-f`               - print selected information in user friendly format
- `-i`               - print inheritance
- `-I`               - print inheritance inverted (working only for non formatted version)
- `-N`               - hide image names
- `-p`               - print images location path
- `-v`               - print version of docker image
- `-x`               - print packages
- `--image *`        - print information for specific image name
- `--package *|*`    - print information for specific package (and sub packages)
- `--help|help|-?`   - print this help info

## - pdocker image build

Build PocketDocker images projects

### Usage: 
```bash
pdocker image build [args...]
```

### Arguments:
- `-s`               - prevent of printing log file to standard output
- `--image *`        - build image specified by name
- `--package *|*`    - build all images for package (and sub packages)
- `--help|help|-?`   - print this help info

## - pdocker compose

PocketDocker composes project management

### Usage: 
```bash
pdocker compose [options...] [docker compose args and options ...]
```

### Arguments:
- `--project`        - select PocketDocker compose project by name for "docker compose" command
- `--package`        - select PocketDocker compose package for "docker compose" command

### Options:
- `list`             - List PocketDocker composes project
- `*`                - Any option or argument that is not listed in this help info
  will be redirected to "docker compose" command.
  Working only if any other option listed in this help info has not been typed first.
- `--help|help|-?`   - print this help info

## - pdocker compose list

List PocketDocker composes project

### Usage: 
```bash 
pdocker compose list [args...]
```

### Arguments:
- `--help|help|-?`   - print this help info
- `-x`               - add package name to every record
- `-N`               - hide project name in every record
- `-p`               - add absolute path to every record
- `--project`        - select project by name
- `--package|*`      - select projects by package