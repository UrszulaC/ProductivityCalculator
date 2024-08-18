FROM python:3.9

# Set working directory
WORKDIR /app

# Copy the requirements file and install dependencies
COPY requirements.txt .

# Create a virtual environment and install dependencies
RUN python -m venv /venv && \
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install -r requirements.txt

# Copy the rest of the application code
COPY . .

# Activate virtual environment and set it as the default Python environment
ENV PATH="/venv/bin:$PATH"

# Default command
CMD ["python", "app.py"]  