{ ... }:
{
  plugins.which-key = {
    enable = true;

    settings = {
      delay = 300;
      spec = [
        {
          __unkeyed-1 = "<leader>b";
          group = "Buffers";
          icon = "󰓩 ";
        }
        {
          __unkeyed-1 = "<leader>c";
          group = "Code";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>f";
          group = "Find";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>g";
          group = "Git";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>h";
          group = "Git hunks";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>r";
          group = "Rename";
          icon = "󰑕 ";
        }
        {
          __unkeyed-1 = "<leader>t";
          group = "Toggle";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>w";
          group = "Windows";
          icon = " ";
        }
      ];
    };
  };
}
