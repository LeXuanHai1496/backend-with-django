ARG PYTHON_VERSION=3.13
FROM python:${PYTHON_VERSION}-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential libpq-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . /app

RUN SECRET_KEY=build-only python3 manage.py collectstatic --no-input

EXPOSE 8000

CMD ["sh", "-c", "if [ \"$DEBUG\" = \"True\" ]; then exec python3 manage.py runserver 0.0.0.0:${PORT:-8000}; else python3 manage.py migrate --no-input && exec gunicorn config.wsgi:application --bind 0.0.0.0:${PORT:-8000}; fi"]
