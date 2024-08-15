FROM python:3.9

WORKDIR /app

# Create a virtual environment
RUN python -m venv /venv

# Install dependencies
RUN /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install -r requirements.txt

# Install mysql-connector-python within the virtual environment
RUN /venv/bin/pip install mysql-connector-python

# Copy the rest of the application code
COPY . .

CMD ["/bin/bash"]