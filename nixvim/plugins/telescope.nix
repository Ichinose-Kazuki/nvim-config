{ pkgs, inputs, ... }:
let
  telescope-live-grep-args = pkgs.vimUtils.buildVimPlugin {
    pname = "telescope-live-grep-args";
    version = "unstable";
    src = inputs.telescope-live-grep-args;
    doCheck = false;
  };
in
{
  extraPlugins =
    (with pkgs.vimPlugins; [
      smart-open-nvim
      sqlite-lua
    ])
    ++ [ telescope-live-grep-args ];

  extraConfigLua = ''
    local telescope = require("telescope")
    local lga_actions = require("telescope-live-grep-args.actions")

    telescope.setup({
      extensions = {
        live_grep_args = {
          auto_quoting = true,
          mappings = {
            i = {
              ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              ["<C-w>"] = lga_actions.quote_prompt({ postfix = " -w" }),
              ["<C-s>"] = lga_actions.quote_prompt({ postfix = " -s" }),
              ["<C-r>"] = lga_actions.quote_prompt({ postfix = " --fixed-strings" }),
              ["<C-h>"] = function(prompt_bufnr)
                local search = require("telescope.actions.state").get_current_line()
                require("telescope.actions").close(prompt_bufnr)
                require("grug-far").open({ prefills = { search = search } })
              end,
            },
          },
        },
      },
    })

    telescope.load_extension("smart_open")
    telescope.load_extension("live_grep_args")
  '';

  plugins.telescope = {
    enable = true;

    keymaps = {
      "<leader>ff" = {
        action = "find_files";
        options.desc = "Find files";
      };
      "<leader>fg" = {
        action = "live_grep";
        options.desc = "Live grep";
      };
      "<leader>fb" = {
        action = "buffers";
        options.desc = "Find buffers";
      };
      "<leader>fh" = {
        action = "help_tags";
        options.desc = "Help tags";
      };
      "<leader>fr" = {
        action = "oldfiles";
        options.desc = "Recent files";
      };
      "<leader>fc" = {
        action = "commands";
        options.desc = "Commands";
      };
      "<leader>fd" = {
        action = "diagnostics";
        options.desc = "Diagnostics";
      };
      "<leader>fs" = {
        action = "lsp_document_symbols";
        options.desc = "Document symbols";
      };
      "<leader>fw" = {
        action = "lsp_workspace_symbols";
        options.desc = "Workspace symbols";
      };
      "<leader>gc" = {
        action = "git_commits";
        options.desc = "Git commits";
      };
      "<leader>gb" = {
        action = "git_branches";
        options.desc = "Git branches";
      };
      "<leader><leader>" = {
        action = "smart_open";
        options.desc = "Smart open";
      };
    };

    settings = {
      extensions.smart_open = {
        match_algorithm = "fzf";
        show_scores = false;
      };

      defaults = {
        prompt_prefix = " ";
        selection_caret = "  ";
        entry_prefix = "  ";
        path_display = [ "truncate" ];
        file_ignore_patterns = [
          "node_modules"
          ".git/"
          "__pycache__"
        ];
        mappings.i = {
          "<C-j>".__raw = "require('telescope.actions').move_selection_next";
          "<C-k>".__raw = "require('telescope.actions').move_selection_previous";
          "<C-q>".__raw = "require('telescope.actions').send_to_qflist";
        };
      };
    };

    extensions = {
      fzf-native.enable = true;
      ui-select.enable = true;
    };
  };
}
