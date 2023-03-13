FROM archlinux:base-devel

COPY entrypoint.sh /entrypoint.sh

RUN useradd builder && \
    passwd -d builder && \
    printf 'builder ALL=(ALL) ALL\n' | tee -a /etc/sudoers


USER builder:builder

VOLUME [ "/data" ]
WORKDIR /data

RUN chown -R builder:builder /data

CMD [ "sh", "/entrypoint.sh" ]