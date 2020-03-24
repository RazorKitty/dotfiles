# Autogenerated config.py
# Documentation:
#   qute://help/configuring.html
#   qute://help/settings.html

# Uncomment this to still load settings configured via autoconfig.yml
# config.load_autoconfig()

# Aliases for commands. The keys of the given dictionary are the
# aliases, while the values are the commands they map to.
# Type: Dict
c.aliases = {'q': 'close', 'qa': 'quit', 'w': 'session-save', 'wq': 'quit --save', 'wqa': 'quit --save'}

# Backend to use to display websites. qutebrowser supports two different
# web rendering engines / backends, QtWebKit and QtWebEngine. QtWebKit
# was discontinued by the Qt project with Qt 5.6, but picked up as a
# well maintained fork: https://github.com/annulen/webkit/wiki -
# qutebrowser only supports the fork. QtWebEngine is Qt's official
# successor to QtWebKit. It's slightly more resource hungry than
# QtWebKit and has a couple of missing features in qutebrowser, but is
# generally the preferred choice.
# Type: String
# Valid values:
#   - webengine: Use QtWebEngine (based on Chromium).
#   - webkit: Use QtWebKit (based on WebKit, similar to Safari).
c.backend = 'webengine'

# Always restore open sites when qutebrowser is reopened.
# Type: Bool
c.auto_save.session = True

# Automatically start playing `<video>` elements. Note: On Qt < 5.11,
# this option needs a restart and does not support URL patterns.
# Type: Bool
c.content.autoplay = False

# Size (in bytes) of the HTTP network cache. Null to use the default
# value. With QtWebEngine, the maximum supported value is 2147483647 (~2
# GB).
# Type: Int
c.content.cache.size = None

# Allow websites to read canvas elements. Note this is needed for some
# websites to work properly.
# Type: Bool
c.content.canvas_reading = True

# Which cookies to accept.
# Type: String
# Valid values:
#   - all: Accept all cookies.
#   - no-3rdparty: Accept cookies from the same origin only. This is known to break some sites, such as GMail.
#   - no-unknown-3rdparty: Accept cookies from the same origin only, unless a cookie is already set for the domain. On QtWebEngine, this is the same as no-3rdparty.
#   - never: Don't accept cookies at all.
c.content.cookies.accept = 'all'

# Store cookies. Note this option needs a restart with QtWebEngine on Qt
# < 5.9.
# Type: Bool
c.content.cookies.store = True

# Default encoding to use for websites. The encoding must be a string
# describing an encoding such as _utf-8_, _iso-8859-1_, etc.
# Type: String
c.content.default_encoding = 'iso-8859-1'

# Allow websites to share screen content. On Qt < 5.10, a dialog box is
# always displayed, even if this is set to "true".
# Type: BoolAsk
# Valid values:
#   - true
#   - false
#   - ask
c.content.desktop_capture = 'ask'

# Try to pre-fetch DNS entries to speed up browsing.
# Type: Bool
c.content.dns_prefetch = False

# Allow websites to request geolocations.
# Type: BoolAsk
# Valid values:
#   - true
#   - false
#   - ask
c.content.geolocation = 'ask'

# Value to send in the `Accept-Language` header. Note that the value
# read from JavaScript is always the global value.
# Type: String
c.content.headers.accept_language = 'en-GB,en'

# Custom headers for qutebrowser HTTP requests.
# Type: Dict
c.content.headers.custom = {}

# Value to send in the `DNT` header. When this is set to true,
# qutebrowser asks websites to not track your identity. If set to null,
# the DNT header is not sent at all.
# Type: Bool
c.content.headers.do_not_track = True

# When to send the Referer header. The Referer header tells websites
# from which website you were coming from when visiting them. No restart
# is needed with QtWebKit.
# Type: String
# Valid values:
#   - always: Always send the Referer.
#   - never: Never send the Referer. This is not recommended, as some sites may break.
#   - same-domain: Only send the Referer for the same domain. This will still protect your privacy, but shouldn't break any sites. With QtWebEngine, the referer will still be sent for other domains, but with stripped path information.
c.content.headers.referer = 'same-domain'

# User agent to send. Unset to send the default. Note that the value
# read from JavaScript is always the global value.
# Type: String
#c.content.headers.user_agent = None

# Enable host blocking.
# Type: Bool
c.content.host_blocking.enabled = True

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'file://*')

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'chrome://*/*')

# Enable JavaScript.
# Type: Bool
config.set('content.javascript.enabled', True, 'qute://*/*')

# Number of commands to save in the command history. 0: no history / -1:
# unlimited
# Type: Int
c.completion.cmd_history_max_items = 1000

# Height (in pixels or as percentage of the window) of the completion.
# Type: PercOrInt
c.completion.height = '50%'

# Move on to the next part when there's only one possible completion
# left.
# Type: Bool
c.completion.quick = True

# When to show the autocompletion window.
# Type: String
# Valid values:
#   - always: Whenever a completion is available.
#   - auto: Whenever a completion is requested.
#   - never: Never.
c.completion.show = 'always'

# Shrink the completion to be smaller than the configured size if there
# are no scrollbars.
# Type: Bool
c.completion.shrink = True

# Width (in pixels) of the scrollbar in the completion window.
# Type: Int
c.completion.scrollbar.width = 12

# Padding (in pixels) of the scrollbar handle in the completion window.
# Type: Int
c.completion.scrollbar.padding = 1

# Delay (in milliseconds) before updating completions after typing a
# character.
# Type: Int
c.completion.delay = 0

# Minimum amount of characters needed to update completions.
# Type: Int
c.completion.min_chars = 1

# Which categories to show (in which order) in the :open completion.
# Type: FlagList
# Valid values:
#   - searchengines
#   - quickmarks
#   - bookmarks
#   - history
c.completion.open_categories = ['searchengines', 'quickmarks', 'bookmarks', 'history']

# Page to open if :open -t/-b/-w is used without URL. Use `about:blank`
# for a blank page.
# Type: FuzzyUrl
c.url.default_page = 'http://8bitdash.com'

# Search engines which can be used via the address bar. Maps a search
# engine name (such as `DEFAULT`, or `ddg`) to a URL with a `{}`
# placeholder. The placeholder will be replaced by the search term, use
# `{{` and `}}` for literal `{`/`}` signs. The search engine named
# `DEFAULT` is used when `url.auto_search` is turned on and something
# else than a URL was entered to be opened. Other search engines can be
# used by prepending the search engine name to the search term, e.g.
# `:open google qutebrowser`.
# Type: Dict
c.url.searchengines = {'DEFAULT': 'https://duckduckgo.com/?q={}'}

# Text color of the completion widget. May be a single color to use for
# all columns or a list of three colors, one for each column.
# Type: List of QtColor, or QtColor
c.colors.completion.fg = '#48737a'

# Background color of the completion widget for odd rows.
# Type: QssColor
c.colors.completion.odd.bg = '#0f192e'

# Background color of the completion widget for even rows.
# Type: QssColor
c.colors.completion.even.bg = '#0f192e'

# Foreground color of completion widget category headers.
# Type: QtColor
c.colors.completion.category.fg = '#0d0015'

# Background color of the completion widget category headers.
# Type: QssColor
c.colors.completion.category.bg = '#48737a'

# Top border color of the completion widget category headers.
# Type: QssColor
c.colors.completion.category.border.top = '#48737a'

# Bottom border color of the completion widget category headers.
# Type: QssColor
c.colors.completion.category.border.bottom = '#48737a'

# Foreground color of the selected completion item.
# Type: QtColor
c.colors.completion.item.selected.fg = '#b4c1c2'

# Background color of the selected completion item.
# Type: QssColor
c.colors.completion.item.selected.bg = '#0f192e'

# Top border color of the selected completion item.
# Type: QssColor
c.colors.completion.item.selected.border.top = '#0f192e'

# Bottom border color of the selected completion item.
# Type: QssColor
c.colors.completion.item.selected.border.bottom = '#0f192e'

# Foreground color of the matched text in the selected completion item.
# Type: QtColor
c.colors.completion.item.selected.match.fg = '#33a667'

# Foreground color of the matched text in the completion.
# Type: QtColor
c.colors.completion.match.fg = '#247345'

# Color of the scrollbar handle in the completion view.
# Type: QssColor
c.colors.completion.scrollbar.fg = '#b4c1c2'

# Color of the scrollbar in the completion view.
# Type: QssColor
c.colors.completion.scrollbar.bg = '#0f192e'

# Background color for the download bar.
# Type: QssColor
c.colors.downloads.bar.bg = '#0f192e'

# Color gradient start for download text.
# Type: QtColor
c.colors.downloads.start.fg = '#0d0015'

# Color gradient start for download backgrounds.
# Type: QtColor
c.colors.downloads.start.bg = '#174b58'

# Color gradient end for download text.
# Type: QtColor
c.colors.downloads.stop.fg = '#0d0015'

# Color gradient stop for download backgrounds.
# Type: QtColor
c.colors.downloads.stop.bg = '#797724'

# Foreground color for downloads with errors.
# Type: QtColor
c.colors.downloads.error.fg = '#0d0015'

# Background color for downloads with errors.
# Type: QtColor
c.colors.downloads.error.bg = '#ac1e33'

# Font color for hints.
# Type: QssColor
c.colors.hints.fg = '#b4c1c2'

# Background color for hints. Note that you can use a `rgba(...)` value
# for transparency.
# Type: QssColor
c.colors.hints.bg = '#0d0015'

# Font color for the matched part of hints.
# Type: QtColor
c.colors.hints.match.fg = '#247345'

# Text color for the keyhint widget.
# Type: QssColor
c.colors.keyhint.fg = '#48737a'

# Highlight color for keys to complete the current keychain.
# Type: QssColor
c.colors.keyhint.suffix.fg = '#b4c1c2'

# Background color of the keyhint widget.
# Type: QssColor
c.colors.keyhint.bg = '#0d0015'

# Foreground color of an error message.
# Type: QssColor
c.colors.messages.error.fg = '#0d0015'

# Background color of an error message.
# Type: QssColor
c.colors.messages.error.bg = '#ac1e33'

# Border color of an error message.
# Type: QssColor
c.colors.messages.error.border = '#0d0015'

# Foreground color of a warning message.
# Type: QssColor
c.colors.messages.warning.fg = '#0d0015'

# Background color of a warning message.
# Type: QssColor
c.colors.messages.warning.bg = '#797724'

# Border color of a warning message.
# Type: QssColor
c.colors.messages.warning.border = '#0d0015'

# Foreground color of an info message.
# Type: QssColor
c.colors.messages.info.fg = '#b4c1c2'

# Background color of an info message.
# Type: QssColor
c.colors.messages.info.bg = '#0d0015'

# Border color of an info message.
# Type: QssColor
c.colors.messages.info.border = '#0d0015'

# Foreground color for prompts.
# Type: QssColor
c.colors.prompts.fg = '#48737a'

# Border used around UI elements in prompts.
# Type: String
c.colors.prompts.border = '1px #0d0015'

# Background color for prompts.
# Type: QssColor
c.colors.prompts.bg = '#0f192e'

# Background color for the selected item in filename prompts.
# Type: QssColor
c.colors.prompts.selected.bg = '#0d0015'

# Foreground color of the statusbar.
# Type: QssColor
c.colors.statusbar.normal.fg = '#48737a'

# Background color of the statusbar.
# Type: QssColor
c.colors.statusbar.normal.bg = '#0d0015'

# Foreground color of the statusbar in insert mode.
# Type: QssColor
c.colors.statusbar.insert.fg = '#0d0015'

# Background color of the statusbar in insert mode.
# Type: QssColor
c.colors.statusbar.insert.bg = '#247345'

# Foreground color of the statusbar in passthrough mode.
# Type: QssColor
c.colors.statusbar.passthrough.fg = '#0d0015'

# Background color of the statusbar in passthrough mode.
# Type: QssColor
c.colors.statusbar.passthrough.bg = '#174b58'

# Foreground color of the statusbar in private browsing mode.
# Type: QssColor
c.colors.statusbar.private.fg = '#0d0015'

# Background color of the statusbar in private browsing mode.
# Type: QssColor
c.colors.statusbar.private.bg = '#4d3a58'

# Foreground color of the statusbar in command mode.
# Type: QssColor
c.colors.statusbar.command.fg = '#48737a'

# Background color of the statusbar in command mode.
# Type: QssColor
c.colors.statusbar.command.bg = '#0d0015'

# Foreground color of the statusbar in private browsing + command mode.
# Type: QssColor
c.colors.statusbar.command.private.fg = '#0d0015'

# Background color of the statusbar in private browsing + command mode.
# Type: QssColor
c.colors.statusbar.command.private.bg = '#4d3a58'

# Foreground color of the statusbar in caret mode.
# Type: QssColor
c.colors.statusbar.caret.fg = '#48737a'

# Background color of the statusbar in caret mode.
# Type: QssColor
c.colors.statusbar.caret.bg = '#4d3a58'

# Foreground color of the statusbar in caret mode with a selection.
# Type: QssColor
c.colors.statusbar.caret.selection.fg = 'white'

# Background color of the statusbar in caret mode with a selection.
# Type: QssColor
c.colors.statusbar.caret.selection.bg = '#a12dff'

# Background color of the progress bar.
# Type: QssColor
c.colors.statusbar.progress.bg = '#247345'

# Default foreground color of the URL in the statusbar.
# Type: QssColor
c.colors.statusbar.url.fg = '#b4c1c2'

# Foreground color of the URL in the statusbar on error.
# Type: QssColor
c.colors.statusbar.url.error.fg = '#ac1e33'

# Foreground color of the URL in the statusbar for hovered links.
# Type: QssColor
c.colors.statusbar.url.hover.fg = '#174b58'

# Foreground color of the URL in the statusbar on successful load
# (http).
# Type: QssColor
c.colors.statusbar.url.success.http.fg = '#247345'

# Foreground color of the URL in the statusbar on successful load
# (https).
# Type: QssColor
c.colors.statusbar.url.success.https.fg = '#33a667'

# Foreground color of the URL in the statusbar when there's a warning.
# Type: QssColor
c.colors.statusbar.url.warn.fg = '#797724'

# Background color of the tab bar.
# Type: QssColor
c.colors.tabs.bar.bg = '#0f192e'

# Color gradient start for the tab indicator.
# Type: QtColor
c.colors.tabs.indicator.start = '#174b58'

# Color gradient end for the tab indicator.
# Type: QtColor
c.colors.tabs.indicator.stop = '#247345'

# Color for the tab indicator on errors.
# Type: QtColor
c.colors.tabs.indicator.error = '#ac1e33'

# Color gradient interpolation system for the tab indicator.
# Type: ColorSystem
# Valid values:
#   - rgb: Interpolate in the RGB color system.
#   - hsv: Interpolate in the HSV color system.
#   - hsl: Interpolate in the HSL color system.
#   - none: Don't show a gradient.
c.colors.tabs.indicator.system = 'rgb'

# Foreground color of unselected odd tabs.
# Type: QtColor
c.colors.tabs.odd.fg = '#48737a'

# Background color of unselected odd tabs.
# Type: QtColor
c.colors.tabs.odd.bg = '#0f192e'

# Foreground color of unselected even tabs.
# Type: QtColor
c.colors.tabs.even.fg = '#48737a'

# Background color of unselected even tabs.
# Type: QtColor
c.colors.tabs.even.bg = '#0f192e'

# Foreground color of selected odd tabs.
# Type: QtColor
c.colors.tabs.selected.odd.fg = '#0d0015'

# Background color of selected odd tabs.
# Type: QtColor
c.colors.tabs.selected.odd.bg = '#48737a'

# Foreground color of selected even tabs.
# Type: QtColor
c.colors.tabs.selected.even.fg = '#0d0015'

# Background color of selected even tabs.
# Type: QtColor
c.colors.tabs.selected.even.bg = '#48737a'

# Background color of pinned unselected even tabs.
# Type: QtColor
c.colors.tabs.pinned.even.bg = 'darkseagreen'

# Background color for webpages if unset (or empty to use the theme's
# color).
# Type: QtColor
c.colors.webpage.bg = '#0d0015'

# Font used for the hints.
# Type: Font
c.fonts.hints = 'terminus'

# Bindings for normal mode
config.bind('M', 'hint --rapid links spawn mpv {hint-url}')
config.bind('m', 'spawn mpv {url}')
