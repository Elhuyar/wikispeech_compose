## 1. BASICS

# STARTING FROM THE OFFICIAL GOLANG IMAGE (required by pronlex)
FROM golang

# SET UP APT
RUN apt-get update -y && apt-get upgrade -y && apt-get install apt-utils -y 

# INSTALL DEBUGGING/DEV TOOLS
RUN apt-get install -y libnet-ifconfig-wrapper-perl/stable curl wget emacs


## 2. DEPENDENCIES


####### COMMON DEPS
RUN apt-get install -y git


####### WIKISPEECH SERVER/MOCKUP DEPS
RUN apt-get install -y opus-tools python3-pip netcat
RUN pip3 install simplejson requests flask flask_cors pytz tzlocal
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8


####### PRONLEX DEPS
RUN apt-get install -y sqlite3 gcc build-essential


####### MARYTTS DEPS

# PYTHON
RUN apt-get install -y python 

# JAVA 8
RUN apt-get install -y software-properties-common && add-apt-repository ppa:openjdk && apt-get install -y openjdk-8-jdk


####### PATHS
RUN mkdir -p /wikispeech
RUN mkdir -p /wikispeech/bin
#RUN export PATH=/wikispeech/bin:$PATH # doesn't work


###### BUILD INFO
RUN echo -n "Build timestamp: " > /wikispeech/.wikispeech_base_build_info.txt
RUN date --utc "+%Y-%m-%d %H:%M:%S %Z" >> /wikispeech/.wikispeech_base_build_info.txt
RUN echo "Built by: docker" >> /wikispeech/.wikispeech_base_build_info.txt
RUN echo "Application name: marytts"  >> /wikispeech/.wikispeech_base_build_info.txt


WORKDIR "/"
