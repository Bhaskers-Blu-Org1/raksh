#!/usr/bin/env bash
# Copyright 2019 IBM Corp
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


set -o errexit
set -o nounset
set -o pipefail

echo "Verify go-fmt!"

ROOT_DIR=$(dirname "${BASH_SOURCE[0]}")/..

source "${ROOT_DIR}/hack/lib/init.sh"

pushd ${ROOT_DIR}

find_go_files() {
  find . -not \( \
      \( \
        -wholename './.git' \
        -o -wholename '*/vendor/*' \
      \) -prune \
    \) -name '*.go'
}

gofmt=$(which gofmt)
diff=$(find_go_files | xargs "${gofmt}" -d -s 2>&1) || true
if [[ -n "${diff}" ]]; then
  echo "${diff}" >&2
  echo >&2
  echo "Run ./hack/update-gofmt.sh" >&2
  exit 1
fi

popd
