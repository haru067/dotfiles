#!/bin/bash

ps aux | grep "LogiMgrDaemon" | grep -v grep | awk '{ print "kill -9", $2 }'