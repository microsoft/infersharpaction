FROM xinshi/csharpcodeanalyzer:3721994-g1f43701f1f1b62a54e21600c4b3bf788082d64c2

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]