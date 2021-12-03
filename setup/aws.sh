#! /usr/bin/env bash

aws_setup_tmp="$(mktemp -d /tmp/aws-setup-XXXXX)"

(
  cd "${aws_setup_tmp}"
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
)

rm -rf "${aws_setup_tmp}"
