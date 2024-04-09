import mysql.connector
from config import *

def create_table_projects(connection):
    try:
        cursor = connection.cursor()
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS projects (
                project_id INT PRIMARY KEY,
                project_name VARCHAR(255),
                project_owner VARCHAR(255),
                roi INT,
                stage VARCHAR(255),
                status VARCHAR(255)
            )
        """)
        print("Table 'projects' created successfully")
    except mysql.connector.Error as e:
        print(f"Error creating table: {e}")