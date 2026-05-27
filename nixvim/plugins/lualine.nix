{ config, lib, ... }:
let
  cfg = config.myNvim;
in
{
  plugins.lualine = {
    enable = true;

    settings = {
      options = {
        theme = "auto";
        component_separators = {
          left = "";
          right = "";
        };
        section_separators = {
          left = "";
          right = "";
        };
        globalstatus = true;
        disabled_filetypes = {
          statusline =
            if cfg.fileExplorer == "neo-tree" then
              [
                "dashboard"
                "alpha"
                "neo-tree"
              ]
            else
              [
                "dashboard"
                "alpha"
              ];
        };
      };

      sections = {
        lualine_a = [ "mode" ];
        lualine_b = [
          "branch"
          "diff"
          "diagnostics"
        ];
        lualine_c = [
          {
            __unkeyed-1 = "filename";
            path = 1;
          }
        ];
        lualine_x = [
          "encoding"
          "fileformat"
          "filetype"
        ];
        lualine_y = [ "progress" ];
        lualine_z = [ "location" ];
      };

      inactive_sections = {
        lualine_a = [ ];
        lualine_b = [ ];
        lualine_c = [ "filename" ];
        lualine_x = [ "location" ];
        lualine_y = [ ];
        lualine_z = [ ];
      };
    };
  };
}
