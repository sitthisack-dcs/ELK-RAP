#!/bin/bash

# Detect docker compose command (v1 or v2)
if command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE="docker-compose"
elif docker compose version &> /dev/null; then
    DOCKER_COMPOSE="docker compose"
else
    echo "Error: Neither 'docker-compose' nor 'docker compose' found"
    exit 1
fi

case "$1" in
    init)
        echo "Unpacking malware-traffic-analysis.net data..."
        bunzip2 -k malware-traffic-analysis.net/eve.json.bz2
        echo "Building loader container..."
        $DOCKER_COMPOSE build loader
        echo "Starting Elasticsearch and Kibana..."
        $DOCKER_COMPOSE up -d elasticsearch kibana
        echo "Waiting for services to be ready..."
        sleep 30
        echo "Running data loader..."
        $DOCKER_COMPOSE up loader
        echo "Starting Filebeat..."
        $DOCKER_COMPOSE up -d filebeat
        echo "Cleaning up decompressed data..."
        rm -f malware-traffic-analysis.net/eve.json
        echo ""
        echo "========================================"
        echo "ELK Detection Lab is now running!"
        echo "Kibana: http://localhost:5601"
        echo "Elasticsearch: http://localhost:9200"
        echo "========================================"
        echo ""
        echo "Wait 5-10 minutes for Filebeat to ingest data, then check Kibana Discover."
        echo "Adjust time range to 2013-2020 to see malware traffic data."
        ;;
    init-windowsonly)
        echo "Building loader container..."
        $DOCKER_COMPOSE build loader
        echo "Starting Elasticsearch and Kibana..."
        $DOCKER_COMPOSE up -d elasticsearch kibana
        echo "Waiting for services to be ready..."
        sleep 30
        echo "Running data loader (Windows logs only)..."
        $DOCKER_COMPOSE up loader
        echo "Cleaning up..."
        rm -f malware-traffic-analysis.net/eve.json
        echo ""
        echo "========================================"
        echo "ELK Detection Lab is now running!"
        echo "Kibana: http://localhost:5601"
        echo "Elasticsearch: http://localhost:9200"
        echo "========================================"
        ;;
    run)
        echo "Starting ELK Detection Lab..."
        $DOCKER_COMPOSE up -d elasticsearch kibana filebeat
        echo ""
        echo "========================================"
        echo "ELK Detection Lab is running!"
        echo "Kibana: http://localhost:5601"
        echo "Elasticsearch: http://localhost:9200"
        echo "========================================"
        ;;
    stop)
        echo "Stopping ELK Detection Lab..."
        $DOCKER_COMPOSE stop
        ;;
    rm)
        echo "Removing ELK Detection Lab containers..."
        $DOCKER_COMPOSE rm -f
        ;;
    logs)
        $DOCKER_COMPOSE logs -f
        ;;
    *)
        cat <<HELP
Usage:
$0 init              - Initial setup: run environment and import all data (Windows + network traffic)
$0 init-windowsonly  - Initial setup: import Windows logs only (skip network traffic)
$0 run               - Start already initialized environment
$0 stop              - Stop running environment
$0 logs              - View logs from all containers
$0 rm                - Remove containers (frees disk space, has to be recreated with init)
HELP
        ;;
esac
