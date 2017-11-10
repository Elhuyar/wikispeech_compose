# Download sttsse/wikispeech_base from hub.docker.com | source repository: https://github.com/stts-se/wikispeech_base.git
# FROM sttsse/wikispeech_base

FROM marytts

WORKDIR "/"

## INSTALL MISHKAL
# RUN git clone https://github.com/linuxscout/mishkal.git
RUN git clone https://github.com/HaraldBerthelsen/mishkal.git

WORKDIR "mishkal"
#RUN fgrep "self.display(word, format_display)]" mishkal/tashkeel/tashkeel.py
RUN sed 's/self.display(word, format_display)/self.display(voc_word, format_display)/' mishkal/tashkeel/tashkeel.py > mishkal/tashkeel/tashkeel.py_UPDATE
RUN mv mishkal/tashkeel/tashkeel.py  mishkal/tashkeel/tashkeel.py_OLD
RUN cp mishkal/tashkeel/tashkeel.py_UPDATE mishkal/tashkeel/tashkeel.py
#RUN fgrep "self.display" mishkal/tashkeel/tashkeel.py

RUN echo "python /mishkal/interfaces/web/mishkal-webserver.py &" > /bin/marytts-mishkal-start
RUN echo "sleep 2" >> /bin/marytts-mishkal-start
RUN echo "cd /marytts && ./gradlew run" >> /bin/marytts-mishkal-start

RUN chmod +x /bin/marytts-mishkal-start

## RUNTIME SETTINGS
WORKDIR "/"
#EXPOSE 8080
#CMD python /mishkal/interfaces/web/mishkal-webserver.py
EXPOSE 59125
CMD /bin/marytts-mishkal-start
