FROM python:3.11-slim

WORKDIR /app

RUN useradd -m appuser

COPY requirements.txt .
RUN pip install -r requirements.txt 

COPY app.py .

USER appuser

ENV PORT=5000

EXPOSE 5000

CMD ["python", "app.py"]