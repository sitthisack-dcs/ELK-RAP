# ELK-RAP
For detection purposes, practice investigations using ELK.

REF REPO: https://github.com/thomaspatzke/elk-detection-lab

## Prerequisites

You need at least:

* a working Docker CE installation with docker-compose
* 8 GB free disk space
* 2 GB RAM for a reasonable Elasticsearch performance

## Installation

Clone this repository and the dataset submodules with:

```
git clone --recurse-submodules https://github.com/sitthisack-dcs/ELK-RAP.git
```

Run this command to start the ELK environment and import the datasets:

```
./elk-detection-lab.sh init
```

Wait at least until the document count of all `winlogbeat-*` and `filebeat-*` indices stops to
increase which can take several 10 minutes.

After this was run once, the ELK environment can be started without importing the data again:

```
./elk-detection-lab.sh run
```

## Usage

Open the [local Kibana](http://localhost:5601/app/kibana#/discover) in your browser.

The Windows log data starts in November 2018 and the field naming follows the ECS scheme and
Winlogbeat 7 conventions.

The data created from the malware-traffic-analysis.net PCAPs is located in the index `filebeat-*`
and goes back to 2013. Please adjust the Kibana time range accordingly.