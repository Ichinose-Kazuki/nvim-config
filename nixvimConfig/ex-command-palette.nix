{ ... }:
{
  extraConfigLua = ''
    local function read_ex_command_index()
      local path = vim.env.VIMRUNTIME .. "/doc/index.txt"
      local ok, lines = pcall(vim.fn.readfile, path)
      if not ok then
        return nil, string.format("Failed to read %s: %s", path, tostring(lines))
      end

      local commands = {}
      local in_section, in_table = false, false
      for _, line in ipairs(lines) do
        if not in_section then
          in_section = line:find("*ex-cmd-index*", 1, true) ~= nil
        elseif not in_table then
          in_table = line:match("^Tag%s+Command") ~= nil
        else
          local tag, name, description = line:match("^|([^|]+)|%s+(:%S*)%s+(.+)")
          if tag then
            commands[#commands + 1] = {
              tag = tag,
              name = name,
              description = vim.trim(description),
            }
          elseif line:match("^%s*$") then
            break
          elseif commands[1] and line:match("^%s+%S") then
            -- Descriptions that exceed the column width wrap onto indented lines.
            local previous = commands[#commands]
            previous.description = previous.description .. " " .. vim.trim(line)
          end
        end
      end

      if commands[1] == nil then
        return nil, "No Ex commands found in " .. path
      end
      return commands
    end

    local function show_ex_commands()
      local commands, err = read_ex_command_index()
      if commands == nil then
        vim.notify(err, vim.log.levels.ERROR)
        return
      end

      vim.ui.select(commands, {
        prompt = "Ex commands",
        format_item = function(command)
          return string.format("%-18s %s", command.name, command.description)
        end,
      }, function(choice)
        if choice == nil then
          return
        end
        vim.cmd("help " .. choice.tag)
      end)
    end

    vim.keymap.set("n", "<leader>f:", show_ex_commands, { desc = "All Ex commands" })
  '';
}
