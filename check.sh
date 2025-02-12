#!/bin/sh

set -e

FILE_PATH=${1:-/scripts/composer.lock}

CURL_OPTIONS="--retry 3 --silent"

if [ ! -e $FILE_PATH ]; then
    echo $FILE_PATH not found 2>&1
    exit 1
fi

if [ ! -z "$VERSIONEYE_PROJECT_ID" ]; then
    if [ -z "$VERSIONEYE_API_KEY" ]; then
        echo "env VERSIONEYE_API_KEY is missing"
        exit 1
    fi

    API_URL="https://www.versioneye.com/api/v2/projects/$VERSIONEYE_PROJECT_ID?api_key=$VERSIONEYE_API_KEY"

    curl $CURL_OPTIONS $API_URL -F project_file=@$FILE_PATH > /tmp/VERSIONEYE-report.json

    cat /tmp/VERSIONEYE-report.json \
        | jq '.dependencies | map({
            issues: .security_vulnerabilities,
            name: .name
        }) | map(select(.issues != null))' \
        > /tmp/VERSIONEYE-issues.json

    if [ $(cat /tmp/VERSIONEYE-issues.json | jq '.|length') -ne 0 ]; then
        cat /tmp/VERSIONEYE-issues.json | jq '.[]'
        exit 1
    fi
fi

if [ "$SENSIOLABS" != "false" ]; then
    API_URL="https://security.sensiolabs.org/check_lock"

    curl $CURL_OPTIONS -H "Accept: text/plain" $API_URL -F lock=@$FILE_PATH -D /tmp/security_check_headers.log > /tmp/output

    if ! grep -q "X-Alerts: 0" /tmp/security_check_headers.log; then
        cat /tmp/output
        exit 1
    fi
fi
