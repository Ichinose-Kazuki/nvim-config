{ myNvimCfg, ... }:
let
  scheme = myNvimCfg.colorscheme;
in
{
  colorschemes.vscode = {
    enable = scheme == "vscode";
    settings = {
      style = "dark";
      italic_comments = true;
      italic_inlayhints = true;
      underline_links = true;
      terminal_colors = true;
    };
  };

  colorschemes.tokyonight = {
    enable = scheme == "tokyonight";
    settings = {
      style = "night";
      italic_comments = true;
      terminal_colors = true;
    };
  };

  colorschemes.catppuccin = {
    enable = scheme == "catppuccin";
    settings = {
      flavour = "mocha";
      term_colors = true;
    };
  };
}
