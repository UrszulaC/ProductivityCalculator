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

def delete_record(connection, project_id):
    try:
        cursor = connection.cursor()
        sql = "DELETE FROM projects WHERE project_id=%s"
        cursor.execute(sql, (project_id,))
        connection.commit()
        cursor.close()
        print("Record deleted successfully")
    except mysql.connector.Error as e:
        print(f"Error deleting record: {e}")

def display_menu():
    print("Menu:")
    print("1. Create Record")
    print("2. Read Records")
    print("3. Update Record")
    print("4. Delete Record")
    print("5. Exit")

def main():
    try:
        connection = mysql.connector.connect(
            host=HOST,
            user=USER,
            password=PASSWORD,
            database=DATABASE
        )
    except mysql.connector.Error as e:
        print(f"Error connecting to database: {e}")
        exit()

    create_table_projects(connection)  # Create the 'projects' table if it doesn't exist

    while True:
        display_menu()
        choice = input("Enter your choice: ")

        if choice == '1':
            project_id = int(input("Enter Project ID: "))
            project_name = input("Enter Project Name: ")
            project_owner = input("Enter Project Owner: ")
            roi = int(input("Enter ROI: "))
            stage = input("Enter Stage: ")
            status = input("Enter Status: ")
            create_record(connection, project_id, project_name, project_owner, roi, stage, status)
        elif choice == '2': 
            records = read_records(connection) 
            for record in records:
                print(record)      
        elif choice == '3':
            project_id = int(input("Enter Project ID to update: "))
            project_name = input("Enter Updated Project Name: ")
            project_owner = input("Enter Updated Project Owner: ")
            roi = int(input("Enter Updated ROI: "))
            stage = input("Enter Updated Stage: ")
            status = input("Enter Updated Status: ")
            update_record(connection, project_id, project_name, project_owner, roi, stage, status)
        elif choice == '4':
            project_id = int(input("Enter Project ID to delete: "))
            delete_record(connection, project_id)
        elif choice == '5':
            break
        else:
            print("Invalid choice. Please try again.")

    connection.close()

if __name__ == "__main__":
    main()



