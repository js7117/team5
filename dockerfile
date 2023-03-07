FROM python:3.10-alpine

WORKDIR /app

COPY . .

RUN pip install -r requirement.txt

EXPOSE 5000

CMD ["python", "-m", "flask", "run", "--host=0.0.0.0"]