xhost +local:docker  # Allow GUI apps from Docker

docker run -it \
    --rm \
    --env DISPLAY=$DISPLAY \
    --env QT_X11_NO_MITSHM=1 \
    --volume "$(pwd)/.emacs.d/":/home/dev/.emacs.d/ \
    --volume /tmp/.X11-unix:/tmp/.X11-unix:rw \
    --name gui-container \
    emacs29
