## Complete installation using Docker Compose

Utilities and info for building and running the Wikispeech server using [Docker Compose](https://docs.docker.com/compose/).

### I. Install Docker CE

1. Install Docker CE for your OS: https://docs.docker.com/engine/installation/   
   * Ubuntu installation: https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/
   * Debian installation: https://docs.docker.com/engine/installation/linux/docker-ce/debian/

2. If you're on Linux, make sure you set all permissions and groups as specified in the post-installation instructions: https://docs.docker.com/engine/installation/linux/linux-postinstall/ 


### II. Install Docker Compose

Docker Compose Installation: https://docs.docker.com/compose/install/   

Sample installation command for Linux version 1.16.1 (latest version as of 2017-09-06):   
  
    $ sudo -i curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    
    $ sudo chmod +x /usr/local/bin/docker-compose

### III. Setup Wikispeech

The setup here will use Docker images released on [Docker Hub](https://hub.docker.com/u/sttsse/).

1. Clone the `wikispeech_compose` repository

   `$ git clone https://github.com/stts-se/wikispeech_compose.git`

2. Create environment variables

   `$ cd wikispeech_compose/docker`      
   `docker$ cp TEMPLATE.env .env`     
   
   Edit the variables in the `.env` file to match your desired settings.


3. Run wikispeech
   
   `docker$ docker-compose --file wikispeech.yml up --abort-on-container-exit`
 
   If all components are started successfully, Wikispeech should be up and running on http://localhost:10000/. You can verify that it's working by visiting http://localhost:10000/wikispeech using your browser. Please note that your browser must support .opus audio files.
   
   
4. Setup standard lexicon data (optional)

   Shutdown the wikispeech server if it's running:   
   `docker$ docker-compose --file wikispeech.yml down`
   
   Import (this will take some time):    
   `docker$ docker-compose --file pronlex-import-all.yml up`
   
   Start server:   
   `docker$ docker-compose --file wikispeech.yml up --abort-on-container-exit`
   
5. Start server and fetch updated images from Docker Hub
   `docker$ docker-compose --file wikispeech.yml up --abort-on-container-exit pull`


---

### For developers
 
 Developers who build their own Docker images should use the files named `*-dev.yml` instead: `wikispeech-dev.yml` and `pronlex-import-all-dev.yml`:
   
   Start server:   
   `docker$ docker-compose --file wikispeech.yml up --abort-on-container-exit`
   
   Import standard lexicon data (optional):   
   `docker$ docker-compose --file pronlex-import-all.yml up`
   
   Re-build Docker images (if needed):   
   `docker$ docker-compose --file wikispeech-dev.yml up --abort-on-container-exit --build`


