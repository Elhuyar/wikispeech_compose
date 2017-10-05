FROM sttsse/wikispeech_base

WORKDIR "/"


## INSTALL MISHKAL
RUN git clone https://github.com/linuxscout/mishkal.git

WORKDIR "mishkal"
#RUN fgrep "self.display(word, format_display)]" mishkal/tashkeel/tashkeel.py
RUN sed 's/self.display(word, format_display)/self.display(voc_word, format_display)/' mishkal/tashkeel/tashkeel.py > mishkal/tashkeel/tashkeel.py_UPDATE
RUN mv mishkal/tashkeel/tashkeel.py  mishkal/tashkeel/tashkeel.py_OLD
RUN cp mishkal/tashkeel/tashkeel.py_UPDATE mishkal/tashkeel/tashkeel.py
#RUN fgrep "self.display" mishkal/tashkeel/tashkeel.py


## RUNTIME SETTINGS
WORKDIR "/"
EXPOSE 8080
CMD python /mishkal/interfaces/web/mishkal-webserver.py
