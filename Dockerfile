FROM store/oracle/serverjre:8
MAINTAINER torsten.kleiber@web.de
ARG SW_FILE1
ARG SW_FILE2
USER root
ADD $SW_FILE1 /tmp/
ADD $SW_FILE2 /tmp/
ADD create_inventory.sh /tmp/
ADD silent.rsp /tmp/
RUN yum -y install xterm xauth libXtst
RUN groupadd -g 54322 oracle
RUN useradd -u 54321 -g oracle oracle
RUN ls -la /tmp/create_inventory.sh
RUN ls -la /opt/oracle
RUN mkdir -p /oracle/home
RUN /tmp/create_inventory.sh /home/oracle/oraInventory oracle
RUN chown -R oracle:oracle /home/oracle
USER oracle
ENV JAVA_HOME=/usr/java/default
RUN java -jar /tmp/$SW_FILE1 -silent -force -responseFile /tmp/silent.rsp
USER root
RUN rm -f /tmp/$SW_FILE1 \
&& rm -f /tmp/$SW_FILE2 \
&& rm -f /tmp/create_inventory.sh \
&& rm -f /tmp/silent.rsp
USER oracle
CMD /home/oracle/jdev/jdeveloper/jdev/bin/jdev
