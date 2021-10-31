#!/bin/bash
# build cnstream
mkdir build && cd build \
    && cmake .. \
    && make -j4 \
    && echo -e "\033[0;32m[Build cnstream... Done] \033[0m"