#!/bin/bash
cd "$(dirname "$0")"
bash scripts/environment_check.sh
bash scripts/folder_builder.sh
bash scripts/perm_setter.sh
bash scripts/service_tester.sh
bash scripts/log_recorder.sh
echo "MICO INSTALLER SELESAI"
