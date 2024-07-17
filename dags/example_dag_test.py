from datetime import datetime
from airflow import DAG
from airflow.operators.dummy import DummyOperator
from airflow.operators.python import PythonOperator

def print_hello():
    print("Hello, Airflow!here")

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2023, 1, 1),
    'retries': 1,
}

with DAG(
    'example_dag',
    default_args=default_args,
    description='A simple example DAG',
    schedule_interval='@daily',
    catchup=False,
) as dag:

    start = DummyOperator(
        task_id='start'
    )

    hello_task = PythonOperator(
        task_id='hello_task',
        python_callable=print_hello
    )

    end = DummyOperator(
        task_id='end'
    )

    start >> hello_task >> end
