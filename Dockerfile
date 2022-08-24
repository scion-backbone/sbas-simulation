# - build with `docker build --tag sbas-simulation .`
# - display help with `docker run --rm sbas-simulation`
# - run simulation with `docker run -it sbas-simulation -t data/topo/20210401.as-rel2.txt -o data/origins/origins-sbas-k100adv.800.txt -p data/policies/policies-sbas-victims.txt`
# - run interactive container with `docker run -it --entrypoint /bin/bash sbas-simulation`
# - execute simulation from within the container with `/sbas-simulation/code/simulate.py --topology_file data/topo/20210401.as-rel2.txt --origins_file data/origins/origins-sbas-k100adv.800.txt --policies_file data/policies/policies-sbas-victims.txt

# (Tested with docker installed via snap `snap install docker`)

FROM ubuntu:jammy

RUN apt-get update && apt-get install -y \
    dos2unix \
    git \
    python3 \
    python3-pip \
    vim \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install matplotlib netaddr numpy

WORKDIR sbas-simulation
RUN git init -q && git remote add origin https://github.com/scion-backbone/sbas-simulation.git
RUN git fetch -q --depth 1 origin HEAD && git checkout -q FETCH_HEAD
RUN dos2unix /sbas-simulation/code/simulate.py
ENTRYPOINT ["/sbas-simulation/code/simulate.py"]
CMD ["--help"]