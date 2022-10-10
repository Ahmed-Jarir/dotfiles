import urllib.request as req
import json

from libqtile import bar
from libqtile.widget import base
from libqtile.log_utils import logger

class CurrencyConv(base._TextBox):

    orientations = base.ORIENTATION_HORIZONTAL
    defaults = [
        ("padding", 3, "Padding left and right. Calculated if None."),
        ("update_interval", 6, "Update time in seconds."),
        ("precision", 2, "precision"),
        ("convert_to", "TRY", "A currency to convert to"),
        ("convert_from", "USD", "A currency to convert from")
    ]

    def __init__(self, **config):
        base._TextBox.__init__(self, "0", **config)
        self.add_defaults(CurrencyConv.defaults)

    def _configure(self, qtile, parent_bar):
        base._TextBox._configure(self, qtile, parent_bar)

    def update(self):
        url = f"https://api.exchangerate.host/convert?from={self.convert_from}&to={self.convert_to}"
        response = req.urlopen(url).read()
        data = json.loads(response)

        self.text = str(round(data["result"], self.precision))

        self.bar.draw()

    def timer_setup(self):
        self.update()
        self.timeout_add(self.update_interval, self.timer_setup)

    def draw(self):
        base._TextBox.draw(self)
