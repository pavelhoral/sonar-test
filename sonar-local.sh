#!/bin/bash

if [ -z "$SONAR_TOKEN" ]; then
  echo "Missing SONAR_TOKEN variable" >&2
  exit 1
fi

mvn verify -Pmetrics

PROJECT_SOURCES=$(
  find . -path "*/target" -prune -o -path "*/src/main" -type d -print -o -name "pom.xml" -print | \
  paste -sd, -
)
PROJECT_TESTS=$(
  find . -path "*/target" -prune -o -path "*/src/test" -type d -print | \
  paste -sd, -
)

# TODO this would require parsing pom.xml
PROJECT_VERSION=1.0.0-SNAPSHOT

PROJECT_JAVA_BINARIES=$(find . -path "*/target/classes" -type d | paste -sd, -)
# TODO this would require transporting JARs from local repo (maven-assembly or manual ZIP)
PROJECT_JAVA_LIBRARIES=$(
  find . -name compile-deps.txt | \
  xargs awk '{ gsub(":", "\n"); print }' | \
  sort -u | \
  tr '\n' ',' |
  sed 's/,$//'
)
PROJECT_JAVA_TEST_BINARIES=$(find . -path "*target/test-classes" -type d | paste -sd, -)
# TODO this would require transporting JARs from local repo (maven-assembly or manual ZIP)
PROJECT_JAVA_TEST_LIBRARIES=$(
  find . -name test-deps.txt | \
  xargs awk '{ gsub(":", "\n"); print }' | \
  sort -u | \
  tr '\n' ',' |
  sed 's/,$//'
)

PROJECT_COVERAGE_PATHS=$(find . -path "*/target/site/jacoco/jacoco.xml" -type f | paste -sd, -)

SONAR_EXEC=~/Work/sonar-scanner/bin/sonar-scanner

SONAR_ARGS="\
  -Dsonar.organization=pavelhoral \
  -Dsonar.projectKey=pavelhoral_sonar-test-local \
  -Dsonar.sources=$PROJECT_SOURCES \
  -Dsonar.tests=$PROJECT_TESTS \
  -Dsonar.projectVersion=$PROJECT_VERSION \
  -Dsonar.java.binaries=$PROJECT_JAVA_BINARIES \
  -Dsonar.java.libraries=$PROJECT_JAVA_LIBRARIES \
  -Dsonar.java.test.binaries=$PROJECT_JAVA_TEST_BINARIES \
  -Dsonar.java.test.libraries=$PROJECT_JAVA_TEST_LIBRARIES \
  -Dsonar.coverage.jacoco.xmlReportPaths=$PROJECT_COVERAGE_PATHS \
  -Dsonar.host.url=https://sonarcloud.io"

#  -Dsonar.projectName=TODO
#  -Dsonar.sarifReportPaths=TODO (PMD, CheckStyle, SpotBugs)
#  -Dsonar.links.ci
#  -Dsonar.links.homepage
#  -Dsonar.links.scm

# -Dsonar.pullrequest.key
# -Dsonar.pullrequest.branch
# -Dsonar.pullrequest.base

$SONAR_EXEC $SONAR_ARGS
