{ ... }:
{
  programs.swayimg = {
    enable = true;
    initLua = ''
      -- viewer
      swayimg.viewer.set_window_background(0x10000010)
      swayimg.viewer.set_default_scale("fill")

      -- info overlay (top-left): name + format
      swayimg.viewer.set_text("topleft", {
        "{name}",
        "{format}"
      })

      -- gallery navigation (hjkl)
      swayimg.gallery.on_key("h", function() swayimg.gallery.switch_image("left") end)
      swayimg.gallery.on_key("j", function() swayimg.gallery.switch_image("down") end)
      swayimg.gallery.on_key("k", function() swayimg.gallery.switch_image("up") end)
      swayimg.gallery.on_key("l", function() swayimg.gallery.switch_image("right") end)

      -- viewer: next/prev file
      swayimg.viewer.on_key("n", function() swayimg.viewer.open("next") end)
      swayimg.viewer.on_key("p", function() swayimg.viewer.open("prev") end)

      -- quit
      swayimg.viewer.on_key("q", function() swayimg.exit() end)
      swayimg.viewer.on_key("Escape", function() swayimg.exit() end)
    '';
  };
}
