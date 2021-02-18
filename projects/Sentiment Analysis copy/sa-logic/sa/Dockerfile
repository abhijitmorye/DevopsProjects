FROM python:3.6-slim
RUN mkdir -p /home/app
COPY . /home/app
WORKDIR /home/app
RUN pip install -r requirements.txt && python -m textblob.download_corpora
EXPOSE 5000
ENTRYPOINT ["python3"]
CMD ["sentiment_analysis.py"]