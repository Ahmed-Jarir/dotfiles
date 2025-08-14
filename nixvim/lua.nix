{pkgs, ...}:
{
    programs.nixvim.extraConfigLua = ''
        local g = vim.g
        if g.neovide then
            g.neovide_scale_factor = 0.5
            g.neovide_transparency = 0.94
            g.transparency = 0.0
            g.neovide_background_color = '#222330'..math.floor(255 * g.neovide_transparency)
        else
            vim.api.nvim_set_hl(0,"Normal", { bg = "none"})
            vim.api.nvim_set_hl(0,"NormalFloat", { bg = "none"})
            vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "none"})
            vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "none"})
        end
    '';

}
