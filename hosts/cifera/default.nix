{ delib, ... }:
delib.host {
  name = "cifera";
  type = "laptop";

  features = [ "secureboot" ];
}
