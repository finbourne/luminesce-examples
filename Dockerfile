# set base image (host OS)
FROM python:3.10

WORKDIR /usr/src/
COPY requirements.txt /usr/src/

RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT PYTHONPATH=/usr/src/ python runner/run.py
