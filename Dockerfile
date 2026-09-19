# (1) Use an official Python runtime as the base image
FROM python:3.9-slim

# (2) Set the working directory in the container
WORKDIR /app

# (3) Upgrade pip
RUN pip install --upgrade pip

# (4) Install required system packages for mysqlclient
RUN apt-get update \
    && apt-get install -y  gcc  default-libmysqlclient-dev  pkg-config  curl \
    && rm -rf /var/lib/apt/lists/*

# (5) Copy the requirements file
COPY requirements.txt .

# (6) Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# (7) Copy the application code
COPY . .

# (8) Application listen at port
EXPOSE 5000

# (9) Start the Flask application
CMD ["python", "app.py"]
