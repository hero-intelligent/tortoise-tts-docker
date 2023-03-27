ARG base=python:3.8






FROM ${base} as build

# install compiler
RUN apt update && apt install -y git build-essential libpq-dev
RUN python3 -m venv /venv
ENV PATH=/venv/bin:$PATH

# download source code of tortoise-tts
RUN git clone https://github.com/neonbjb/tortoise-tts.git

WORKDIR /tortoise-tts

#install and build dependencies
RUN sed  -i 's/scipy==0.10.1/scipy==1.10.1/g' requirements.txt && \
pip install -r requirements.txt

#install and build tortoise-tts
RUN python setup.py install

#install GUI
RUN pip install gradio==3.20.1 && pip install numpy==1.20.3
WORKDIR /workspace






# This image only contains the software itself.
# This image doesn't contain models.
# This image is recomended.
FROM ${base} as basic

# install basic binaries that support program running
# RUN \
# apt-get update && \
# DEBIAN_FRONTEND=noninteractive \
#     apt-get install --no-install-recommends --assume-yes \
#         libpq5 && \
# apt-get clean && \
# rm -rf /var/lib/apt/lists/*

# install compiled tortoise-tts as well as dependencies
COPY --from=build /venv /venv
ENV PATH=/venv/bin:$PATH

# install GUI launcher
WORKDIR /app
COPY ./app.py ./app.py

VOLUME [ "/app", "/root/.cache" ]

EXPOSE 7860

CMD [ "python", "app.py" ]







# Not Recomended. If sustainablize of models needed,
# Mount the VOLUMEs to somewhere else in your local directory instead.
FROM basic

#download models
RUN python -c "from tortoise.api import TextToSpeech as tts; tts()"

VOLUME [ "/app", "/root/.cache" ]

EXPOSE 7860

CMD [ "python", "app.py" ]
