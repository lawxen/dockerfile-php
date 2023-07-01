FROM lawxen/drupal:d10-php82

###########################################################################
# FFMPEG:
###########################################################################

USER root

ARG INSTALL_FFMPEG=true

RUN if [ ${INSTALL_FFMPEG} = true ]; then \
    apt-get -y install ffmpeg \
;fi
