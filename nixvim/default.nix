{pkgs, ...}:
{
    programs.nixvim = {
        enable = true;
        colorschemes.onedark.enable = true;
    };
    imports = [
        ./options.nix
        ./plugins.nix
        ./key-bindings.nix
        ./lua.nix
    ];
}
