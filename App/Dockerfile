# Dockerfile
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /App

COPY requirements.txt/App/ .
RUN pip install --upgrade pip && pip install -r requirements.txt

COPY . /App/

CMD ["gunicorn", "App.wsgi:application", "--bind", "0.0.0.0:8000"]

