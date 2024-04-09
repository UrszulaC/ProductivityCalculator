import unittest
import mysql.connector
from config import *

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



if __name__ == '__main__':
    unittest.main()
