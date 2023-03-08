# set base image (host OS)
FROM python:3.10

WORKDIR /usr/src/
COPY requirements.txt /usr/src/
COPY . .

RUN pip install --no-cache-dir -r requirements.txt

ENV PYTHONPATH "${PYTHONPATH}:/usr/src"

ENTRYPOINT [ "python", "runner/run.py" ]
