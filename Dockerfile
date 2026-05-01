FROM python:3.11-slim

WORKDIR /app

RUN pip install poetry==1.8.3

ENV POETRY_VIRTUALENVS_CREATE=false

COPY pyproject.toml poetry.lock ./

RUN poetry config virtualenvs.create false \
    && poetry install --without dev --no-root

COPY . .

RUN python manage.py collectstatic --noinput

EXPOSE 8000

CMD ["gunicorn", "mysite.wsgi:application", "--bind", "0.0.0.0:8000"]