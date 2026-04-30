This project provides a setup for monitoring [Supervisor](https://supervisord.org/) processes using Prometheus.

 `supervisord_exporter` collects metrics from Supervisor and exposes them for Prometheus scraping.

### Usage Examples

To spin up a virtual machine with Supervisor and the exporter:

```bash
vagrant up
```

The exporter will be available at `http://localhost:9876/metrics` on your host machine.
