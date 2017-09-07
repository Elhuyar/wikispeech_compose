## Docker compose 

WORK IN PROGRESS

Utilities and info for building and running the Wikispeech server using [Docker Compose](https://docs.docker.com/compose/).

### I. Install Docker Compose

_Requires Docker CE: https://docs.docker.com/engine/installation/_

Docker Compose Installation: https://docs.docker.com/compose/install/   

Sample installation command for Linux version 1.16.1 (latest version as of 2017-09-06):   
  
    sudo -i curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-Linux-x86_64 -`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

### II. Setup Wikispeech

1. Clone the wikispeech_compose repository

   `$ git clone https://github.com/stts-se/wikispeech_compose.git`

2. Create environment variables

   `$ cd wikispeech_compose/docker`      
   `docker$ cp TEMPLATE.env .env`     
   
   Edit the variables in the `.env` file to match your system settings.


3. Setup standard lexicon data

   `docker$ docker-compose --file pronlex-import-all.yml up`
   
   This will take some time.


4. Run wikispeech
   
   `docker$ docker-compose --file wikispeech.yml up --abort-on-container-exit`



   
