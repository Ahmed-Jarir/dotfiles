# Copyright (c) 2010, 2012, 2014 roger
# Copyright (c) 2011 Kirk Strauser
# Copyright (c) 2011 Florian Mounier
# Copyright (c) 2011 Mounier Florian
# Copyright (c) 2011 Roger Duran
# Copyright (c) 2012-2015 Tycho Andersen
# Copyright (c) 2013 Tao Sauvage
# Copyright (c) 2013 Craig Barnes
# Copyright (c) 2014-2015 Sean Vig
# Copyright (c) 2014 Adi Sieker
# Copyright (c) 2014 dmpayton
# Copyright (c) 2014 Jody Frankowski
# Copyright (c) 2016 Christoph Lassner
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import re
import subprocess

from libqtile.widget.volume import Volume

re_vol = re.compile(r"(\d?\d?\d?)%")

class Volume2(Volume):
    """Widget that display and change volume

    By default, this widget uses ``amixer`` to get and set the volume so users
    will need to make sure this is installed. Alternatively, users may set the
    relevant parameters for the widget to use a different application.

    If theme_path is set it draw widget as icons.
    """

    defaults = [
        (
            "unmute_format",
            "{volume}%",
            "Format of text to display. Available fields: 'volume'",
        ),
        (
            "mute_format",
            "{volume}% M",
            "Format of text to display when the volume is muted. Available fields: 'volume'",
        ),
    ]

    def __init__(self, **config):
        Volume.__init__(self, **config)
        self.mute = False
        self.mixer_out = ""

        self.add_callbacks(
            {
                "Button1": self.cmd_mute,
                "Button3": self.cmd_run_app,
                "Button4": self.cmd_increase_vol,
                "Button5": self.cmd_decrease_vol,
            }
        )

    def update(self):
        vol = self.get_volume()
        next_mute = "[off]" in self.mixer_out

        if vol != self.volume or self.mute != next_mute:
            self.volume = vol
            self.mute = next_mute
            # Update the underlying canvas size before actually attempting
            # to figure out how big it is and draw it.
            self._update_drawer()
            self.bar.draw()
        self.timeout_add(self.update_interval, self.update)

    def _update_drawer(self):
        if self.theme_path:
            self.drawer.clear(self.background or self.bar.background)
            if self.volume <= 0 or self.mute:
                img_name = "audio-volume-muted"
            elif self.volume <= 30:
                img_name = "audio-volume-low"
            elif self.volume < 80:
                img_name = "audio-volume-medium"
            else:  # self.volume >= 80:
                img_name = "audio-volume-high"

            self.drawer.ctx.set_source(self.surfaces[img_name])
            self.drawer.ctx.paint()
        elif self.emoji:
            if self.volume <= 0 or self.mute:
                self.text = "\U0001f507"
            elif self.volume <= 30:
                self.text = "\U0001f508"
            elif self.volume < 80:
                self.text = "\U0001f509"
            elif self.volume >= 80:
                self.text = "\U0001f50a"
        else:
            self.text = (self.mute_format if self.mute else self.unmute_format).format(
                volume = self.volume
            )

    def get_volume(self):
        try:
            get_volume_cmd = self.create_amixer_command("sget", self.channel)

            if self.get_volume_command:
                get_volume_cmd = self.get_volume_command

            self.mixer_out = self.call_process(get_volume_cmd)
        except subprocess.CalledProcessError:
            return -1

        volgroups = re_vol.search(self.mixer_out)

        if volgroups:
            return int(volgroups.groups()[0])
        else:
            # this shouldn't happen
            return -1
