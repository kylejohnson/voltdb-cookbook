#!/usr/bin/env bats

@test "I can insert into VoltDB" {
  run /opt/voltdb-ent-4.3/bin/sqlcmd --query="insert into artists values ('Metallica', 1)"
  [ "$status" -eq 0 ]
}

@test "I can select from VoltDB" {
  run /opt/voltdb-ent-4.3/bin/sqlcmd --query="select * from artists"
  [ "$status" -eq 0 ]
}
