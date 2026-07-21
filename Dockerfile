FROM python:3.10-slim

# Set the working directory
WORKDIR /app

# Copy dependency list first
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# COPY ALL APPLICATION FILES TO /app
COPY . /app/

# Run app.py
CMD ["python", "main.py"]