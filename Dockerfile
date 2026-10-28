FROM python:3.11-slim

WORKDIR /app

RUN useradd -m appuser

RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r requirements.txt

COPY app.py .

# Run the app as the unprivileged user created above, not as root
USER appuser

EXPOSE 5000

# python:3.11-slim does not include curl, so the check uses Python's standard library
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/', timeout=3)" || exit 1

CMD ["python", "app.py"]
