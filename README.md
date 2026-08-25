## [traefik-sni-load-balancer](traefik-sni-load-balancer)

This project demonstrates how to set up a Traefik-based load balancer that uses SNI (Server Name Indication) to route TLS traffic to different backend services based on SNI value.

## [traefik-rewrite-host](traefik-rewrite-host)

This project demonstrates how Traefik can rewrite the `Host` header before forwarding requests to backend services.
It includes examples of routing traffic based on one domain and modifying it to match the expected value of the target application.

## [auditd](auditd)

This project uses auditd to monitor and log write operations within specific directories. 
It helps identify which processes are performing file modifications, making it useful for auditing and debugging.

## [supervisord_exporter](supervisord_exporter)

This project provides a setup for monitoring Supervisor processes using Prometheus. 
It includes configurations for the exporter to collect metrics via Unix sockets or HTTP.

## [mysql-replication](mysql-replication)

This project demonstrates how to set up and configure MySQL Primary-Replica replication using Docker Compose and Ansible.
