FROM mcr.microsoft.com/infersharp:v1.3

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
