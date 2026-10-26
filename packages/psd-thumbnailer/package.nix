{
  lib,
  python3,
  symlinkJoin,
  writeScriptBin,
  writeTextFile,
}:

let
  python = python3.withPackages (ps: [ ps.psd-tools ]);

  psdThumbnailer = writeScriptBin "psd-thumbnailer" ''
    #!${python}/bin/python3
    import sys

    from psd_tools import PSDImage

    source, destination, size = sys.argv[1], sys.argv[2], int(sys.argv[3])

    psd = PSDImage.open(source)
    thumbnail = psd.thumbnail() or psd.composite()
    if thumbnail is None:
        raise SystemExit(f"Unable to generate a thumbnail for {source}")

    thumbnail.thumbnail((size, size))
    thumbnail.convert("RGB").save(destination, "PNG")
  '';

  thumbnailerEntry = writeTextFile {
    name = "psd-thumbnailer.thumbnailer";
    destination = "/share/thumbnailers/psd.thumbnailer";
    text = ''
      [Thumbnailer Entry]
      TryExec=${psdThumbnailer}/bin/psd-thumbnailer
      Exec=${psdThumbnailer}/bin/psd-thumbnailer %i %o %s
      MimeType=image/vnd.adobe.photoshop;
    '';
  };
in
symlinkJoin {
  name = "psd-thumbnailer";
  paths = [
    psdThumbnailer
    thumbnailerEntry
  ];

  meta = {
    description = "Freedesktop thumbnailer for Adobe Photoshop PSD files";
    homepage = "https://github.com/psd-tools/psd-tools";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
