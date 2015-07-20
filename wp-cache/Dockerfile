FROM alpine:3.2
MAINTAINER admin@tropicloud.net

ADD wps /wps
RUN /wps/wps.sh build

EXPOSE 6379 11211
ENTRYPOINT ["wps"]
CMD ["start"]
