# Container Smoke Tests

Run from the repository root:

```sh
docker build --file tests/smoke/Dockerfile --tag statusproject-smoke:local .
docker run --rm --read-only --tmpfs /tmp:rw,exec,nosuid,size=128m \
  --network none --cap-drop ALL --security-opt no-new-privileges \
  statusproject-smoke:local
```

The image runs as a non-root user and tests Bash and PowerShell Core against
disposable targets under `/tmp`. It does not certify native Windows batch
execution or native macOS behavior.
