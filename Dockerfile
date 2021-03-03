FROM mcr.microsoft.com/infersharp:v1.0

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
