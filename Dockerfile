
# FROM python:3.11.9


# WORKDIR /code


# COPY ./requirements.txt /code/requirements.txt


# RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt


# COPY ./app /code/app


# CMD ["fastapi", "run", "app/main.py", "--port", "80"]
# Builder stage

FROM python:3.11.9-alpine AS builder

WORKDIR /install

# Install build deps only here
RUN apk add --no-cache build-base

COPY requirements.txt .

RUN pip install --prefix=/install -r requirements.txt

# Final stage
FROM python:3.11.9-alpine

WORKDIR /code

# Avoid .pyc files & unbuffered logs
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

COPY --from=builder /install /usr/local
COPY ./app /code/app

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]

