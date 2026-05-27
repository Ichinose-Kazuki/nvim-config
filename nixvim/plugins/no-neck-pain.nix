{ ... }:
{
  plugins.no-neck-pain = {
    enable = true;

    settings = {
      width = 120;
      autocmds = {
        enableOnVimEnter = true;
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>n";
      action = ":NoNeckPain<CR>";
      options = {
        silent = true;
        desc = "Toggle no-neck-pain";
      };
    }
  ];
}
