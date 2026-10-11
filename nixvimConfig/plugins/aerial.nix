{ ... }:
{
  plugins.aerial = {
    enable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>O";
      action = "<cmd>AerialToggle!<CR>";
      options = {
        silent = true;
        desc = "Toggle outline";
      };
    }
    {
      mode = "n";
      key = "]o";
      action = "<cmd>AerialNext<CR>";
      options = {
        silent = true;
        desc = "Next outline symbol";
      };
    }
    {
      mode = "n";
      key = "[o";
      action = "<cmd>AerialPrev<CR>";
      options = {
        silent = true;
        desc = "Prev outline symbol";
      };
    }
  ];
}
