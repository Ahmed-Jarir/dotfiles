from typing import List  # noqa: F401
from libqtile import layout
from libqtile.config import Match
from commonVars import colors

layouts = [
    layout.Bsp(border_focus = colors["border"], border_width = 4, margin = 6),
    layout.Stack(border_focus = colors["border"], border_width = 4, num_stacks = 1, margin = 6),
    layout.TreeTab(border_focus = colors["border"], border_width = 4, margin = 6),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]
dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False

floating_layout = layout.Floating(
    float_rules = [
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class = "sierpinski"),  # gitk
        Match(wm_class = "Sierpinski"),  # gitk
        Match(wm_class = "confirmreset"),  # gitk
        Match(wm_class = "makebranch"),  # gitk
        Match(wm_class = "maketag"),  # gitk
        Match(wm_class = "ssh-askpass"),  # ssh-askpass
        Match(wm_class = ".blueman-manager-wrapped"),
        Match(wm_class = "zoom"),
        Match(wm_class = "Gxmessage"),
        Match(wm_class = "copyq"),
        Match(wm_class = "Unity"),
        Match(title = "branchdialog"),  # gitk
        Match(title = "pinentry"),  # GPG key password entry
    ]
)
