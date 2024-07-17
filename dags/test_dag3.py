from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.python_operator import PythonOperator

# Define a function to print a message
def print_hello():
    print("Hello from Airflow!")

# Define the default arguments
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2023, 7, 1),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Define the DAG
dag = DAG(
    'print_hello_dag',
    default_args=default_args,
    description='A simple DAG to print a message',
    schedule_interval=timedelta(days=1),
)

# Define the task
print_hello_task = PythonOperator(
    task_id='print_hello_task',
    python_callable=print_hello,
    dag=dag,
)
