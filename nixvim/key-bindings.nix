{pkgs, ...}:
{
    programs.nixvim = {
        globals.mapleader = " ";
        keymaps = [

            {
                key = "<leader>ff";
                action = "<cmd>Telescope find_files<cr>";
                options.desc = "find file";
            }
            {
              key = "<leader>fg";
              action = "<cmd>Telescope live_grep<cr>";
              options.desc = "live grep";
            }
            {
                key = "<leader>fb";
                action = "<cmd>Telescope buffers<cr>";
                options.desc = "find buffer";
            }
        ];
    };
}
