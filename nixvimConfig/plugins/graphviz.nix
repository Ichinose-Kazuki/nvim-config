{ pkgs, ... }:
{
  # `dot` renders the current DOT buffer to a PNG that is then shown with
  # image.nvim (see plugins/image.nix).
  extraPackages = [ pkgs.graphviz ];

  extraConfigLua = ''
    -- Single reusable floating window so repeated previews update in place
    -- instead of stacking new windows.
    local graphviz_preview = {
      win = nil,
      buf = nil,
      img = nil,
      png = nil,
      src = nil,
    }

    function _G.graphviz_preview_dot()
      -- When the preview itself is focused, reuse the last source so that
      -- pressing the mapping again refreshes instead of being rejected.
      local src
      if graphviz_preview.buf and vim.api.nvim_get_current_buf() == graphviz_preview.buf then
        src = graphviz_preview.src
      elseif vim.bo.filetype == "dot" then
        src = vim.fn.expand("%:p")
      else
        vim.notify("Not a DOT file", vim.log.levels.WARN)
        return
      end
      if not src or src == "" then
        vim.notify("No file to render", vim.log.levels.WARN)
        return
      end

      local out = vim.fn.stdpath("cache")
        .. "/graphviz-preview-"
        .. vim.fn.getpid()
        .. "-"
        .. tostring(vim.uv.hrtime())
        .. ".png"
      local result = vim.fn.system("dot -Tpng " .. vim.fn.shellescape(src) .. " -o " .. vim.fn.shellescape(out))
      if vim.v.shell_error ~= 0 then
        pcall(vim.fn.delete, out)
        vim.notify("dot failed:\n" .. result, vim.log.levels.ERROR)
        return
      end

      -- Create the floating window once, then reuse it on later previews.
      if not (graphviz_preview.win and vim.api.nvim_win_is_valid(graphviz_preview.win)) then
        local buf = vim.api.nvim_create_buf(false, true)
        local width = math.floor(vim.o.columns * 0.6)
        local height = math.floor(vim.o.lines * 0.6)
        local win = vim.api.nvim_open_win(buf, true, {
          relative = "editor",
          width = width,
          height = height,
          row = math.floor((vim.o.lines - height) / 2),
          col = math.floor((vim.o.columns - width) / 2),
          style = "minimal",
          border = "rounded",
          title = "Graphviz preview",
          title_pos = "center",
        })
        vim.bo[buf].buftype = "nofile"
        vim.bo[buf].bufhidden = "wipe"
        graphviz_preview.buf = buf
        graphviz_preview.win = win
        graphviz_preview.img = nil
      elseif graphviz_preview.img then
        pcall(function() graphviz_preview.img:clear() end)
      end

      if graphviz_preview.png then
        pcall(vim.fn.delete, graphviz_preview.png)
      end
      local img = require("image").from_file(out, { window = graphviz_preview.win })
      img:render()
      graphviz_preview.img = img
      graphviz_preview.png = out
      graphviz_preview.src = src
    end
  '';

  keymaps = [
    # Preview the current DOT buffer as an image
    {
      mode = "n";
      key = "<leader>dg";
      action.__raw = "function() graphviz_preview_dot() end";
      options = {
        silent = true;
        desc = "Preview graph (dot -> image)";
      };
    }
  ];
}
