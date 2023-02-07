from libqtile import bar, widget

from myWidgets import CurrencyConv
from commonVars import colors
from CapsNumLock import CapsNumLock
from volumeWidget import Volume

widget_defaults = dict(
    font="FiraCode Nerd Font Bold",
    fontsize=12,
    padding=3,
)
# extension_defaults = widget_defaults.copy()

##bars##
topBar=bar.Bar(
            [
                widget.GroupBox(
                    fontsize = 11,
                    margin_y = 3,
                    margin_x = 0,
                    padding_y = 0,
                    padding_x = 3,
                    borderwidth = 3,
                    active = colors["fg"],
                    inactive = colors["black"],
                    urgent_text = "e36841",
                    highlight_color = colors["obg"],
                    highlight_method = "block",
                    background = colors["mainbg"],
                    # rounded = False,
                ),
                widget.TextBox(
                            '',
                			width = 17,
                            fontsize = 16,
                            padding = -2,
                            foreground = colors["mainbg"],
                            background = colors["obg"],
                        ),
                widget.CurrentLayout(
                    foreground = colors["black"],
                    background = colors["obg"],
                ),
                widget.TextBox(
                            '',
                			width = 17,
                            fontsize = 16,
                            padding = -2,
                            foreground = colors["obg"],
                            background = colors["mainbg"],
                        ),
				# widget.Cmus(),

                widget.Spacer(),
				widget.WindowName(
                    foreground = colors["fg"]
                    ),
                widget.Spacer(),

                widget.TextBox(
                            '',
                            width = 18,
                            fontsize = 20,
                            padding = -2,
                            foreground = colors["obg"],
                            background = colors["mainbg"],
                        ),

                widget.Systray(
                    background = colors["obg"],
                    foreground = colors["black"],
                    ),
                widget.TextBox(
                            '',
                            width = 18,
                            fontsize = 20,
                            padding = -2,
                            foreground = colors["mainbg"],
                            background = colors["obg"],
                        ),

                widget.Clock(
                    format = "%A, %b %d %I:%M %p",
                    background = colors["mainbg"],
                    foreground = colors["fg"],
                ),

            ],
            14,
            background = colors["mainbg"],
            border_color = colors["obg"],
            border_width = 2,
            opacity = 0.94
        )
bottomBar=bar.Bar(
    [
        Volume(
            fmt = "Vol: {}",
            unmute_format = "{volume}% [on]",
            mute_format = "{volume}% [off]",
			padding = 8,
            background = colors["mainbg"],
            foreground = colors["fg"],
            step = 5,
        ),

        widget.TextBox(
            '',
			width = 17,
            fontsize = 13,
            padding = -2,
            foreground = colors["mainbg"],
            background = colors["obg"],
        ),

        widget.Memory(
            format = "Ram: {MemPercent}%",
            background = colors["obg"],
            foreground = colors["black"],
        ),

        widget.TextBox(
            "",
			width = 17,
            fontsize = 13,
            padding = -2,
            foreground = colors["obg"],
            background = colors["mainbg"],
        ),

        widget.CPU(
            format="Cpu: {load_percent}%",
            background=colors["mainbg"],
            foreground=colors["fg"],
        ),

        widget.TextBox(
            "",
			width = 17,
            fontsize = 13,
            padding = -2,
            foreground = colors["mainbg"],
            background = colors["obg"],
        ),

        widget.Battery(
            format = "Battery: {percent:.0%}{char}",
            background = colors["obg"],
            foreground = colors["black"],
            charge_char = " ﮣ",
            discharge_char = " -",
            low_percentage = 0.2,
        ),
        
        widget.TextBox(
            "",
			width = 17,
            fontsize = 13,
            padding = -2,
            foreground = colors["obg"],
            background = colors["mainbg"],
        ),

        widget.DF(
            format = "Disk: {r:.0f}%",
            foreground = colors["fg"],
            background = colors["mainbg"],
            visible_on_warn = False,
        ),

        widget.TextBox(
            "",
			width = 17,
            fontsize = 13,
            padding = -2,
            foreground = colors["mainbg"],
            background = colors["obg"],
        ),
        CapsNumLock(
            format = "Num {num}",
			background = colors["obg"],
			foreground = colors["black"]
        ),


			#         widget.CapsNumLockIndicator(
			#             fmt = "{}",
			# background = colors["obg"],
			# foreground = colors["black"]
			#         ),

        widget.TextBox(
            "",
			width= 17,
            fontsize= 13,
            padding = -2,
            foreground = colors["obg"],
            background = colors["mainbg"],
        ),
        
        widget.Spacer(),
        widget.Cmus(max_chars = 20),
        widget.Spacer(),

        widget.TextBox(
            "",
			width = 17,
            fontsize = 13,
            padding = 2,
            foreground = colors["obg"],
            background = colors["mainbg"],
        ),
 
        # CurrencyConv.CurrencyConv(
        #     fmt = "USD: {} TRY",
        #     foreground = colors["black"],
        #     background = colors["obg"],
        # ),
        widget.TextBox(
            "",
			width = 17,
            fontsize = 13,
            padding = 2,
            foreground = colors["mainbg"],
            background = colors["obg"],
        ),
    ],

    14,
	background = colors["mainbg"],
    border_color = colors["obg"],
    border_width = 2,
    opacity = 0.94
)

# appBar=bar.Bar(
#     [
#         widget.WindowTabs(),
#     ],
#     14,
# 	background=colors["obg"],

# )

##end bars##
