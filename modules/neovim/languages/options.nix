{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.vim-languages = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule ({
      options.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable this language environment.";
      };
    }));
    default = {};
    description = "Language-specific configuration.";
  };
}
