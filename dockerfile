# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Create and activate a virtual environment
RUN python -m venv venv
RUN . venv/bin/activate

# Ensure the virtual environment is used
ENV PATH="/app/venv/bin:$PATH"

# Run tests when the container launches
CMD ["python", "-m", "unittest", "discover", "-s", "tests", "-p", "test.py"]