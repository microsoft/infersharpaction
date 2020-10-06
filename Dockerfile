FROM mcr.microsoft.com/infersharp:v0.1

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
