{ ... }:
{
  plugins.blink-cmp = {
    enable = true;
    setupLspCapabilities = true;

    settings = {
      keymap.preset = "default";

      sources.default = [
        "lsp"
        "path"
        "snippets"
        "buffer"
      ];

      completion = {
        accept.auto_brackets.enabled = true;
        documentation = {
          auto_show = true;
          auto_show_delay_ms = 200;
        };
        menu.draw = {
          treesitter = [ "lsp" ];
          columns = [
            {
              __unkeyed-1 = "label";
              __unkeyed-2 = "label_description";
              gap = 1;
            }
            {
              __unkeyed-1 = "kind_icon";
              __unkeyed-2 = "kind";
              gap = 1;
            }
          ];
        };
        ghost_text.enabled = true;
      };

      appearance = {
        use_nvim_cmp_as_default = true;
        nerd_font_variant = "normal";
      };

      signature.enabled = true;
    };
  };

  plugins.luasnip = {
    enable = true;
    fromVscode = [ { } ];
  };

  plugins.friendly-snippets.enable = true;
}
