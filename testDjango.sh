#!/usr/bin/env bats
@test "Html check value" {
  TAG_VALUE=$(wget http://localhost:8000/app -O - 2>/dev/null | xmllint --html --xpath "/html/body/table/tr/td/text()" -)
  [ "$TAG_VALUE" = "1name1" ]
}
