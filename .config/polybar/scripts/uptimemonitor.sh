#!/bin/bash

uptime --pretty | \
      sed 's/^up //' | \
      sed -E 's/[, ]//g' | \
      sed -E 's/([0-9]*)week[s]*/W:\1 /' | \
      sed -E 's/([0-9]*)day[s]*/D:\1 /' | \
      sed -E 's/([0-9]*)hour[s]*/H:\1 /' | \
      #sed -E 's/([0-9]*)minute[s]*/M:\1/'
      sed -E 's/([0-9]*)minute[s]*//'
