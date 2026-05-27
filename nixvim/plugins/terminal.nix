{ ... }:
{
  plugins.toggleterm = {
    enable = true;

    settings = {
      size = 15;
      direction = "horizontal";
      shade_terminals = true;
      shading_factor = 2;
      start_in_insert = true;
      insert_mappings = true;
      persist_size = true;
      close_on_exit = true;
      shell.__raw = "vim.o.shell";
      float_opts = {
        border = "curved";
        winblend = 3;
      };
    };
  };

  keymaps = [
    # Toggle terminal (Ctrl+B like VSCode panel toggle)
    {
      mode = [
        "i"
        "t"
      ];
      key = "<C-b>";
      action = ":ToggleTerm<CR>";
      options = {
        silent = true;
        desc = "Toggle terminal";
      };
    }
    # New terminal (Ctrl+N)
    {
      mode = "n";
      key = "<C-n>";
      action.__raw = ''
        function()
          local count = vim.v.count1
          require("toggleterm").toggle(count + 1, nil, nil, "horizontal")
        end
      '';
      options = {
        silent = true;
        desc = "New terminal";
      };
    }
    # Easy exit terminal mode
    {
      mode = "t";
      key = "<Esc>";
      action = "<C-\\><C-n>";
      options = {
        silent = true;
        desc = "Exit terminal mode";
      };
    }
    {
      mode = "t";
      key = "<C-h>";
      action = "<C-\\><C-n><C-w>h";
      options = {
        silent = true;
        desc = "Window left from terminal";
      };
    }
    {
      mode = "t";
      key = "<C-j>";
      action = "<C-\\><C-n><C-w>j";
      options = {
        silent = true;
        desc = "Window down from terminal";
      };
    }
    {
      mode = "t";
      key = "<C-k>";
      action = "<C-\\><C-n><C-w>k";
      options = {
        silent = true;
        desc = "Window up from terminal";
      };
    }
    {
      mode = "t";
      key = "<C-l>";
      action = "<C-\\><C-n><C-w>l";
      options = {
        silent = true;
        desc = "Window right from terminal";
      };
    }
  ];
}
