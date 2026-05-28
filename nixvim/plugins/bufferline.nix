{ lib, myNvimCfg, ... }:
{
  plugins = {
    bufferline = {
      enable = true;

      settings.options = {
        numbers = "none";
        diagnostics = "nvim_lsp";
        diagnostics_indicator.__raw = ''
          function(count, level)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
          end
        '';
        show_buffer_close_icons = true;
        show_close_icon = true;
        separator_style = "thin";
        always_show_bufferline = true;
        offsets =
          if myNvimCfg.fileExplorer == "neo-tree" then
            [
              {
                filetype = "neo-tree";
                text = "File Explorer";
                text_align = "left";
                separator = true;
              }
            ]
          else
            [ ];
      };
    };

    web-devicons.enable = true;
  };
}
