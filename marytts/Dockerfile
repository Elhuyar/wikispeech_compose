FROM openjdk

RUN apt-get update -y && apt-get upgrade -y && apt-get install apt-utils -y

RUN apt-get install wget

RUN git clone https://github.com/HaraldBerthelsen/marytts.git

RUN cd marytts && ./gradlew build

# INSTALL LIBS WITHOUT RUNNING MARYTTS
RUN cd marytts && ./gradlew installDist

# INSTALL ADDON VOICES
RUN cp marytts/stts_voices/* marytts/build/install/marytts/lib/

## ARABIC DISABLED AND REMOVED FROM WIKISPEECH INIT TESTS AS OF 2017-09-11 (HL+HB)
# RUN cd marytts/build/install/marytts/lib/ && wget https://github.com/HaraldBerthelsen/voice-ar-nah-hsmm/releases/download/v5.2/voice-ar-nah-hsmm-5.2.jar

RUN cd /tmp/ && wget https://github.com/HaraldBerthelsen/voice-stts_no_nst-hsmm/releases/download/v5.2/voice-stts_no_nst-hsmm-5.2.zip && unzip voice-stts_no_nst-hsmm-5.2.zip && cp lib/voice-stts_no_nst-hsmm-5.2.jar /marytts/build/install/marytts/lib/

RUN echo "VOICES"

RUN ls marytts/build/install/marytts/lib/voice* | sed 's/.jar//'


EXPOSE 59125

CMD (cd marytts && ./gradlew run)
