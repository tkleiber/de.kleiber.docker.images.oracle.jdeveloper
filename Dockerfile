FROM localhost:5000/oracle/serverjre:8
MAINTAINER torsten.kleiber@web.de
ARG SW_FILE1
ARG SW_FILE2
USER root
RUN yum -y install xterm xauth libXtst
ADD $SW_FILE1 /tmp/
ADD $SW_FILE2 /tmp/
ADD create_inventory.sh /tmp/
ADD silent.rsp /tmp/
RUN groupadd -g 54322 oracle
RUN useradd -u 54321 -g oracle oracle
RUN /tmp/create_inventory.sh /opt/oracle/oraInventory oracle
RUN mkdir -p /oracle/home
RUN chown -R oracle:oracle /home/oracle
RUN ls -la /home/oracle
USER oracle
RUN ls -la /home/oracle
RUN pwd
ENV JAVA_HOME=/usr/java/default
RUN java -jar /tmp/$SW_FILE1 -silent -force -responseFile /tmp/silent.rsp 
USER root
RUN rm -f /tmp/$SW_FILE1
RUN rm -f /tmp/$SW_FILE2
RUN rm -f /tmp/create_inventory.sh
RUN rm -f /tmp/silent.rsp
USER oracle
CMD /home/oracle/jdev_122120/jdeveloper/jdev/bin/jdev