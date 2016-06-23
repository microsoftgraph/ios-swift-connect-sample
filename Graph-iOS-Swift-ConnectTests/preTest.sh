#!/bin/sh

FILE="./Graph-iOS-Swift-ConnectTests/testUserArgs.json"

/bin/cat <<EOM >$FILE
{
  "test.clientId" : "$1",
  "test.username" : "$2",
  "test.password" : "$3"
}
EOM
