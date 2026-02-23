#!/usr/bin/env python3
"""
ChatGPT Layer Shell Overlay
----------------------------
Shows/hides a ChatGPT WebView as a Wayland layer-shell overlay.
Because it lives in the OVERLAY layer, it appears above fullscreen
apps without disrupting the tiling layout or dropping fullscreen.

Usage:
  chatgpt_overlay.py          — first run: starts the daemon + shows window
  chatgpt_overlay.py          — subsequent runs: toggle show/hide
  chatgpt_overlay.py --kill   — stop the daemon

Bind the script to a key in your Sway config:
  bindsym $mod+g exec ~/.config/custom_scripts/chatgpt_overlay.py
"""

import os
import signal
import subprocess
import sys

PID_FILE = "/tmp/chatgpt_overlay.pid"
URL = "https://chatgpt.com/"
WIDTH = 1200
HEIGHT = 720

# Only import GTK/WebKit in the daemon subprocess — avoids the fork()
# deprecation warning and keeps the controller path lightweight.
if "--daemon" in sys.argv:
    import gi
    gi.require_version("Gtk", "3.0")
    gi.require_version("GtkLayerShell", "0.1")
    gi.require_version("WebKit2", "4.1")
    from gi.repository import Gtk, GtkLayerShell, WebKit2, GLib


# ── IPC helpers ──────────────────────────────────────────────────────────────

def send_signal(sig: int) -> bool:
    """Send a signal to the running instance. Returns True on success."""
    try:
        with open(PID_FILE) as f:
            pid = int(f.read().strip())
        os.kill(pid, sig)
        return True
    except (FileNotFoundError, ProcessLookupError, ValueError):
        return False


# ── Overlay window ───────────────────────────────────────────────────────────

class ChatGPTOverlay:
    def __init__(self):
        self.visible = True
        self._write_pid()

        # ── Window ───────────────────────────────────────────────────────────
        self.win = Gtk.Window(title="ChatGPT")
        self.win.set_default_size(WIDTH, HEIGHT)
        self.win.set_resizable(True)
        self.win.connect("destroy", self._on_destroy)
        self.win.connect("key-press-event", self._on_key)

        # ── Layer shell ───────────────────────────────────────────────────────
        GtkLayerShell.init_for_window(self.win)
        GtkLayerShell.set_namespace(self.win, "chatgpt-overlay")
        # OVERLAY layer → above everything including fullscreen windows
        GtkLayerShell.set_layer(self.win, GtkLayerShell.Layer.OVERLAY)
        # Keyboard input only when the overlay is shown
        GtkLayerShell.set_keyboard_mode(self.win, GtkLayerShell.KeyboardMode.ON_DEMAND)
        # Don't anchor to any edge → compositor centers it
        for edge in (
            GtkLayerShell.Edge.TOP,
            GtkLayerShell.Edge.BOTTOM,
            GtkLayerShell.Edge.LEFT,
            GtkLayerShell.Edge.RIGHT,
        ):
            GtkLayerShell.set_anchor(self.win, edge, False)

        # ── WebKit view ───────────────────────────────────────────────────────
        ws = WebKit2.Settings()
        ws.set_enable_javascript(True)
        ws.set_enable_media(True)
        ws.set_enable_webgl(True)
        ws.set_hardware_acceleration_policy(
            WebKit2.HardwareAccelerationPolicy.ALWAYS
        )
        # Pretend to be Chrome so ChatGPT doesn't complain
        ws.set_user_agent(
            "Mozilla/5.0 (X11; Linux x86_64) "
            "AppleWebKit/537.36 (KHTML, like Gecko) "
            "Chrome/122.0.0.0 Safari/537.36"
        )

        # Shared persistent cookie/storage manager so you stay logged in
        data_mgr = WebKit2.WebsiteDataManager(
            base_data_directory=os.path.expanduser(
                "~/.local/share/chatgpt-overlay"
            ),
            base_cache_directory=os.path.expanduser(
                "~/.cache/chatgpt-overlay"
            ),
        )
        ctx = WebKit2.WebContext(website_data_manager=data_mgr)
        ctx.set_cache_model(WebKit2.CacheModel.WEB_BROWSER)

        self.webview = WebKit2.WebView.new_with_context(ctx)
        self.webview.set_settings(ws)
        self.webview.load_uri(URL)

        self.win.add(self.webview)
        self.win.show_all()

        # ── Unix signal handlers ──────────────────────────────────────────────
        # SIGUSR1 → toggle  |  SIGUSR2 → quit
        GLib.unix_signal_add(GLib.PRIORITY_DEFAULT, signal.SIGUSR1, self._toggle)
        GLib.unix_signal_add(GLib.PRIORITY_DEFAULT, signal.SIGUSR2, self._quit)

    # ── Helpers ───────────────────────────────────────────────────────────────

    def _write_pid(self):
        with open(PID_FILE, "w") as f:
            f.write(str(os.getpid()))

    def _toggle(self):
        if self.visible:
            self.win.hide()
        else:
            self.win.show_all()
            self.win.present()
        self.visible = not self.visible
        return GLib.SOURCE_CONTINUE  # keep the signal source alive

    def _quit(self):
        self._cleanup()
        Gtk.main_quit()
        return GLib.SOURCE_CONTINUE

    def _cleanup(self):
        try:
            os.unlink(PID_FILE)
        except FileNotFoundError:
            pass

    def _on_destroy(self, *_):
        self._cleanup()
        Gtk.main_quit()

    def _on_key(self, _, event):
        """Close (hide) the overlay on Escape."""
        from gi.repository import Gdk
        if event.keyval == Gdk.KEY_Escape:
            self._toggle()


# ── Entry point ───────────────────────────────────────────────────────────────

def run_daemon():
    """Actually run the GTK overlay. Called only in the daemon subprocess."""
    # Suppress WebKit/Chromium noise
    devnull = open(os.devnull, "w")
    sys.stdout = devnull
    sys.stderr = devnull

    ChatGPTOverlay()
    Gtk.main()


def main():
    if "--kill" in sys.argv:
        if send_signal(signal.SIGUSR2):
            print("Overlay stopped.")
        else:
            print("No running overlay found.")
        return

    if "--daemon" in sys.argv:
        # We are the daemon subprocess — run the overlay
        run_daemon()
        return

    # Already running → toggle visibility
    if send_signal(signal.SIGUSR1):
        return

    # Not running → spawn a fresh daemon process (no fork, no warning)
    subprocess.Popen(
        [sys.executable, os.path.abspath(__file__), "--daemon"],
        start_new_session=True,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )

    ChatGPTOverlay()
    Gtk.main()


if __name__ == "__main__":
    main()
