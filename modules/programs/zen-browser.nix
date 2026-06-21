{
  delib,
  host,
  inputs,
  ...
}:
delib.module {
  name = "programs.zen-browser";

  options = delib.singleEnableOption host.guiFeatured;

  home.always.imports = [ inputs.zen-browser.homeModules.beta ];
  home.ifEnabled = {
    programs.zen-browser = {
      enable = true;
      policies = {
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        DisableAppUpdate = true;
        DisableTelemetry = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
      };
    };
  };
}
