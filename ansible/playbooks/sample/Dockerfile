FROM python:3.10.8-alpine3.16 AS base_dev
RUN pip install --no-cache-dir fastapi==0.87.0 uvicorn[standard]==0.19.0 requests==2.28.1

FROM base_dev AS base_test
RUN pip install --no-cache-dir pytest==7.2.0 httpx==0.23.0

FROM base_dev AS dev
WORKDIR /home
COPY app app
CMD ["python3", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]

FROM base_test AS test_unit
WORKDIR /home
COPY app app
COPY tests tests
CMD ["python3", "-m", "pytest"]

