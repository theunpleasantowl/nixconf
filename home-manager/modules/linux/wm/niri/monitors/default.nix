{ lib, ... }:
{
  imports =
    let
      files = builtins.readDir ./.;
      hostFiles = builtins.filter (fn: fn != "default.nix") (builtins.attrNames files);
    in
    map (fn: ./. + "/${fn}") hostFiles;

}
