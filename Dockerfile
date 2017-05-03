FROM localhost:5000/oracle/serverjre:8
MAINTAINER torsten.kleiber@web.de
ARG SW_FILE1
ARG SW_FILE2
USER root
ADD $SW_FILE1 /tmp/
ADD $SW_FILE2 /tmp/
ADD create_inventory.sh /tmp/
ADD silent.rsp /tmp/
RUN yum -y install xterm xauth libXtst \
&& groupadd -g 54322 oracle \
&& useradd -u 54321 -g oracle oracle \
&& /tmp/create_inventory.sh /opt/oracle/oraInventory oracle \
&& mkdir -p /oracle/home \
&& chown -R oracle:oracle /home/oracle
USER oracle
ENV JAVA_HOME=/usr/java/default
RUN java -jar /tmp/$SW_FILE1 -silent -force -responseFile /tmp/silent.rsp 
USER root
RUN rm -f /tmp/$SW_FILE1 \
&& rm -f /tmp/$SW_FILE2 \
&& rm -f /tmp/create_inventory.sh \
&& rm -f /tmp/silent.rsp
USER oracle
CMD /home/oracle/jdev_122120/jdeveloper/jdev/bin/jdev