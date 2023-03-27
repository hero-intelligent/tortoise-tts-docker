FROM pytorch/pytorch:1.12.0-cuda11.3-cudnn8-runtime

RUN apt update && apt install -y git
RUN git clone https://github.com/neonbjb/tortoise-tts.git

WORKDIR /workspace/tortoise-tts
RUN sed  -i 's/scipy==0.10.1/scipy==1.2.0/g' requirements.txt && \
pip install -r requirements.txt
RUN python setup.py install
RUN pip install gradio==3.20.1

#download models
RUN python -c "from tortoise.api import TextToSpeech as tts; tts()"

WORKDIR /workspace
COPY ./app.py ./app.py

EXPOSE 7860

CMD [ "python", "app.py" ]

