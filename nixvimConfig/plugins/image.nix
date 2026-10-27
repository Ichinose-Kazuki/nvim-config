{ pkgs, ... }:
{
  # Install image.nvim directly and keep full control over its setup so that
  # the rendering backend can be selected at runtime (see extraConfigLua).
  # ImageMagick is required by the Sixel backend, so it must always be on PATH
  # regardless of which backend ends up being used.
  extraPlugins = [ pkgs.vimPlugins.image-nvim ];
  extraPackages = [ pkgs.imagemagick ];

  extraConfigLua = ''
    -- Choose the image rendering backend from the terminal that actually draws
    -- the image. Inside tmux the outer terminal's TERM name is masked, so we
    -- ask tmux for the client terminal name. Windows Terminal reports
    -- xterm-256color, while ghostty reports something kitty-like.
    local function image_detect_backend()
      if vim.env.TMUX and vim.env.TMUX ~= "" then
        local name = vim.trim(vim.fn.system({ "tmux", "display-message", "-p", "#{client_termname}" }))
        if name:lower() == "xterm-256color" then
          return "sixel"
        end
        return "kitty"
      end
      local term = (vim.env.TERM or ""):lower()
      local prog = (vim.env.TERM_PROGRAM or ""):lower()
      if term:find("kitty") or prog:find("kitty") or prog:find("ghostty") then
        return "kitty"
      end
      if term:find("sixel") or term:find("xterm-256color") then
        return "sixel"
      end
      return "kitty"
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
