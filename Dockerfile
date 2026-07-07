cat > Dockerfile << 'EOF'
FROM ghcr.io/leanprover/lean4:v4.12.0 as builder
WORKDIR /app
COPY..
RUN lake update && lake build

FROM python:3.11-slim
WORKDIR /app
COPY --from=builder /app.
RUN pip install fastapi "uvicorn[standard]"
EXPOSE 8080
CMD ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8080"]
EOF

git add AUDIT.json api.py Dockerfile
git commit -m "Add Railway API: BSD class-number-143 bundle"
git push
