from libqtile.config import Group, ScratchPad, DropDown, Match
from commonVars import terminal

sp_opacity = 0.97
sp_y = 0.07
sp_height = 0.85
##Groups##

groups = [
    Group("SYS", spawn = terminal, layout = "bsp"),
    Group("NET", spawn = "Brave-browser"),
    Group("UNI", spawn = "nautilus"),
    Group("DOC"),
    Group(
        "GDV",
        spawn = "unityhub",
        matches = [Match(wm_class = [" unityhub", "Unity"])],
        layout = "treetab",
    ),
    Group("VRM", spawn = "virt-manager", matches = [Match(wm_class = ["virt-manager"])]),
    Group(
        "CHT",
        spawn = "discord",
        matches = [Match(wm_class = ["discord", "Whatsapp-for-linux", "Slack"])],
    ),
    Group("VID"),
    Group("ANI"),
    ScratchPad(
        "scratchpad",
        [
            DropDown(
                "cmus", "kitty cmus", opacity = sp_opacity, y = sp_y, height = sp_height
            ),
            DropDown("term", "kitty", opacity = sp_opacity, y = sp_y, height = sp_height, on_focus_lost_hide = False),
        ],
    ),
]
##end keys##
groups2 = [Group(i) for i in "123456789"]
