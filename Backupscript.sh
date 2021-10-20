#!/usr/bin/env bash
mkdir backup
/usr/bin/mysql -u "${wordpress}" \
    -p"${123}" \
    "${wordpressuser}" \
    | gzip > "/opt/backup/wordpress_$(date +%F).sql.gz"