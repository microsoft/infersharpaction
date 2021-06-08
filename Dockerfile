FROM mcr.microsoft.com/infersharp:v1.1

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
