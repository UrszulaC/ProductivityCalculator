import unittest
import mysql.connector
from app import *

class TestProjectOperations(unittest.TestCase):

    def setUp(self):
        self.connection = mysql.connector.connect(
            host=HOST,
            user=USER,
            password=PASSWORD,
            database=DATABASE
        )
        # Creating a test table for projects
        self.create_test_table()

    def tearDown(self):
        # Clean up the test table after each test
        self.drop_test_table()
        self.connection.close()

    import unittest
import mysql.connector
from app import *

class TestProjectOperations(unittest.TestCase):

    def setUp(self):
        self.connection = mysql.connector.connect(
            host=HOST,
            user=USER,
            password=PASSWORD,
            database=DATABASE
        )
        # Creating a test table for projects
        self.create_test_table()

    def tearDown(self):
        # Clean up the test table after each test
        self.drop_test_table()
        self.connection.close()

    def create_test_table(self):
        cursor = self.connection.cursor()
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS projects_test (
                project_id INT PRIMARY KEY,
                project_name VARCHAR(255),
                project_owner VARCHAR(255),
                roi INT,
                stage VARCHAR(255),
                status VARCHAR(255)
            )
        """)
        cursor.close()

    def drop_test_table(self):
        cursor = self.connection.cursor()
        cursor.execute("DROP TABLE IF EXISTS projects_test")
        cursor.close()

    def test_create_table_projects(self):
        create_table_projects(self.connection)
        cursor = self.connection.cursor()
        cursor.execute("SHOW TABLES LIKE 'projects'")
        result = cursor.fetchone()
        self.assertIsNotNone(result)  # Ensuring 'projects' table exists

    def test_create_record(self):
        create_table_projects(self.connection)
        create_record(self.connection, 1, "New Trial Request", "Urszula", 100, "Gate 2", "Active")
        records = read_records(self.connection)
        self.assertEqual(len(records), 2)  # Ensuring record is created

    def test_update_record(self):
        create_table_projects(self.connection)
        create_record(self.connection, 1, "New Trial Request", "Urszula", 100, "Gate 2", "Active")
        update_record(self.connection, 1, "New Trial Request", "Urszula", 200, "In test", "On hold - awaiting for response")
        updated_record = read_records(self.connection)[0]
        self.assertEqual(updated_record, (1, "New Trial Request", "Urszula", 200, "In test", "On hold - awaiting for response"))

    def test_read_records(self):
        create_table_projects(self.connection)
        create_record(self.connection, 1, "New Trial Request", "Urszula", 200, "In test", "On hold - awaiting for response")
        create_record(self.connection, 2, "Another Project", "Another Owner", 200, "Gate 2", "Inactive")
        records = read_records(self.connection)
        self.assertEqual(len(records), 2)  # Ensuring correct number of records is retrieved



if __name__ == '__main__':
    unittest.main()
