FROM nimbix/ubuntu-xrt:201802.2.1.83_16.04  
MAINTAINER Accelize, SAS.
# Xilinx Device Support Archive (DSA) for target FPGA
ENV DSA xilinx_u200_xdma_201820_1
# JARVICE Machine Type. nx5u: Alveo u200, nx6u: Alveo u250
ENV JARVICE_MACHINE nx5u
# FPGA bitstream to configure accelerator (*.xclbin format)
ENV XCLBIN_PROGRAM drm_demo/bitstreams/u200/binary_container_1.xclbin
# FPGA bitstream to remove from container (*.xclbin format)
#ENV XCLBIN_REMOVE drm_demo/bitstreams/u200/binary_container_1.xclbin
# FPGA platform 
# Replace <tags> with docker --build-arg (s)
RUN sed -i "s/<jarvice-machine>/$JARVICE_MACHINE/g" /etc/NAE/AppDef.json



# Metadata for App
ADD AppDef.json /etc/NAE/AppDef.json
RUN curl --fail -X POST -d @/etc/NAE/AppDef.json https://api.jarvice.com/jarvice/validate

# App install Path
RUN mkdir -p /opt/accelize/

# DRMLib Install
ADD drmlib_install.sh /opt/accelize/drmlib_install.sh
RUN chmod 777 /opt/accelize/drmlib_install.sh
RUN /opt/accelize/drmlib_install.sh

# Add DRM Demo App data
ADD drm_demo /opt/accelize/drm_demo/

# Readme.md
ADD README.md /opt/accelize/

# Expose port 22 for local JARVICE emulation in docker
EXPOSE 22

# for standalone use
EXPOSE 5901
EXPOSE 443
