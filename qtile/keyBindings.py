
from libqtile.lazy import lazy
from libqtile.config import EzKey as Key, Click, Drag

from groups import groups, groups2
from commonVars import terminal
##modifiers##
mod = "mod4"

##keys##
keys = [
    # Switch between windows
    Key("M-h", lazy.layout.left(), desc="Move focus to left"),
    Key("M-l", lazy.layout.right(), desc="Move focus to right"),
    Key("M-j", lazy.layout.down(), desc="Move focus down"),
    Key("M-k", lazy.layout.up(), desc="Move focus up"),
    Key("M-<space>", lazy.layout.next(), desc="Move window focus to other window"),
    Key("M-S-a", lazy.layout.add(), desc="Move window focus to other window"),
    Key("M-S-d", lazy.layout.delete(), desc="Move window focus to other window"),


    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key("M-S-h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key("M-S-l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key("M-S-j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key("M-S-k", lazy.layout.shuffle_up(), desc="Move window up"),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key("M-C-h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key("M-C-l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key("M-C-j", lazy.layout.grow_down(), desc="Grow window down"),
    Key("M-C-k", lazy.layout.grow_up(), desc="Grow window up"),
    Key("M-n", lazy.layout.normalize(), desc="Reset all window sizes"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key("M-S-<Return>",lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),
    Key("M-t", lazy.window.toggle_floating(), desc="forces the window back into tilling layout"),
    Key("M-f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),

    Key("M-<Return>", lazy.spawn(terminal), desc="Launch terminal"),

    # Toggle between different layouts as defined below
    Key("M-<Tab>", lazy.next_layout(), desc="Toggle between layouts"),
    Key("M-S-c", lazy.window.kill(), desc="Kill focused window"),

	#Key([mod, "control"], "r",lazy.reload_config(), desc="Reload the config"),
	Key("M-S-r",lazy.restart(), desc="Restart Qtile"),
    Key("M-S-q", lazy.shutdown(), desc="Shutdown Qtile"),


    Key('M-m', lazy.group['scratchpad'].dropdown_toggle('cmus')),
    Key('M-S-t', lazy.group['scratchpad'].dropdown_toggle('term')),
]
##end keys##	
##mouse key bindings##
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]
##end mouse key bindings##

##group keys##

for ind, i in enumerate(groups2):
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                "M-" + i.name,
                lazy.group[groups[ind].name].toscreen(),
                desc="Switch to group {}".format(groups[ind].name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                "M-S-" + i.name,
                lazy.window.togroup(groups[ind].name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(
                    groups[ind].name
                ),
            ),
        ]
    )

keys.extend([
    # go to surrounding groups
	Key("A-h",lazy.screen.prev_group()),
    Key("A-l",lazy.screen.next_group())
	])
##end group keys##
