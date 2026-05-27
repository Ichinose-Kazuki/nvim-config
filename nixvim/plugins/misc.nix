{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.myNvim;

  nvim-spectre = pkgs.vimUtils.buildVimPlugin {
    pname = "nvim-spectre";
    version = "unstable";
    src = inputs.nvim-spectre;
    doCheck = false;
  };

  grug-far-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "grug-far-nvim";
    version = "unstable";
    src = inputs.grug-far-nvim;
  };
in
{
  extraPlugins = [
    nvim-spectre
    grug-far-nvim
  ];

  extraConfigLua = ''
    require("spectre").setup({
      open_cmd = "noswapfile vnew",
    })
    require("grug-far").setup({})
  '';
  plugins = {
    nvim-autopairs = {
      enable = true;
      settings = {
        check_ts = true;
        ts_config = {
          lua = [
            "string"
            "source"
          ];
          javascript = [
            "string"
            "template_string"
          ];
        };
        fast_wrap = {
          map = "<M-e>";
        };
      };
    };

    comment = {
      enable = true;
      settings = {
        toggler = {
          line = "gcc";
          block = "gbc";
        };
        opleader = {
          line = "gc";
          block = "gb";
        };
      };
    };

    indent-blankline = {
      enable = true;
      settings = {
        indent.char = "│";
        scope = {
          enabled = true;
          show_start = true;
          show_end = false;
        };
        exclude.filetypes =
          if cfg.fileExplorer == "neo-tree" then
            [
              "help"
              "dashboard"
              "neo-tree"
              "lazy"
              "mason"
              "notify"
            ]
          else
            [
              "help"
              "dashboard"
              "oil"
              "lazy"
              "mason"
              "notify"
            ];
      };
    };

    todo-comments = {
      enable = true;
      settings = {
        signs = true;
        keywords = {
          FIX = {
            icon = " ";
            color = "error";
            alt = [
              "FIXME"
              "BUG"
              "FIXIT"
              "ISSUE"
            ];
          };
          TODO = {
            icon = " ";
            color = "info";
          };
          HACK = {
            icon = " ";
            color = "warning";
          };
          WARN = {
            icon = " ";
            color = "warning";
            alt = [
              "WARNING"
              "XXX"
            ];
          };
          PERF = {
            icon = " ";
            alt = [
              "OPTIM"
              "PERFORMANCE"
              "OPTIMIZE"
            ];
          };
          NOTE = {
            icon = " ";
            color = "hint";
            alt = [ "INFO" ];
          };
        };
      };
    };

    flash = {
      enable = true;
      settings = {
        modes = {
          search.enabled = true;
          char = {
            jump_labels = true;
          };
        };
      };
    };

    notify = {
      enable = true;
      settings = {
        timeout = 5000;
        top_down = false;
        stages = "static";
      };
    };

    noice = {
      enable = true;
      settings = {
        lsp.override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
          "cmp.entry.get_documentation" = true;
        };
        presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
          inc_rename = false;
        };
      };
    };
  };

  keymaps = [
    # Flash jump
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "s";
      action.__raw = "function() require('flash').jump() end";
      options = {
        desc = "Flash jump";
        silent = true;
      };
    }
    {
      mode = [
        "n"
        "x"
        "o"
      ];
      key = "S";
      action.__raw = "function() require('flash').treesitter() end";
      options = {
        desc = "Flash treesitter";
        silent = true;
      };
    }
    # Todo-comments navigation
    {
      mode = "n";
      key = "]t";
      action.__raw = "function() require('todo-comments').jump_next() end";
      options = {
        desc = "Next todo";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "[t";
      action.__raw = "function() require('todo-comments').jump_prev() end";
      options = {
        desc = "Prev todo";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ft";
      action = ":TodoTelescope<CR>";
      options = {
        desc = "Find todos";
        silent = true;
      };
    }
    # Noice dismiss
    {
      mode = "n";
      key = "<leader>nd";
      action = ":NoiceDismiss<CR>";
      options = {
        desc = "Dismiss notifications";
        silent = true;
      };
    }
  ];
}
