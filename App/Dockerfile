FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /app

COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

COPY . .
COPY test_django.py ./test_django.py
RUN python test_django.py

ENV DJANGO_SETTINGS_MODULE=App.settings

CMD ["gunicorn", "App.App.wsgi:application", "--bind", "0.0.0.0:8000"]

RUN echo "Listing /app contents:" && ls -la /app


#Test1