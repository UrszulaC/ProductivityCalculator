# Use an appropriate Python base image
FROM python:3.9

# Set the working directory
WORKDIR /app

# Install bash if it's not included by default
RUN apt-get update && apt-get install -y bash

# Copy requirements file and install dependencies
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install -r requirements.txt

# Copy the rest of the application code
COPY . .

# Create a virtual environment
RUN python -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Default command to run when starting the container
CMD [ "/bin/bash" ]
