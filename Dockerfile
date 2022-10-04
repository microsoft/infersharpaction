FROM mcr.microsoft.com/infersharp:v1.4

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
