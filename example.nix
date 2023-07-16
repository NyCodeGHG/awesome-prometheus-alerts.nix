{ config, ... }:
{
  services.prometheus = {
    enable = true;
    awesome-prometheus-alerts = {
      prometheus-self-monitoring.embedded-exporter.enable = true;
    };
  };

  # Only needed for testing, don't do this on production servers.
  users.allowNoPasswordLogin = true;
  users.users.root.password = "password";
  virtualisation.vmVariant = {
    virtualisation.forwardPorts = [
      {
        from = "host";
        host.port = config.services.prometheus.port;
        guest.port = config.services.prometheus.port;
      }
    ];
  };
}