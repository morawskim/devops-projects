This project provides a setup for monitoring [Supervisor](https://supervisord.org/) processes using Prometheus.

 `supervisord_exporter` collects metrics from Supervisor and exposes them for Prometheus scraping.

### Usage Examples

#### TCP Connection (Default)

To spin up a virtual machine with Supervisord and the exporter:

```bash
vagrant up
vagrant ssh
sudo systemctl start supervisord_exporter.service
```

The exporter will be available at `http://localhost:9876/metrics` on your host machine.

#### Unix Socket Connection

The exporter can also connect to Supervisord via a Unix domain socket.
To configure this, use the `-supervisord-url` flag:

```bash
/home/vagrant/supervisord_exporter/supervisord_exporter -supervisord-url unix:///run/supervisor/supervisor.sock
```

Example configuration in `/etc/sysconfig/supervisord_exporter`:

```bash
SUPERVISORD_EXPORTER_ARGS="-supervisord-url unix:///run/supervisor/supervisor.sock"
```
