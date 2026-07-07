FROM ghcr.io/leanprover/lean4:nightly-2024-12-31 AS builder
WORKDIR /app
COPY
ENV LEAN_MAX_MEMORY=4096
RUN lake update && lake build

FROM python:3.11-slim
WORKDIR /app
COPY --from=builder /app /app
RUN pip install fastapi "uvicorn[standard]"
EXPOSE 8080
CMD ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8080"]
