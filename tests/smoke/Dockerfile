FROM mcr.microsoft.com/powershell:7.4-ubuntu-22.04

WORKDIR /opt/statusproject

COPY scripts/ ./scripts/
COPY StatusProject/PROMPT.md StatusProject/INSTALL.md StatusProject/START-HERE.md \
    StatusProject/README.md StatusProject/CHANGELOG.md StatusProject/VERSIONING.md \
    StatusProject/LINKS.md StatusProject/VERSION ./StatusProject/
COPY StatusProject/templates/ ./StatusProject/templates/
COPY AGENTS.md CLAUDE.md AI-INSTRUCTION.md AI-SETTINGS-INSTRUCTION.md ./
COPY tests/smoke/ ./tests/smoke/

RUN chmod -R a-w /opt/statusproject \
    && chmod 0555 /opt/statusproject/tests/smoke/run-smoke.sh \
        /opt/statusproject/tests/smoke/smoke-bash.sh \
    && useradd --no-create-home --uid 10001 --shell /usr/sbin/nologin smoke

ENV HOME=/tmp
USER 10001:10001

ENTRYPOINT ["/opt/statusproject/tests/smoke/run-smoke.sh"]
