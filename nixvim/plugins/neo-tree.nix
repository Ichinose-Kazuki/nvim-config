{ lib, myNvimCfg, ... }:
lib.mkMerge [
  {
    plugins.neo-tree = {
      enable = true;

      settings = {
        close_if_last_window = true;
        log_level = "fatal";
        log_to_file = false;
        popup_border_style = "rounded";
        enable_git_status = false;
        enable_diagnostics = false;
        sources = [ "filesystem" ];

        window = {
          width = 30;
          mappings = {
            "<Esc>" = "close_window";
            "j".__raw = ''
              function(state)
                local line = vim.api.nvim_win_get_cursor(0)[1]
                local last = vim.api.nvim_buf_line_count(0)
                if line >= last then
                  vim.api.nvim_win_set_cursor(0, { 1, 0 })
                else
                  vim.api.nvim_win_set_cursor(0, { line + 1, 0 })
                end
              end
            '';
            "k".__raw = ''
              function(state)
                local line = vim.api.nvim_win_get_cursor(0)[1]
                if line <= 1 then
                  local last = vim.api.nvim_buf_line_count(0)
                  vim.api.nvim_win_set_cursor(0, { last, 0 })
                else
                  vim.api.nvim_win_set_cursor(0, { line - 1, 0 })
                end
              end
            '';
            "<Down>".__raw = ''
              function(state)
                local line = vim.api.nvim_win_get_cursor(0)[1]
                local last = vim.api.nvim_buf_line_count(0)
                if line >= last then
                  vim.api.nvim_win_set_cursor(0, { 1, 0 })
                else
                  vim.api.nvim_win_set_cursor(0, { line + 1, 0 })
                end
              end
            '';
            "<Up>".__raw = ''
              function(state)
                local line = vim.api.nvim_win_get_cursor(0)[1]
                if line <= 1 then
                  local last = vim.api.nvim_buf_line_count(0)
                  vim.api.nvim_win_set_cursor(0, { last, 0 })
                else
                  vim.api.nvim_win_set_cursor(0, { line - 1, 0 })
                end
              end
            '';
            "<leader>yf".__raw = ''
              function(state)
                local node = state.tree:get_node()
                vim.fn.setreg("+", node.name)
                vim.notify("Copied: " .. node.name)
              end
            '';
            "<leader>yp".__raw = ''
              function(state)
                local node = state.tree:get_node()
                vim.fn.setreg("+", node.path)
                vim.notify("Copied: " .. node.path)
              end
            '';
            "<leader>yr".__raw = ''
              function(state)
                local node = state.tree:get_node()
                local rel = vim.fn.fnamemodify(node.path, ":.")
                vim.fn.setreg("+", rel)
                vim.notify("Copied: " .. rel)
              end
            '';
            "?".__raw = ''
              function()
                vim.notify(
                  "Neo-tree keymaps:\n" ..
                  "  <leader>yf  Copy filename\n" ..
                  "  <leader>yp  Copy absolute path\n" ..
                  "  <leader>yr  Copy relative path\n" ..
                  "  <Esc>       Close",
                  vim.log.levels.INFO
                )
              end
            '';
          };
        };

        filesystem = {
          follow_current_file.enabled = true;
          use_libuv_file_watcher = true;
          filtered_items = {
            visible = false;
            hide_hidden = false;
            hide_dotfiles = false;
            hide_gitignored = true;
          };
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>E";
        action = ":Neotree toggle<CR>";
        options = {
          silent = true;
          desc = "Toggle tree explorer";
        };
      }
    ];
  }

  (lib.mkIf (myNvimCfg.fileExplorer == "oil") {
    plugins.oil = {
      enable = true;

      settings = {
        default_file_explorer = true;
        columns = [ "icon" ];
        skip_confirm_for_simple_edits = true;
        view_options = {
          show_hidden = true;
        };
        keymaps = {
          "<Esc>" = "actions.close";
          "j".__raw = ''
            function()
              local line = vim.api.nvim_win_get_cursor(0)[1]
              local last = vim.api.nvim_buf_line_count(0)
              if line >= last then
                vim.api.nvim_win_set_cursor(0, { 1, 0 })
              else
                vim.api.nvim_win_set_cursor(0, { line + 1, 0 })
              end
            end
          '';
          "k".__raw = ''
            function()
              local line = vim.api.nvim_win_get_cursor(0)[1]
              if line <= 1 then
                local last = vim.api.nvim_buf_line_count(0)
                vim.api.nvim_win_set_cursor(0, { last, 0 })
              else
                vim.api.nvim_win_set_cursor(0, { line - 1, 0 })
              end
            end
          '';
          "<Down>".__raw = ''
            function()
              local line = vim.api.nvim_win_get_cursor(0)[1]
              local last = vim.api.nvim_buf_line_count(0)
              if line >= last then
                vim.api.nvim_win_set_cursor(0, { 1, 0 })
              else
                vim.api.nvim_win_set_cursor(0, { line + 1, 0 })
              end
            end
          '';
          "<Up>".__raw = ''
            function()
              local line = vim.api.nvim_win_get_cursor(0)[1]
              if line <= 1 then
                local last = vim.api.nvim_buf_line_count(0)
                vim.api.nvim_win_set_cursor(0, { last, 0 })
              else
                vim.api.nvim_win_set_cursor(0, { line - 1, 0 })
              end
            end
          '';
          "<leader>yf".__raw = ''
            function()
              local oil = require("oil")
              local entry = oil.get_cursor_entry()
              if entry then
                vim.fn.setreg("+", entry.name)
                vim.notify("Copied: " .. entry.name)
              end
            end
          '';
          "<leader>yp".__raw = ''
            function()
              local oil = require("oil")
              local entry = oil.get_cursor_entry()
              local dir = oil.get_current_dir()
              if entry and dir then
                local path = dir .. entry.name
                vim.fn.setreg("+", path)
                vim.notify("Copied: " .. path)
              end
            end
          '';
          "<leader>yr".__raw = ''
            function()
              local oil = require("oil")
              local entry = oil.get_cursor_entry()
              local dir = oil.get_current_dir()
              if entry and dir then
                local rel = vim.fn.fnamemodify(dir .. entry.name, ":.")
                vim.fn.setreg("+", rel)
                vim.notify("Copied: " .. rel)
              end
            end
          '';
          "?".__raw = ''
            function()
              vim.notify(
                "Oil keymaps:\n" ..
                "  <leader>yf  Copy filename\n" ..
                "  <leader>yp  Copy absolute path\n" ..
                "  <leader>yr  Copy relative path\n" ..
                "  <CR>        Open file (in right window if split)\n" ..
                "  <Esc>       Close",
                vim.log.levels.INFO
              )
            end
          '';
          "<CR>".__raw = ''
            function()
              local oil = require("oil")
              local entry = oil.get_cursor_entry()
              if not entry then return end

              if entry.type == "directory" then
                oil.select()
                return
              end

              local dir = oil.get_current_dir()
              if not dir then return oil.select() end

              local cur_win = vim.api.nvim_get_current_win()
              vim.cmd("wincmd l")
              local target_win = vim.api.nvim_get_current_win()

              if target_win == cur_win then
                oil.select()
              else
                vim.cmd("edit " .. vim.fn.fnameescape(dir .. entry.name))
              end
            end
          '';
        };
      };
    };

    autoCmd = [
      {
        event = "BufLeave";
        group = "OilRelPathFix";
        pattern = "oil:///*";
        callback.__raw = ''function() vim.cmd("cd .") end'';
      }
    ];

    autoGroups.OilRelPathFix = { };

    keymaps = [
      {
        mode = "n";
        key = "<leader>e";
        action.__raw = ''function() require("oil").toggle_float() end'';
        options = {
          silent = true;
          desc = "Toggle file explorer";
        };
      }
      {
        mode = "n";
        key = "<leader>o";
        action.__raw = ''function() require("oil").open() end'';
        options = {
          silent = true;
          desc = "Open file explorer";
        };
      }
    ];
  })
]
