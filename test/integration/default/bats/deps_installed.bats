#!/usr/bin/env bats

@test "ntp is installed" {
  run ntpd --version
  [ "$status" -eq 0 ]
}

@test "ntp is running" {
  run ntpq -pn
  [ "$status" -eq 0 ]
}

@test "python2.7 is installed" {
  run python2.7 --version
  [ "$status" -eq 0 ]
}
