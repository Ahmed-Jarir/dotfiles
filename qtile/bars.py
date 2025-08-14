from libqtile import bar, widget

# from myWidgets import CurrencyConv
from commonVars import colors
from CapsNumLock import CapsNumLock
# from Volume2 import Volume2 as Volume
from Volume import Volume as Volume

widget_defaults = dict(
    font = "Minecraftia Bold",
    fontsize = 12,
    padding = 4,
)
# extension_defaults = widget_defaults.copy()

##bars##
topBar = bar.Bar(
    [
        widget.GroupBox(
            fontsize = 11,
            margin_y = 3,
            margin_x = 0,
            padding_y = 0,
            padding_x = 3,
            borderwidth = 3,
            active = colors["fontPrimary"],
            foreground = colors["fontPrimary"],
            inactive = colors["fontSecondary"],
            urgent_text = "e36841",
            highlight_method = "block",
            background = colors["primary"],
            this_current_screen_border = [colors["secondary"], colors["secondary"], colors["primary"], colors["fontSecondary"], colors["fontPrimary"]]
        ),
        widget.CurrentLayout(
            foreground = colors["fontSecondary"],
            background = colors["secondary"],
        ),
        widget.Spacer(),
        widget.WindowName(foreground = colors["fontPrimary"]),
        widget.Spacer(),
        widget.Systray(
            background = colors["secondary"],
            foreground = colors["fontSecondary"],
        ),
        widget.Clock(
            format = "%A, %b %d %I:%M %p",
            background = colors["primary"],
            foreground = colors["fontPrimary"],
        ),
    ],
    16,
    background = colors["primary"],
    border_color = colors["secondary"],
    border_width = 2,
    opacity = 0.94,
    margin = 4
)


bottomBar = bar.Bar(
    [
        Volume(
            fmt = "Vol: {}",
            unmute_format = "{volume}% [on]",
            mute_format = "{volume}% [off]",
            padding = 8,
            background = colors["primary"],
            foreground = colors["fontPrimary"],
            step = 5,
        ),
        widget.Memory(
            format = "Ram: {MemPercent}%",
            background = colors["secondary"],
            foreground = colors["fontSecondary"],
        ),
        widget.CPU(
            format = "Cpu: {load_percent}%",
            background = colors["primary"],
            foreground = colors["fontPrimary"],
        ),
        widget.Battery(
            format = "Bat: {percent:.0%}{char}",
            background = colors["secondary"],
            foreground = colors["fontSecondary"],
            charge_char = " 󰂄",
            discharge_char = " 󰂁",
            low_percentage = 0.2,
        ),
        widget.DF(
            format = "Dsk: {r:.0f}%",
            foreground = colors["fontPrimary"],
            background = colors["primary"],
            visible_on_warn = False,
        ),
        CapsNumLock(
            format = "Num {num}", background = colors["secondary"], foreground = colors["fontSecondary"]
        ),
        #         widget.CapsNumLockIndicator(
        #             fmt = "{}",
        # background = colors["secondary"],
        # foreground = colors["fontSecondary"]
        #         ),
        widget.Spacer(),
        # CurrencyConv.CurrencyConv(
        #     fmt = "USD: {} TRY",
        #     foreground = colors["fontSecondary"],
        #     background = colors["secondary"],
        # ),

        widget.KeyboardLayout(
            configured_keyboards = ["us", "ara"],
            display_map = {"us": "US", "ara": "AR"},
            foreground = colors["fontSecondary"],
            background = colors["secondary"],
        ),
        widget.Backlight(
            fmt = 'brighness: {}',
            backlight_name = "nvidia_wmi_ec_backlight",
            foreground = colors["fontPrimary"],
            background = colors["primary"],
        ),
    ],
    14,
    background = colors["primary"],
    border_color = colors["secondary"],
    border_width = 2,
    opacity = 0.94,
    margin = 4
)
secondTopBar = bar.Bar([
        widget.GroupBox(
            fontsize = 11,
            margin_y = 3,
            margin_x = 0,
            padding_y = 0,
            padding_x = 3,
            borderwidth = 3,
            active = colors["fontPrimary"],
            inactive = colors["fontSecondary"],
            urgent_text = "e36841",
            highlight_color = colors["secondary"],
            highlight_method = "block",
            background = colors["primary"],
        ),
        widget.Spacer(),
        widget.WindowName(foreground = colors["fontPrimary"]),
        widget.Spacer(),
        widget.Clock(
            format = "%A, %b %d %I:%M %p",
            background = colors["primary"],
            foreground = colors["fontPrimary"],
        ),
    ],
    16,
    background = colors["primary"],
    border_color = colors["secondary"],
    border_width = 2,
    opacity = 0.94,
    margin = 4
)

##end bars##









