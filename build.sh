#!/bin/bash

DATE=`date -u '+%Y-%m-%dT%H:%M:%S%Z'`
REV=`git rev-parse HEAD`

for SBT_VERSION in '1.2.8' '1.3.3'; do
    for SCALA_VERSION in '2.12.9' '2.13.0'; do
        echo ""
        echo "BUILD scala=${SCALA_VERSION} sbt=${SBT_VERSION}"
        docker build \
            --label "org.opencontainers.image.created=${DATE}" \
            --label "org.opencontainers.image.revision=${REV}" \
            --build-arg "SCALA_VERSION=${SCALA_VERSION}" \
            --build-arg "SBT_VERSION=${SBT_VERSION}" \
            -t "maizy/actions-setup-sbt:8u212-scala-${SCALA_VERSION}-sbt-${SBT_VERSION}-v1" \
            .
    done
done
