FROM python:3.11

LABEL maintainer="infrastructure"

WORKDIR /app

COPY . /app

RUN apt update -y && apt upgrade -y \
    && apt-get clean \
    && pip install --no-cache-dir -r requirements.txt

EXPOSE 8080

ENV FLASK_APP=app.py

CMD ["python", "app.py"]
