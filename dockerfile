FROM python:3.9

# Set working directory
WORKDIR /app

# Copy the requirements file and install dependencies
COPY requirements.txt .
RUN python -m venv /venv && /venv/bin/pip install --upgrade pip && /venv/bin/pip install -r requirements.txt

# Create a virtual environment and install dependencies
RUN python -m venv /venv && \
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install -r requirements.txt

# Copy the rest of the application code
COPY . .

# Activate virtual environment and set it as the default Python environment
ENV PATH="/venv/bin:$PATH"
COPY wait-for-it.sh /wait-for-it.sh
RUN chmod +x /wait-for-it.sh

# Default command
   
CMD ["./wait-for-it.sh", "mysql", "--", "python", "app.py"]