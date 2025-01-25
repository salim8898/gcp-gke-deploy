FROM --platform=linux/amd64 python:3.8-slim-buster as build

WORKDIR /app

# Argument to us during build stage
ARG DB_HOST
ARG DB_NAME
ARG DB_USER
ARG DB_PASSWORD

# ENV for variables, consumed in Py script
ENV DB_HOST=$DB_HOST
ENV DB_NAME=$DB_NAME
ENV DB_USER=$DB_USER
ENV DB_PASSWORD=$DB_PASSWORD

COPY /app/app.py /app

RUN apt-get update && apt-get install -y gcc libpq-dev && \
    pip install --no-cache-dir flask psycopg2

EXPOSE 8080

CMD ["python", "app.py"]
