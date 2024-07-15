FROM apache/airflow:2.7.1

RUN pip install --upgrade pip 

COPY requirements.txt /requirements.txt 

RUN pip install --no-cache-dir --user -r /requirements.txt 

