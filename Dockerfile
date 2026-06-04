FROM python:3.11-slim

WORKDIR /app

RUN useradd -m appuser

RUN apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=5s --start-period= --retries=3  CMD curl -f http://localhost:5000/ || exit 1

CMD ["python", "app.py"]