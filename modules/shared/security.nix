{lib, ...}: {
  security.doas = {
    enable = lib.mkDefault true;
    extraRules = [
      {
        groups = ["wheel"];
        keepEnv = true;
        persist = lib.mkDefault true;
      }
    ];
  };
}
