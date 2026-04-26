This project uses auditd to log all write operations within the `/var/www/html` directory.

It can be used to identify which processes (e.g. cron jobs) are writing data to this folder.

### Example Usage

To start monitoring the `/var/www/html` directory (recursively, so changes in subdirectories like `foo` will also be tracked) and identify which processes are writing to it, run:
```bash
sudo auditctl -a never,exit -F dir=/var/www/html/bar
sudo auditctl -a never,exit -F dir=/var/www/html/vendor
sudo auditctl -a always,exit -F arch=b64 -F path=/var/www/html -F perm=w -F key=var_www_write
```

To search for audit logs tagged with `var_www_write` (all write actions in `/var/www/html` and its subdirectories), use:
```bash
sudo ausearch -i -k var_www_write
```

[man 8 auditctl](https://linux.die.net/man/8/auditctl)
