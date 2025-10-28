# Use Python 3.11 slim image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8080

# Copy requirements first for better caching
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY app.py .
COPY converted_file.csv .
COPY templates/ ./templates/

# Create a non-root user for Cloud Run security
RUN useradd -m -u 1000 appuser && \
    chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose port 8080 (GCP Cloud Run requirement)
EXPOSE 8080

# Run with gunicorn on port 8080
CMD exec gunicorn --bind :$PORT --workers 4 --threads 2 --timeout 120 app:app