{ lib, pkgs, inputs, myNvimCfg, ... }:
let
  gitgraph-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "gitgraph-nvim";
    version = "unstable";
    src = inputs.git-graph-nvim;
  };
in
lib.mkIf myNvimCfg.plugins.git.enable {
  plugins.neogit = {
    enable = true;

    settings = {
      kind = "tab";
      commit_view.kind = "vsplit";
      preview_buffer.kind = "split";
      integrations.diffview = true;
      disable_builtin_notifications = true;
      sections = {
        untracked = {
          folded = false;
          hidden = false;
        };
        unstaged = {
          folded = false;
          hidden = false;
        };
        staged = {
          folded = false;
          hidden = false;
        };
        stashes = {
          folded = true;
          hidden = false;
        };
        unpulled_upstream = {
          folded = true;
          hidden = false;
        };
        unmerged_upstream = {
          folded = true;
          hidden = false;
        };
      };
    };
  };

  plugins.diffview = {
    enable = true;
    settings = {
      enhanced_diff_hl = true;
      view = {
        default.layout = "diff2_horizontal";
        merge_tool.layout = "diff3_horizontal";
      };
    };
  };

  plugins.gitsigns = {
    enable = true;

    settings = {
      signs = {
        add.text = "│";
        change.text = "│";
        delete.text = "_";
        topdelete.text = "‾";
        changedelete.text = "~";
        untracked.text = "┆";
      };
      signs_staged_enable = true;
      current_line_blame = false;
      current_line_blame_opts = {
        virt_text = true;
        delay = 1000;
      };
    };
  };

  extraPlugins = [ gitgraph-nvim ];

  extraConfigLua = ''
    require("gitgraph").setup({
      symbols = {
        merge_commit = "M",
        commit = "*",
      },
      format = {
        timestamp = "%H:%M:%S %d-%m-%Y",
        fields = { "hash", "timestamp", "author", "branch_name", "tag" },
      },
    })
  '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>gl";
      action.__raw = ''function() require("gitgraph").draw({}, { all = true, max_count = 5000 }) end'';
      options = {
        silent = true;
        desc = "Git graph";
      };
    }
    {
      mode = "n";
      key = "<leader>gg";
      action = ":Neogit<CR>";
      options = {
        silent = true;
        desc = "Open git panel";
      };
    }
    {
      mode = "n";
      key = "<C-g>";
      action = ":Neogit<CR>";
      options = {
        silent = true;
        desc = "Open git panel";
      };
    }
    {
      mode = "n";
      key = "<leader>gd";
      action = ":DiffviewOpen<CR>";
      options = {
        silent = true;
        desc = "Open diff view";
      };
    }
    {
      mode = "n";
      key = "<leader>gD";
      action = ":DiffviewClose<CR>";
      options = {
        silent = true;
        desc = "Close diff view";
      };
    }
    {
      mode = "n";
      key = "<leader>gh";
      action = ":DiffviewFileHistory %<CR>";
      options = {
        silent = true;
        desc = "File git history";
      };
    }

    # Hunk navigation
    {
      mode = "n";
      key = "]h";
      action.__raw = "function() require('gitsigns').next_hunk() end";
      options = {
        desc = "Next git hunk";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "[h";
      action.__raw = "function() require('gitsigns').prev_hunk() end";
      options = {
        desc = "Prev git hunk";
        silent = true;
      };
    }

    # Hunk actions
    {
      mode = "n";
      key = "<leader>hs";
      action.__raw = "function() require('gitsigns').stage_hunk() end";
      options = {
        desc = "Stage hunk";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>hr";
      action.__raw = "function() require('gitsigns').reset_hunk() end";
      options = {
        desc = "Reset hunk";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>hS";
      action.__raw = "function() require('gitsigns').stage_buffer() end";
      options = {
        desc = "Stage buffer";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>hR";
      action.__raw = "function() require('gitsigns').reset_buffer() end";
      options = {
        desc = "Reset buffer";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>hp";
      action.__raw = "function() require('gitsigns').preview_hunk() end";
      options = {
        desc = "Preview hunk";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>hb";
      action.__raw = "function() require('gitsigns').blame_line({ full = true }) end";
      options = {
        desc = "Blame line";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>tb";
      action.__raw = "function() require('gitsigns').toggle_current_line_blame() end";
      options = {
        desc = "Toggle line blame";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>hd";
      action.__raw = "function() require('gitsigns').diffthis() end";
      options = {
        desc = "Diff this";
        silent = true;
      };
    }
  ];
}
