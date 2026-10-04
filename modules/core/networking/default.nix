{ config, hostName, ... }:

let
  quad9DNS = [
    "9.9.9.9#dns.quad9.net"
    "149.112.112.112#dns.quad9.net"
    "2620:fe::fe#dns.quad9.net"
    "2620:fe::9#dns.quad9.net"
  ];
in
{
  networking = {
    inherit hostName;
    dhcpcd.wait = "background";
  };

  services.resolved = {
    enable = true;

    settings.Resolve = {
      DNS = quad9DNS;
      DNSOverTLS = "opportunistic";
      DNSSEC = "supported";
    };
  };

  services.avahi = {
    enable = true;
    openFirewall = true;
    nssmdns4 = true;
    nssmdns6 = true;
  };
}