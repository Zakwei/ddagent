FROM docker/sandbox-templates:claude-code

USER root
COPY shared/install-ddagent.sh /tmp/install-ddagent.sh
RUN chmod +x /tmp/install-ddagent.sh && /tmp/install-ddagent.sh

USER agent
RUN --mount=type=cache,target=/tmp/npm-cache,sharing=locked,mode=0777 \
    npm install -g @ddagent-ai/ddagent \
      --cache=/tmp/npm-cache \
      --fetch-retries=5 \
      --fetch-retry-mintimeout=20000 \
      --fetch-retry-maxtimeout=120000 \
      --fetch-timeout=600000 \
      --no-audit \
      --no-fund && \
    ddagent --version

COPY --chown=agent:agent shared/start-ddagent.sh /home/agent/.ddagent-start.sh
RUN echo '. ~/.ddagent-start.sh' >> /home/agent/.bashrc
