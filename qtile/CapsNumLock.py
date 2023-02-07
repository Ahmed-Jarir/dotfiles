# -*- coding: utf-8 -*-
# Copyright (C) 2018 Juan Riquelme González
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

from libqtile.log_utils import logger
from libqtile.widget import base


class CapsNumLock(base.ThreadPoolText):
    """Really simple widget to show the current Caps/Num Lock state."""

    defaults = [
        ("update_interval", 0.5, "Update Time in seconds."),
        ("format", "Caps {caps} Num {num}", "format"),
    ]

    def __init__(self, **config):
        base.ThreadPoolText.__init__(self, "", **config)
        self.add_defaults(CapsNumLock.defaults)
        self.caps = "off"
        self.num = "off"

    def update_indicators(self):
        """Return a list with the current state of the keys."""
        try:
            output = self.call_process(["xset", "q"])
        except subprocess.CalledProcessError as err:
            output = err.output
            self.caps = "-1"
            self.num = "-1"
        if output.startswith("Keyboard"):
            indicators = re.findall(r"[Caps|Num]\s+Lock:\s*(\w*)", output)
            # logger.warning(indicators)
            self.caps = indicators[0]
            self.num = indicators[1]

    def poll(self):
        """Poll content for the text box."""
        self.update_indicators()
        # status = " ".join([" ".join(indicator) for indicator in indicators])
        status = self.format.format(caps=self.caps, num=self.num)
        return status
