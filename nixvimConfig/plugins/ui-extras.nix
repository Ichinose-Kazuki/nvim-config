{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
let
  namu-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "namu-nvim";
    version = "unstable";
    src = inputs.namu-nvim;
  };

  nvim-scrollbar = pkgs.vimUtils.buildVimPlugin {
    pname = "nvim-scrollbar";
    version = "unstable";
    src = inputs.nvim-scrollbar;
  };

  incline-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "incline-nvim";
    version = "unstable";
    src = inputs.incline-nvim;
  };
in
{
  opts = {
    foldenable = true;
    foldlevel = 99;
    foldlevelstart = 99;
    foldcolumn = "1";
  };

  plugins = {
    nvim-ufo = {
      enable = true;
      settings = {
        provider_selector.__raw = ''
          function(bufnr, filetype, buftype)
            return { "treesitter", "indent" }
          end
        '';
        close_fold_kinds_for_ft.default = [
          "imports"
          "comment"
        ];
      };
    };

    markview = {
      enable = true;
      settings = {
        preview = {
          modes = [
            "n"
            "no"
            "i"
          ];
          hybrid_modes = [ "i" ];
        };
      };
    };
  };

  extraPlugins =
    (with pkgs.vimPlugins; [
      glance-nvim
      tiny-inline-diagnostic-nvim
    ])
    ++ [
      namu-nvim
      nvim-scrollbar
      incline-nvim
    ];

  extraConfigLua = ''
    -- incline.nvim
    require("incline").setup({
      window = {
        padding = 0,
        margin = { horizontal = 0 },
      },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        if filename == "" then filename = "[No Name]" end
        local modified = vim.bo[props.buf].modified
        return {
          { " " .. filename .. " ", gui = props.focused and "bold" or nil },
          modified and { " ● ", guifg = "#e0af68" } or "",
        }
      end,
    })

    -- glance.nvim
    require("glance").setup({
      border = { enable = true },
      height = 18,
    })

    -- namu.nvim
    require("namu").setup({
      namu_symbols = {
        enable = true,
        options = {
          movement = { next = "<C-n>", prev = "<C-p>" },
        },
      },
    })

    -- nvim-scrollbar
    require("scrollbar").setup({
      handle = { color = "#3b4261" },
      marks = {
        Search = { color = "#ff9e64" },
        Error = { color = "#db4b4b" },
        Warn = { color = "#e0af68" },
        Info = { color = "#0db9d7" },
        Hint = { color = "#1abc9c" },
        Misc = { color = "#9d7cd8" },
      },
      handlers = {
        diagnostic = true,
        search = false,
        gitsigns = true,
      },
    })

    -- tiny-inline-diagnostic
    require("tiny-inline-diagnostic").setup({
      preset = "modern",
      options = {
        show_source = true,
        multilines = true,
      },
    })
    vim.diagnostic.config({ virtual_text = false })
  '';

  keymaps = [
    # nvim-ufo
    {
      mode = "n";
      key = "zR";
      action.__raw = ''function() require("ufo").openAllFolds() end'';
      options = {
        silent = true;
        desc = "Open all folds";
      };
    }
    {
      mode = "n";
      key = "zM";
      action.__raw = ''function() require("ufo").closeAllFolds() end'';
      options = {
        silent = true;
        desc = "Close all folds";
      };
    }
    {
      mode = "n";
      key = "zK";
      action.__raw = ''function() require("ufo").peekFoldedLinesUnderCursor() end'';
      options = {
        silent = true;
        desc = "Peek fold";
      };
    }

    # glance.nvim
    {
      mode = "n";
      key = "gpd";
      action = ":Glance definitions<CR>";
      options = {
        silent = true;
        desc = "Glance definitions";
      };
    }
    {
      mode = "n";
      key = "gpr";
      action = ":Glance references<CR>";
      options = {
        silent = true;
        desc = "Glance references";
      };
    }
    {
      mode = "n";
      key = "gpt";
      action = ":Glance type_definitions<CR>";
      options = {
        silent = true;
        desc = "Glance type definitions";
      };
    }
    {
      mode = "n";
      key = "gpi";
      action = ":Glance implementations<CR>";
      options = {
        silent = true;
        desc = "Glance implementations";
      };
    }

    # namu.nvim
    {
      mode = "n";
      key = "<leader>ss";
      action.__raw = ''function() require("namu.namu_symbols").show() end'';
      options = {
        silent = true;
        desc = "Symbol search (namu)";
      };
    }
  ];
}
