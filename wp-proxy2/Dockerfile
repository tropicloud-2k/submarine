FROM alpine:3.2
MAINTAINER admin@tropicloud.net

ADD wps /wps
RUN /wps/wps.sh build

EXPOSE 80 443 8080
ENTRYPOINT /bin/bash
CMD wps start
