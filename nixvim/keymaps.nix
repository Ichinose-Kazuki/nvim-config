{ ... }:
{
  keymaps = [
    # Window navigation
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
      options.desc = "Go to left window";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      options.desc = "Go to lower window";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      options.desc = "Go to upper window";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      options.desc = "Go to right window";
    }

    # Resize windows
    {
      mode = "n";
      key = "<C-Up>";
      action = ":resize -2<CR>";
      options = {
        silent = true;
        desc = "Resize window up";
      };
    }
    {
      mode = "n";
      key = "<C-Down>";
      action = ":resize +2<CR>";
      options = {
        silent = true;
        desc = "Resize window down";
      };
    }
    {
      mode = "n";
      key = "<C-Left>";
      action = ":vertical resize -2<CR>";
      options = {
        silent = true;
        desc = "Resize window left";
      };
    }
    {
      mode = "n";
      key = "<C-Right>";
      action = ":vertical resize +2<CR>";
      options = {
        silent = true;
        desc = "Resize window right";
      };
    }

    # Buffer/window management
    {
      mode = "n";
      key = "<S-l>";
      action = ":bnext<CR>";
      options = {
        silent = true;
        desc = "Next buffer";
      };
    }
    {
      mode = "n";
      key = "<S-h>";
      action = ":bprevious<CR>";
      options = {
        silent = true;
        desc = "Prev buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>bd";
      action = ":bdelete<CR>";
      options = {
        silent = true;
        desc = "Delete buffer";
      };
    }
    {
      mode = "n";
      key = "<C-b>";
      action = ":bdelete<CR>";
      options = {
        silent = true;
        desc = "Close buffer";
      };
    }
    {
      mode = "n";
      key = "<C-w>";
      action = ":close<CR>";
      options = {
        silent = true;
        desc = "Close window";
      };
    }
    {
      mode = "n";
      key = "<C-t>";
      action = ":tabclose<CR>";
      options = {
        silent = true;
        desc = "Close tab";
      };
    }

    # Clear search highlights
    {
      mode = "n";
      key = "<leader>nh";
      action = ":nohl<CR>";
      options = {
        silent = true;
        desc = "Clear search highlights";
      };
    }

    # Stay in indent mode after visual indent
    {
      mode = "v";
      key = "<";
      action = "<gv";
    }
    {
      mode = "v";
      key = ">";
      action = ">gv";
    }

    # Move selected lines
    {
      mode = "v";
      key = "<A-j>";
      action = ":m .+1<CR>==";
      options = {
        silent = true;
        desc = "Move line down";
      };
    }
    {
      mode = "v";
      key = "<A-k>";
      action = ":m .-2<CR>==";
      options = {
        silent = true;
        desc = "Move line up";
      };
    }

    # Don't overwrite register on paste in visual
    {
      mode = "v";
      key = "p";
      action = ''"_dP'';
      options.desc = "Paste without overwriting register";
    }
    # Ctrl+C — copy in visual mode, yank line in insert mode
    {
      mode = "v";
      key = "<C-c>";
      action = ''"+y'';
      options = {
        silent = true;
        desc = "Copy to clipboard";
      };
    }
    {
      mode = "i";
      key = "<C-c>";
      action = ''<Esc>"+yya'';
      options = {
        silent = true;
        desc = "Yank line to clipboard";
      };
    }
    # Ctrl+V — paste in insert mode
    {
      mode = "i";
      key = "<C-v>";
      action = "<C-r>+";
      options = {
        silent = true;
        desc = "Paste from clipboard";
      };
    }

    # VSCode-style shortcuts
    # Ctrl+P — find file by name
    {
      mode = [
        "n"
        "i"
      ];
      key = "<C-p>";
      action = ":Telescope find_files<CR>";
      options = {
        silent = true;
        desc = "Find files";
      };
    }
    # Ctrl+F — live grep args (normal)
    {
      mode = "n";
      key = "<C-f>";
      action.__raw = ''
        function()
          require("telescope").extensions.live_grep_args.live_grep_args({
            additional_args = { "--hidden", "--no-ignore", "--fixed-strings" },
            prompt_title = "Live Grep [C-w:word C-s:case C-r:regex C-h:replace C-i:glob]",
          })
        end
      '';
      options = {
        silent = true;
        desc = "Live grep (all files)";
      };
    }
    {
      mode = "i";
      key = "<C-f>";
      action = "<Esc>:Telescope current_buffer_fuzzy_find<CR>";
      options = {
        silent = true;
        desc = "Search in file";
      };
    }
    # Ctrl+H — substitute (insert only)
    {
      mode = "i";
      key = "<C-h>";
      action = "<Esc>:%s/";
      options = {
        silent = false;
        desc = "Find and replace";
      };
    }
    # Ctrl+L — select line
    {
      mode = "i";
      key = "<C-l>";
      action = "<Esc>V";
      options = {
        silent = true;
        desc = "Select line";
      };
    }

    # Toggle comment
    {
      mode = "n";
      key = "<C-/>";
      action = "gcc";
      options = {
        silent = true;
        desc = "Toggle comment";
        remap = true;
      };
    }
    {
      mode = "v";
      key = "<C-/>";
      action = "gc";
      options = {
        silent = true;
        desc = "Toggle comment";
        remap = true;
      };
    }
    {
      mode = "i";
      key = "<C-/>";
      action = "<Esc>gcca";
      options = {
        silent = true;
        desc = "Toggle comment";
        remap = true;
      };
    }

    # Save file (format then write)
    {
      mode = [
        "n"
        "i"
      ];
      key = "<C-s>";
      action.__raw = ''
        function()
          require("conform").format({ async = false, lsp_fallback = true, timeout_ms = 500 })
          vim.cmd("write")
        end
      '';
      options = {
        silent = true;
        desc = "Format and save";
      };
    }

    # Quit
    {
      mode = "n";
      key = "<leader>q";
      action = ":q<CR>";
      options = {
        silent = true;
        desc = "Quit";
      };
    }
    {
      mode = "n";
      key = "<leader>Q";
      action = ":qa!<CR>";
      options = {
        silent = true;
        desc = "Quit all";
      };
    }

    # New/split windows
    {
      mode = "n";
      key = "<leader>wv";
      action = ":vsplit<CR>";
      options = {
        silent = true;
        desc = "Split vertical";
      };
    }
    {
      mode = "n";
      key = "<leader>wh";
      action = ":split<CR>";
      options = {
        silent = true;
        desc = "Split horizontal";
      };
    }
    {
      mode = "n";
      key = "<leader>we";
      action = "<C-w>=";
      options = {
        silent = true;
        desc = "Equal window sizes";
      };
    }
    {
      mode = "n";
      key = "<leader>wx";
      action = ":close<CR>";
      options = {
        silent = true;
        desc = "Close window";
      };
    }
  ];
}
