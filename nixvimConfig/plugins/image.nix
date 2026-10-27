{ pkgs, ... }:
{
  # Install image.nvim directly and keep full control over its setup so that
  # the rendering backend can be selected at runtime (see extraConfigLua).
  # ImageMagick is required by the Sixel backend, so it must always be on PATH
  # regardless of which backend ends up being used.
  extraPlugins = [ pkgs.vimPlugins.image-nvim ];
  extraPackages = [ pkgs.imagemagick ];

  extraConfigLua = ''
    -- Allow Kitty/Sixel graphics to reach the outer terminal through tmux for
    -- this pane only. image.nvim caches the passthrough state when its tmux
    -- utility is first required, so this must run before require("image")
    -- below; otherwise the Kitty backend throws.
    if vim.env.TMUX and vim.env.TMUX_PANE then
      vim.fn.system({ "tmux", "set", "-p", "-t", vim.env.TMUX_PANE, "allow-passthrough", "all" })
      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          vim.fn.system({ "tmux", "set", "-p", "-u", "-t", vim.env.TMUX_PANE, "allow-passthrough" })
        end,
      })
    end

    -- Map a terminal name to the rendering backend. ghostty reports
    -- xterm-ghostty (Kitty graphics) and Windows Terminal reports
    -- xterm-256color (Sixel).
    function _G.image_backend_from_name(name)
      name = (name or ""):lower()
      if name:find("ghostty", 1, true) or name:find("kitty", 1, true) then
        return "kitty"
      end
      if name:find("xterm-256color", 1, true) or name:find("sixel", 1, true) then
        return "sixel"
      end
      return "kitty"
    end

    -- Choose the image rendering backend from the terminal that actually draws
    -- the image. Inside tmux the outer terminal's TERM name is masked, so we
    -- ask tmux for the client terminal name.
    local function image_detect_backend()
      if vim.env.TMUX and vim.env.TMUX ~= "" then
        local name = vim.trim(vim.fn.system({ "tmux", "display-message", "-p", "#{client_termname}" }))
        return image_backend_from_name(name)
      end
      local term = vim.env.TERM or ""
      local prog = vim.env.TERM_PROGRAM or ""
      return image_backend_from_name(term .. " " .. prog)
    end

    -- Per-integration rendering for document images. Only render the image
    -- under the cursor and show it in a popup, which keeps Sixel usable on
    -- slower terminals. These apply to document integrations (markdown below),
    -- not to floating previews created directly with image.from_file.
    local image_integrations = {
      markdown = {
        only_render_image_at_cursor = true,
        only_render_image_at_cursor_mode = "popup",
      },
    }

    local function image_config(backend)
      return {
        backend = backend,
        -- Images inside tmux must be positioned with unicode placeholders so
        -- tmux can relay them as text cells.
        kitty_method = "unicode-placeholders",
        -- Neither focus tracking nor per-window hiding is needed, which also
        -- removes the requirement for tmux focus-events.
        tmux_show_only_in_active_window = false,
        editor_only_render_when_focused = false,
        -- Open matching image files directly with image.nvim instead of showing
        -- their binary contents.
        hijack_file_patterns = {
          "*.png",
          "*.jpg",
          "*.jpeg",
          "*.gif",
          "*.webp",
          "*.avif",
          "*.bmp",
          "*.tiff",
          "*.tif",
        },
        integrations = image_integrations,
      }
    end

    local function image_set_backend(backend)
      backend = backend == "sixel" and "sixel" or "kitty"
      require("image").setup(image_config(backend))
      vim.notify("Image rendering backend: " .. backend)
    end

    image_set_backend(image_detect_backend())

    vim.api.nvim_create_user_command("GraphBackend", function(args)
      image_set_backend(args.args)
    end, {
      nargs = 1,
      complete = function()
        return { "kitty", "sixel" }
      end,
    })
  '';
}
