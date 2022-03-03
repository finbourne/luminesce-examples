# set base image (host OS)
FROM python:3.8

WORKDIR /tmp/working

RUN mkdir -p /tmp/working

COPY requirements.txt /tmp/working

RUN pip install -r /tmp/working/requirements.txt

COPY . /

CMD ["python", "/runner/run.py" ]



