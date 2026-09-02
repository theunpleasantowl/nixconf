{
  isStandalone ? true,
  ...
}:
{
  imports = if isStandalone then [ ] else (import ../../../../lib { }).importModuleSiblings ./.;
}
