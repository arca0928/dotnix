{
  flake.modules.homeManager.browser =

    { inputs, ... }:
    {
      imports = [
        inputs.zen-browser.homeModules.beta
      ];

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
