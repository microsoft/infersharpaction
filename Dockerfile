FROM xinshi/csharpcodeanalyzer:3631763-gf87ef4c8921d6d75aa05deaaf55af7c6337cdaa6

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]