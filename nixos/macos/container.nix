# Apple's container framework
{ container, ... }: {
  launchd.agents."containers.default" = {
    command = "${container}/bin/container system start";
    serviceConfig = {
      Label = "com.container.default";
      RunAtLoad = true;
      KeepAlive = true;
    };
  };
}
