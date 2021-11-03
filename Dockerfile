FROM mcr.microsoft.com/infersharp:v1.2

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
