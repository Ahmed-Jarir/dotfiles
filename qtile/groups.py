from libqtile.config import Group,ScratchPad,DropDown, Match
from commonVars import terminal 
##Groups##
groups = [



    Group("SYS", spawn=terminal, layout="bsp"),
    Group("NET", spawn="google-chrome-stable"),
    Group("UNI", spawn="nautilus Documents/pr/uni"),
    Group("DOC"),
    Group("GDV", spawn="unityhub",matches=[Match(wm_class=["unityhub","Unity"])],layout="treetab"),
    Group("VRM", spawn="virt-manager",matches=[Match(wm_class=["virt-manager"])]),
    Group("CHT", spawn="discord", matches=[Match(wm_class=["discord","Whatsapp-for-linux","Slack"])]),
    Group("VID"),
	Group("ANI"),
    ScratchPad("scratchpad", [
        DropDown("cmus", "kitty cmus", opacity=0.97),
    ]),
    # ScratchPad("scratchpad", [
    #     DropDown("term", "kitty", opacity=0.97),
    # ]),

]
##end keys##	
groups2 = [Group(i) for i in "123456789"]

