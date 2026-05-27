{ ... }:
{
  plugins.zen-mode = {
    enable = true;

    settings = {
      window = {
        backdrop = 0.95;
        width = 120;
        height = 1;
        options = {
          signcolumn = "no";
          number = false;
          relativenumber = false;
          cursorline = false;
          foldcolumn = "0";
        };
      };
      plugins = {
        options = {
          enabled = true;
          ruler = false;
          showcmd = false;
        };
        tmux.enabled = false;
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>z";
      action = ":ZenMode<CR>";
      options = {
        silent = true;
        desc = "Toggle zen mode";
      };
    }
    {
      mode = [
        "n"
        "i"
      ];
      key = "<C-z>";
      action = ":ZenMode<CR>";
      options = {
        silent = true;
        desc = "Toggle zen mode";
      };
    }
  ];
}
