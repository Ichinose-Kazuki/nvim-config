{ pkgs, ... }:
{
  # `dot` renders the current DOT buffer to a PNG that is then shown with
  # image.nvim (see plugins/image.nix).
  extraPackages = [ pkgs.graphviz ];

  extraConfigLua = ''
    -- Render the current DOT buffer to a PNG and show it in a floating window.
    function _G.graphviz_preview_dot()
      local file = vim.fn.expand("%:p")
      if file == "" then
        vim.notify("No file to render", vim.log.levels.WARN)
        return
      end
      local out = vim.fn.stdpath("cache") .. "/graphviz-preview-" .. vim.fn.getpid() .. ".png"
      local cmd = "dot -Tpng " .. vim.fn.shellescape(file) .. " -o " .. vim.fn.shellescape(out)
      local result = vim.fn.system(cmd)
      if vim.v.shell_error ~= 0 then
        vim.notify("dot failed:\n" .. result, vim.log.levels.ERROR)
        return
      end
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
      local img = require("image").from_file(out, { window = win })
      img:render()
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
