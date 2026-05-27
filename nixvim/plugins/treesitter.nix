{ ... }:
{
  plugins = {
    treesitter = {
      enable = true;
      settings = {
        auto_install = false;
        highlight.enable = true;
        indent.enable = true;
        ensure_installed = [
          "bash"
          "c"
          "cpp"
          "css"
          "html"
          "javascript"
          "json"
          "lua"
          "luadoc"
          "markdown"
          "markdown_inline"
          "nix"
          "python"
          "query"
          "regex"
          "toml"
          "tsx"
          "typescript"
          "vim"
          "vimdoc"
          "yaml"
        ];
      };
    };

    treesitter-context = {
      enable = true;
      settings = {
        max_lines = 3;
        trim_scope = "outer";
      };
    };

    treesitter-textobjects = {
      enable = true;
      settings = {
        enable = true;
        lookahead = true;
      };
    };
  };

  keymaps =
    let
      sel = q: ''function() require("nvim-treesitter-textobjects.select").select_textobject("${q}") end'';
      next_s = q: ''function() require("nvim-treesitter-textobjects.move").goto_next_start("${q}") end'';
      next_e = q: ''function() require("nvim-treesitter-textobjects.move").goto_next_end("${q}") end'';
      prev_s =
        q: ''function() require("nvim-treesitter-textobjects.move").goto_previous_start("${q}") end'';
      prev_e =
        q: ''function() require("nvim-treesitter-textobjects.move").goto_previous_end("${q}") end'';
      swap_n = q: ''function() require("nvim-treesitter-textobjects.swap").swap_next("${q}") end'';
      swap_p = q: ''function() require("nvim-treesitter-textobjects.swap").swap_previous("${q}") end'';
    in
    [
      # Textobject selection
      {
        mode = [
          "x"
          "o"
        ];
        key = "af";
        action.__raw = sel "@function.outer";
        options = {
          silent = true;
          desc = "Select outer function";
        };
      }
      {
        mode = [
          "x"
          "o"
        ];
        key = "if";
        action.__raw = sel "@function.inner";
        options = {
          silent = true;
          desc = "Select inner function";
        };
      }
      {
        mode = [
          "x"
          "o"
        ];
        key = "ac";
        action.__raw = sel "@class.outer";
        options = {
          silent = true;
          desc = "Select outer class";
        };
      }
      {
        mode = [
          "x"
          "o"
        ];
        key = "ic";
        action.__raw = sel "@class.inner";
        options = {
          silent = true;
          desc = "Select inner class";
        };
      }
      {
        mode = [
          "x"
          "o"
        ];
        key = "aa";
        action.__raw = sel "@parameter.outer";
        options = {
          silent = true;
          desc = "Select outer parameter";
        };
      }
      {
        mode = [
          "x"
          "o"
        ];
        key = "ia";
        action.__raw = sel "@parameter.inner";
        options = {
          silent = true;
          desc = "Select inner parameter";
        };
      }

      # Move to next/prev function/class
      {
        mode = "n";
        key = "]m";
        action.__raw = next_s "@function.outer";
        options = {
          silent = true;
          desc = "Next function start";
        };
      }
      {
        mode = "n";
        key = "]M";
        action.__raw = next_e "@function.outer";
        options = {
          silent = true;
          desc = "Next function end";
        };
      }
      {
        mode = "n";
        key = "]]";
        action.__raw = next_s "@class.outer";
        options = {
          silent = true;
          desc = "Next class start";
        };
      }
      {
        mode = "n";
        key = "][";
        action.__raw = next_e "@class.outer";
        options = {
          silent = true;
          desc = "Next class end";
        };
      }
      {
        mode = "n";
        key = "[m";
        action.__raw = prev_s "@function.outer";
        options = {
          silent = true;
          desc = "Prev function start";
        };
      }
      {
        mode = "n";
        key = "[M";
        action.__raw = prev_e "@function.outer";
        options = {
          silent = true;
          desc = "Prev function end";
        };
      }
      {
        mode = "n";
        key = "[[";
        action.__raw = prev_s "@class.outer";
        options = {
          silent = true;
          desc = "Prev class start";
        };
      }
      {
        mode = "n";
        key = "[]";
        action.__raw = prev_e "@class.outer";
        options = {
          silent = true;
          desc = "Prev class end";
        };
      }

      # Swap parameters
      {
        mode = "n";
        key = "<leader>a";
        action.__raw = swap_n "@parameter.inner";
        options = {
          silent = true;
          desc = "Swap next parameter";
        };
      }
      {
        mode = "n";
        key = "<leader>A";
        action.__raw = swap_p "@parameter.inner";
        options = {
          silent = true;
          desc = "Swap prev parameter";
        };
      }
    ];
}
