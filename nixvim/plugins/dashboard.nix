{ ... }:
{
  plugins.alpha = {
    enable = true;

    settings.layout = [
      {
        type = "padding";
        val = 8;
      }
      {
        type = "text";
        val = [
          "Neovim"
        ];
        opts = {
          hl = "Type";
          position = "center";
        };
      }
      {
        type = "padding";
        val = 2;
      }
      {
        type = "group";
        val = [
          {
            type = "button";
            val = "  Find File";
            on_press.__raw = "function() require('telescope.builtin').find_files() end";
            opts = {
              shortcut = "f";
              keymap = [
                "n"
                "f"
                ":Telescope find_files<CR>"
                {
                  noremap = true;
                  silent = true;
                }
              ];
              position = "center";
              cursor = 3;
              width = 40;
              align_shortcut = "right";
              hl_shortcut = "Keyword";
            };
          }
          {
            type = "padding";
            val = 1;
          }
          {
            type = "button";
            val = "  Recent Files";
            on_press.__raw = "function() require('telescope.builtin').oldfiles() end";
            opts = {
              shortcut = "r";
              keymap = [
                "n"
                "r"
                ":Telescope oldfiles<CR>"
                {
                  noremap = true;
                  silent = true;
                }
              ];
              position = "center";
              cursor = 3;
              width = 40;
              align_shortcut = "right";
              hl_shortcut = "Keyword";
            };
          }
          {
            type = "padding";
            val = 1;
          }
          {
            type = "button";
            val = "  New File";
            on_press.__raw = "function() vim.cmd('enew') end";
            opts = {
              shortcut = "n";
              keymap = [
                "n"
                "n"
                ":enew<CR>"
                {
                  noremap = true;
                  silent = true;
                }
              ];
              position = "center";
              cursor = 3;
              width = 40;
              align_shortcut = "right";
              hl_shortcut = "Keyword";
            };
          }
          {
            type = "padding";
            val = 1;
          }
          {
            type = "button";
            val = "  Quit";
            on_press.__raw = "function() vim.cmd('qa') end";
            opts = {
              shortcut = "q";
              keymap = [
                "n"
                "q"
                ":qa<CR>"
                {
                  noremap = true;
                  silent = true;
                }
              ];
              position = "center";
              cursor = 3;
              width = 40;
              align_shortcut = "right";
              hl_shortcut = "Keyword";
            };
          }
        ];
      }
    ];
  };
}
