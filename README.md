# omarchy-wifi-portal

Tells you when a Wi-Fi network needs a sign-in page, and opens it — like your phone does.

| Behind a portal | Signed in |
|---|---|
| ![Sign-in required](screenshot-portal.png) | ![Connected](screenshot-online.png) |

## What it does

Behind a captive portal:

- the Wi-Fi icon in the bar becomes a **locked** Wi-Fi icon
- the network row in the panel turns red: **Sign-in required · click to open portal**
- click it → your browser opens the portal's login page

Signed in → everything goes back to normal.

## How it works

Right after you connect (and whenever you open the Wi-Fi panel), it fetches
`http://ping.archlinux.org` — the same URL NetworkManager already uses on Arch.

- page loads → you're online
- request gets redirected → a portal is in the way → lock icon + red row

Click the row → it opens wherever that redirect points, which is the portal's login page.

Nothing runs in the background.

## Install

```bash
git clone https://github.com/remigius-labs/omarchy-wifi-portal
cd omarchy-wifi-portal && ./install.sh
```

This clones Omarchy's stock `omarchy.network` widget into
`~/.config/omarchy/plugins/<you>.network` and applies a small patch. Your bar switches
to the patched copy; Omarchy updates won't overwrite it.

The installer checks that your Omarchy ships the widget version this patch was made
against. If it doesn't match, it does nothing — no half-applied widget.

Tested on Omarchy 4.0.1.

## Test it at home

No café needed. `fake-portal.sh` makes your own laptop behave like a café router:
every http request gets hijacked and sent to a fake "Café Wi-Fi" sign-in page.

```bash
./fake-portal.sh on
```

Open the Wi-Fi panel — lock icon, red row. Click the row → the fake sign-in page opens.

```bash
./fake-portal.sh off
```

Needs sudo (it edits `/etc/hosts` and listens on port 80). Your real connection is untouched.

## Uninstall

```bash
./uninstall.sh
```

## Why

I sat down at a Starbucks, connected, and nothing loaded. Omarchy said "Connected".
No prompt, no hint. I ended up typing `http://neverssl.com` into the browser by hand
to get the portal to show up. Phones solved this years ago; this brings it to Omarchy.
