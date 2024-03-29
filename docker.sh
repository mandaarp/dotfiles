## Docker container helpers
dcstop() {
    # stop the container
    docker container stop $1
}
dcstart() {
    # start the container
    docker container start $1
}
dcrestart() {
    # restart the container
    docker container restart $1
}
dcbash() {
    # interactive mode for container with bash
    docker container exec -it $1 /bin/bash
}
dcrbash() {
    # interactive mode for container with root and bash
    docker container exec --user=root -it $1 /bin/bash
}
dcsh() {
    # interactive mode for containers with sh
    docker container exec -it $1 /bin/sh
}
dcrm() {
    # remove container
    docker container rm $1
}
dcinspect() {
    # inspect a container
    docker container inspect $2 $1
}
dclogs() {
    # get logs
    docker container logs $2 $1
}
dclogsf() {
    # Follow logs
    docker container logs -f $1
}
dcrun() {
    docker container run --rm $1
}
dcupgrade() {
    if [ $# == 2 ]; then
        # stop container
        echo "Stopping the container $1 ..."
        dcstop $1
        # get name of the image
        echo "Inspecting the image for container $1 ..."
        image=$(dcinspect $1 --format='{{.Config.Image}}')
        # pull latest tag
        echo "Pulling the latest tag for $image"
        docker image pull $image
        # remove previous container
        echo "Removing the container $1 to create a new one"
        dcrm $1
        echo "Creating a new container by running $2 in $(pwd)"
        # Create a new container
        bash $2
        # Starting a new container
        echo "Starting the container $1 ..."
        docker container start $1
    else
        echo "USAGE: $0 <container_name> <create.sh for new container>; Must call this function in same directory as create.sh"
        echo "create.sh: usually includes script to create a new container e.g. docker create --name nginx -p 80:80 -v ${PWD}/nginx.conf:/etc/nginx/nginx.conf:ro nginx"
    fi
}
dclupgrade() {
    # upgrade container with local image
    if [ $# == 2 ]; then
        # stop container
        echo "Stopping the container $1 ..."
        dcstop $1
        # get name of the image
        echo "Inspecting the image for container $1 ..."
        image=$(dcinspect $1 --format='{{.Config.Image}}')
        # remove previous container
        echo "Removing the container $1 to create a new one"
        dcrm $1
        echo "Creating a new container by running $2 in $(pwd)"
        # Create a new container
        bash $2
        # Starting a new container
        echo "Starting the container $1 ..."
        docker container start $1
    else
        echo "USAGE: $0 <container_name> <create.sh for new container>; Must call this function in same directory as create.sh"
        echo "create.sh: usually includes script to create a new container e.g. docker create --name nginx -p 80:80 -v ${PWD}/nginx.conf:/etc/nginx/nginx.conf:ro nginx"
    fi
}
table_format="table {{.Names}}\t{{.Image}}\t{{.CreatedAt}}\t{{.Status}}\t{{.Ports}}"
alias dcprune='docker container prune'
alias dcls='docker container ls --format "${table_format}"'
alias dclsall='docker container ls --all --format "${table_format}"'
alias dclse='docker container ls --all --format "${table_format}" | grep Exited'
alias dclsc='docker container ls --all --format "${table_format}" | grep Created'

## Docker image helpers
alias dils='docker image ls'
alias dilsall='docker image ls --all'
dipull() {
    if [ $# == 1 ]; then
        # pull the image
        docker image pull $1
    else
        echo "USAGE: dipull <image_path_to_pull>"
    fi
}
dibuild() {
    if [ $# == 1 ]; then
        docker build --tag $1 .
    else
        echo "USAGE: dibuild <tagname>"
    fi
}
dipush() {
    if [ $# == 2 ]; then
        docker tag $2 $1:5100/$2
        docker push $1:5100/$2
    else
        echo "USAGE: dipush <tagname>"
    fi
}
