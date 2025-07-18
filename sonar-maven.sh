#!/bin/bash

if [ -z "$SONAR_TOKEN" ]; then
  echo "Missing SONAR_TOKEN variable" >&2
  exit 1
fi

SONAR_ARGS="\
  -Dsonar.organization=pavelhoral \
  -Dsonar.projectKey=pavelhoral_sonar-test-maven \
  -Dsonar.host.url=https://sonarcloud.io"

mvn verify org.sonarsource.scanner.maven:sonar-maven-plugin:sonar $SONAR_ARGS "$@"
