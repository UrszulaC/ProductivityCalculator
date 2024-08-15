FROM python:3.9

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Create and activate virtual environment
RUN python -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Install mysql-connector-python within the virtual environment
RUN /venv/bin/pip install mysql-connector-python

# Copy the rest of the application code
COPY . .

CMD ["/bin/bash"]