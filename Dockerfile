# syntax=docker/dockerfile:1
FROM muslcc/x86_64:x86_64-linux-musl AS build
COPY ./ninjam /build
COPY ./ninjamsrv-static.patch /build
RUN apk add make patch
WORKDIR /build
RUN patch -p1 < ninjamsrv-static.patch
WORKDIR /build/ninjam/server
RUN make

FROM scratch
COPY --from=build /build/ninjam/server/ninjamsrv /app/ninjamsrv
CMD [ "/app/ninjamsrv", "/app/config/config.cfg" ]