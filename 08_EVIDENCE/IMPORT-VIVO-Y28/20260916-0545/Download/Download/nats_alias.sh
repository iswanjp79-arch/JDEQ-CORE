# MICO-JDEQ NATS secure aliases
if [ -f "$HOME/.nats_creds" ]; then
  . "$HOME/.nats_creds"
fi

alias mico-publish='$HOME/.local/bin/nats --server nats://100.67.36.31:4222 --user "$NATS_USER" --password "$NATS_PASSWORD" pub'
alias mico-subscribe='$HOME/.local/bin/nats --server nats://100.67.36.31:4222 --user "$NATS_USER" --password "$NATS_PASSWORD" sub'
