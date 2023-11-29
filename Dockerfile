# set base image (host OS)
FROM python:3.10

WORKDIR /usr/src/
COPY requirements.txt /usr/src/
COPY . .

RUN pip install --no-cache-dir -r requirements.txt
RUN pip install dve-lumipy-preview==0.1.625 --no-deps

ENV PYTHONPATH "${PYTHONPATH}:/usr/src"

ENTRYPOINT [ "python", "runner/run.py" ]
