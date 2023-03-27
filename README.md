# Tortoise TTS Docker with GUI

Tortoise is a text-to-speech program built with the following priorities:

    Strong multi-voice capabilities.
    Highly realistic prosody and intonation.

The GUI is pulled and adjusted from: [This Huggingface Repository](https://huggingface.co/spaces/mdnestor/tortoise) powered by [Gradio](https://gradio.app/).

Source codes: [Tortoise-tts Huggingface Repo](https://huggingface.co/jbetker/tortoise-tts-v2) | [Github Repo](https://github.com/neonbjb/tortoise-tts)



## Help needed

I apologize that I have no computer with GPU yet, but things should work. It will be highly appreciated if you could help me to test it out whether it works, especially whether it works with GPU accleration. Let me know whether everything goes just fine or anything goes wrong. 




## Preparation

This application requires powerful GPU, although it CAN run on CPU only. 

To run this docker container, **Linux** *baremetal localhost* is recomended. This totorial is based on Debian series like Debian, Ubuntu, Mint, Pop_OS, etc. You can certainly choose to run whether baremetal or on a virtual machine, whether localhost or remotely under the same LAN, or even on a remote cloud computer, but there might be some issues. the installation will be exact the same. But you may need some adjustments to install on other distros of Linux. 

By the way, you can try it out on Windows, but **WINDOWS IS NOT RECOMENDED!**

If you have not installed docker, please run
```Shell
sudo apt update && sudo apt install -y curl git
sudo curl -fsSL https://get.docker.com | sudo bash -s docker
```

If you have a GPU, please make sure that you **have the driver installed**, and run
```Shell
sudo sh nvidia-container-runtime-script.sh
sudo apt-get install nvidia-container-runtime
```

## Installation and Run

This image does not contain model. It will automatically download model when in need. 
```shell
git clone https://github.com/hero-intelligent/tortoise-tts-docker.git
cd tortoise-tts
sudo docker build --target basic -t tortoise-tts .
```

Then run
```Shell
sudo docker run -d --gpus=all \
    --name=tortoise-tts \
    -p 7860:7860 \
    -v ./app:/app \
    -v ./models:/root/.cache \
    tortoise-tts 
```
The directory that contains model is mounted to `./models`, but they are separated in different sub-directories, which is the original program's feature.


If you have **CPU only** and really want to try it out, or just want to try it out on Windows docker, then run
```shell
sudo docker run -d \
    --name=tortoise-tts \
    -p 7860:7860 \
    -v ./app:/app \
    -v ./models:/root/.cache \
    tortoise-tts 
```
But believe me, you'll get terrible experience. It takes 20 minutes on i9 12900H only to generate two words "hello world".

NOTE: Run with Windows docker have no GPU acceleration! Run with Virtual Machine and pass through GPU if you really want to run it on Windows!

Finally, visit `localhost:7860` and enjoy! If you run it remotely, please change `localhost` to the remote ip instead.



