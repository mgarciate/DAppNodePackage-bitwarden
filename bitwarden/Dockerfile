ARG UPSTREAM_VERSION
FROM vaultwarden/server:${UPSTREAM_VERSION}

ADD backup.sh /usr/bin/backup.sh
ADD import.sh /usr/bin/import.sh
ADD entrypoint.sh /usr/local/bin/entrypoint.sh

WORKDIR /

# # Install jq
# # Install unzip
# # Install wget
# # Install node
# # Install cron
RUN apt update && apt install -y jq unzip wget nodejs cron

# # Download /bw
RUN wget https://github.com/bitwarden/clients/releases/download/cli-v2023.1.0/bw-linux-2023.1.0.zip
RUN unzip bw-linux-2023.1.0.zip
RUN rm bw-linux-2023.1.0.zip
RUN chmod u+x /bw

# Apply cron job
COPY backup-cron /etc/cron.d/
RUN crontab /etc/cron.d/backup-cron

# Start command
CMD [ "/usr/local/bin/entrypoint.sh" ]