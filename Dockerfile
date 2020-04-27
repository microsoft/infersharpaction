FROM xinshi/csharpcodeanalyzer:3679978-ga6caad564ac88f986c774eed4d826c80cc8f2704

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]