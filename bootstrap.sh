#!/bin/bash
set -euxo pipefail
# Keep bootstrap minimal; no package downloads are required for this lab.
hostnamectl set-hostname "$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4 | tr '.' '-')"
