# SPDX-FileCopyrightText: Copyright (c) 2026 Max Trunnikov
# SPDX-License-Identifier: MIT
#!/bin/bash

set -euo pipefail

dir=$1

cd "${GITHUB_WORKSPACE}"

xslint "${dir}"
