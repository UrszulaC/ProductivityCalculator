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

def create_record(connection, project_id, project_name, project_owner, roi, stage, status):
    try:
        cursor = connection.cursor()
        sql = "INSERT INTO projects (project_id, project_name, project_owner, roi, stage, status) VALUES (%s, %s, %s, %s, %s, %s)"
        values = (project_id, project_name, project_owner, roi, stage, status)
        cursor.execute(sql, values)
        connection.commit()
        cursor.close()
        print("Record created successfully")
    except mysql.connector.Error as e:
        print(f"Error creating record: {e}")

def update_record(connection, project_id, project_name, project_owner, roi, stage, status):
    try:
        cursor = connection.cursor()
        sql = "UPDATE projects SET project_name=%s, project_owner=%s, roi=%s, stage=%s, status=%s WHERE project_id=%s"
        values = (project_name, project_owner, roi, stage, status, project_id)
        cursor.execute(sql, values)
        connection.commit()
        cursor.close()
        print("Record updated successfully")
    except mysql.connector.Error as e:
        print(f"Error updating record: {e}")

def read_records(connection):
    try:
        cursor = connection.cursor()
        cursor.execute("SELECT * FROM projects")
        records = cursor.fetchall()
        cursor.close()
        return records
    except mysql.connector.Error as e:
        print(f"Error reading records: {e}")
        return []  # Return an empty list if an error occurs or no records are found



