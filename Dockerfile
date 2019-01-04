FROM nimbix/ubuntu-xrt:201802.2.1.83_16.04  
MAINTAINER Accelize, SAS.
# Xilinx Device Support Archive (DSA) for target FPGA
ENV DSA xilinx_u200_xdma_201820_1
# JARVICE Machine Type. nx5u: Alveo u200, nx6u: Alveo u250
#ARG JARVICE_MACHINE
ENV JARVICE_MACHINE nx5u
# FPGA bitstream to configure accelerator (*.xclbin format)
#ARG XCLBIN_PROGRAM
ENV XCLBIN_PROGRAM binary_container_1.xclbin
# FPGA bitstream to remove from container (*.xclbin format)
#ARG XCLBIN_REMOVE
#ENV XCLBIN_REMOVE 


# Metadata for App
ADD help.html /etc/NAE/help.html
ADD AppDef.json /etc/NAE/AppDef.json
RUN curl --fail -X POST -d @/etc/NAE/AppDef.json https://api.jarvice.com/jarvice/validate
# FPGA platform 
# Replace <tags> with docker --build-arg (s)
RUN sed -i "s/<jarvice-machine>/$JARVICE_MACHINE/g" /etc/NAE/AppDef.json
# Test FPGA bitstream
ADD xclbin/$DSA/$XCLBIN_PROGRAM /opt/example/
#RUN chmod 555 /opt/example/test.xclbin
# Add additional FPGA bitstream to demo removal of unused kernels
#ADD xclbin/$DSA/$XCLBIN_REMOVE /opt/example/remove1.xclbin
#ADD xclbin/$DSA/$XCLBIN_REMOVE /opt/example/remove2.xclbin
# Test host application
ADD hello_world_u200.exe /opt/example/
# Test script
#ADD run-test.sh /opt/example/run-test.sh
#RUN chmod 777 /opt/example/run-test.sh
# Replace <tag> with docker --build-arg
#RUN sed -i "s/<xcl-dsa-name>/$DSA/g" /opt/example/run-test.sh

# Expose port 22 for local JARVICE emulation in docker
EXPOSE 22

# for standalone use
EXPOSE 5901
EXPOSE 443
