{cfg, ...}: let
  inherit (cfg) security;
  inherit (cfg.theme.colors) background-darker background foreground;
in {
  # # This is an amalgamation of our (Schzifox') and Arkenfox' policies. Please report any compatibility issues
  # or security anti-features to the Schizofox team!
  #
  # Important resources:
  #  - https://webdevelopmentaid.wordpress.com/2013/10/21/customize-privacy-settings-in-mozilla-firefox-part-1-aboutconfig
  #  - https://panopticlick.eff.org
  #  - http://ip-check.info
  #  - http://browserspy.dk
  #  - https://wiki.mozilla.org/Fingerprinting
  #  - http://www.browserleaks.com
  #  - http://fingerprint.pet-portal.eu

  # Global Javascript toggle. This defaults to true to retain
  # compatibility with most webpages, however, this is also a
  # security flaw. Disable if Javascript is not required.
  "javascript.enable" = security.javascript.enable;

  # Disable about:config warning
  "browser.aboutConfig.showWarning" = false;

  # Set startup page.
  #  - 0=blank
  #  - 1=home
  #  - 2=last visited page,
  #  - 3=resume previous session
  # Note: this breaks 'browser.setup.homepage', so we should handle
  # this behaviour there instead.
  "browser.startup.page" = 3;
  "browser.startup.homepage" =
    if cfg.misc.startPageURL != null
    then "${cfg.misc.startPageURL}"
    else "about:blank";

  # NEWTAB page
  #  - true=Firefox Home (default)
  #  - false=blank page
  "browser.newtabpage.enabled" = false;

  # Disable sponsored content on Firefox Home (Activity Stream)
  "browser.newtabpage.activity-stream.showSponsored" = false;
  "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

  # Clear default topsites
  "browser.newtabpage.activity-stream.default.sites" = "";

  # Disable using the OS's geolocation service
  # Note: we disable geolocation for *all* OSes, although
  # Schizofox is only officially supported on Linux.
  "geo.provider.use_geoclue" = false; # Linux
  "geo.provider.use_corelocation" = false; # Darwin
  "geo.provider.ms-windows-location" = false; # Windows

  # Disable recommendation pane in about:addons
  "extensions.getAddons.showPane" = false; # uses Google Analytics
  "extensions.htmlaboutaddons.recommendations.enabled" = false;

  # Disable personalized Extension Recommendations in about:addons and AMO
  # This pref has no effect when Health Reports.
  # See:
  #  <https://support.mozilla.org/kb/personalized-extension-recommendations>
  "browser.discovery.enable" = false;

  # Disable shopping experience
  # https://bugzilla.mozilla.org/show_bug.cgi?id=1840156#c0
  "browser.shopping.experience2023.enabled" = false;

  ## Telemetry
  # Disable new data submission.
  # If disabled, no policy is shown or upload takes place, ever
  # See:
  #  <https://bugzilla.mozilla.org/1195552>
  "datareporting.policy.dataSubmissionEnabled" = false;

  # Disable Health Reports
  "datareporting.healthreport.uploadEnabled" = false;

  # The "unified" pref affects the behavior of the "enabled" pref
  #  - "unified" = false -> "enabled" controls the telemetry module
  #  - "unified" = true -> "enabled" only controls whether to record extended data
  "toolkit.telemetry.unified" = false;
  "toolkit.telemetry.enabled" = false;
  "toolkit.telemetry.server" = "data:,";
  "toolkit.telemetry.archive.enabled" = false;
  "toolkit.telemetry.newProfilePing.enabled" = false;
  "toolkit.telemetry.shutdownPingSender.enabled" = false;
  "toolkit.telemetry.updatePing.enabled" = false;
  "toolkit.telemetry.bhrPing.enabled" = false;
  "toolkit.telemetry.firstShutdownPing.enabled" = false;

  # Disable Telemetry Coverage
  # Also see:
  #  <https://blog.mozilla.org/data/2018/08/20/effectively-measuring-search-in-firefox>
  "toolkit.telemetry.coverage.opt-out" = true;
  "toolkit.coverage.opt-out" = true;
  "toolkit.coverage.endpoint.base" = "";

  # Disable Firefox Home (Activity Stream) telemetry
  "browser.newtabpage.activity-stream.feeds.telemetry" = false;
  "browser.newtabpage.activity-stream.telemetry" = false;

  ## Studies
  # Disable Firefox Studies
  "app.shield.optoutstudies.enabled" = false;

  # Disable Normandy/Shield
  # Shield is a telemetry system that can push and test "recipes"
  # Also see:
  #  <https://mozilla.github.io/normandy/>
  "app.normandy.enabled" = false;
  "app.normandy.api_url" = "";

  ## Crash Reports
  # Disable Crash Reports
  "breakpad.reportURL" = "";
  "browser.tabs.crashReporting.sendReport" = false;

  # Enforce no submission of backlogged Crash Reports
  "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;

  ## Other
  # Disable Captive Portal detection
  # Also see:
  #  <https://www.eff.org/deeplinks/2017/08/how-captive-portals-interfere-wireless-security-and-privacy>
  "captivedetect.canonicalURL" = "";
  "network.captive-portal-service.enabled" = false;

  # Disable Network Connectivity checks
  # Also see:
  #  <https://bugzilla.mozilla.org/1460537>
  "network.connectivity-service.enabled" = false;

  ## Safe Browsing
  # From Arkenfox user.js:
  # "SB has taken many steps to preserve privacy. If required, a full url is never sent
  # to Google, only a part-hash of the prefix, hidden with noise of other real part-hashes.
  # Firefox takes measures such as stripping out identifying parameters and since SBv4 (FF57+)
  # doesn't even use cookies. (#Turn on browser.safebrowsing.debug to monitor this activity)""
  # Also see:
  #  <https://feeding.cloud.geek.nz/posts/how-safe-browsing-works-in-firefox>
  #  <https://wiki.mozilla.org/Security/Safe_Browsing>
  #  <https://support.mozilla.org/kb/how-does-phishing-and-malware-protection-work>
  #  <https://educatedguesswork.org/posts/safe-browsing-privacy>

  # Disable SB (Safe Browsing)
  # !!! Do this at your own risk! These are the master switches !!!
  # Block dangerous and deceptive content
  # "browser.safebrowsing.malware.enabled" = false;
  # "browser.safebrowsing.phishing.enabled" = false;

  # Disable SafeBrowsing checks for downloads (remote)
  "browser.safebrowsing.downloads.remote.enabled" = false;

  ## Implicit Outbound
  # Disable link prefetching
  # See:
  #  <https://developer.mozilla.org/docs/Web/HTTP/Link_prefetching_FAQ>
  "network.prefetch-next" = false;

  # Disable DNS prefetching
  # See:
  #  <https://developer.mozilla.org/docs/Web/HTTP/Headers/X-DNS-Prefetch-Control>
  "network.dns.disablePrefetch" = true;
  "network.dns.disablePrefetchFromHTTPS" = true;

  # Disable predictor / prefetching
  "network.predictor.enabled" = false;
  "network.predictor.enable-prefetch" = false; # default: false

  # Disable link-mouseover opening connection to linked server
  # Also see:
  #  <https://news.slashdot.org/story/15/08/14/2321202/how-to-quash-firefoxs-silent-requests>
  "network.http.speculative-parallel-limit" = 0;

  # Disable mousedown speculative connections on bookmarks and history
  "browser.places.speculativeConnect.enabled" = false;

  # Enforce no "Hyperlink Auditing" (click tracking)
  # See:
  #  <https://www.bleepingcomputer.com/news/software/major-browsers-to-prevent-disabling-of-click-tracking-privacy-risk/>
  "browser.send_pings" = false;

  ##  DNS / DoH / PROXY / SOCKS
  # Set the proxy server to do any DNS lookups when using SOCKS
  # e.g. in Tor, this stops your local DNS server from knowing your Tor destination
  # as a remote Tor node will handle the DNS request
  # See:
  #  <https://trac.torproject.org/projects/tor/wiki/doc/TorifyHOWTO/WebBrowsers>
  "network.proxy.socks_remote_dns" = true;

  # Disable using UNC (Uniform Naming Convention) paths
  # !!! Can break extensions for profiles on network shares !!!
  # See:
  #  <https://bugzilla.mozilla.org/1413868>
  "network.file.disable_unc_paths" = true;

  # Disable GIO as a potential proxy bypass vector
  # From Arkenfox user.js:
  # "Gvfs/GIO has a set of supported protocols like obex, network, archive, computer,
  # dav, cdda, gphoto2, trash, etc. From FF87-117, by default only sftp was accepted"
  # See:
  #  <https://bugzilla.mozilla.org/1433507>
  #  <https://en.wikipedia.org/wiki/GVfs>
  #  <https://en.wikipedia.org/wiki/GIO_(software)>
  "network.gio.supported-protocols" = "";

  # Disable proxy direct failover for system requests (default: true)
  # See:
  #  <https://blog.mozilla.org/security/2021/10/25/securing-the-proxy-api-for-firefox-add-ons/>
  "network.proxy.failover_direct" = true;

  ## LOCATION BAR / SEARCH BAR / SUGGESTIONS / HISTORY / FORMS
  # Disable location bar making speculative connections
  # See:
  #  <https://bugzilla.mozilla.org/1348275>
  "browser.urlbar.speculativeConnect.enabled" = false;

  # Disable location bar contextual suggestions
  # Note: The UI is controlled by the .enabled pref
  # See:
  #  <https://blog.mozilla.org/data/2021/09/15/data-and-firefox-suggest/>
  "browser.urlbar.quicksuggest.enabled" = false;
  "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
  "browser.urlbar.suggest.quicksuggest.sponsored" = false;

  # Disable live search suggestions
  # Note: Both must be true for live search to work in the location bar
  "browser.search.suggest.enabled" = false;
  "browser.urlbar.suggest.searches" = false;

  # Disable urlbar trending search suggestions
  "browser.urlbar.trending.featureGate" = false;

  # Disable urlbar suggestions
  "browser.urlbar.addons.featureGate" = false;
  "browser.urlbar.fakespot.featureGate" = false;
  "browser.urlbar.mdn.featureGate" = false;
  "browser.urlbar.pocket.featureGate" = false;
  "browser.urlbar.weather.featureGate" = false;
  "browser.urlbar.yelp.featureGate" = false;

  # Disable urlbar clipboard suggestions
  "browser.urlbar.clipboard.featureGate" = false;

  # Disable search and form history
  # Be aware that autocomplete form data can be read by third parties
  # Note: You might want to also clear formdata on exit
  # Also see:
  #  <https://blog.mindedsecurity.com/2011/10/autocompleteagain.html>
  #  <https://bugzilla.mozilla.org/381681>
  "browser.formfill.enable" = false;

  # Enable separate default search engine in Private Windows and its UI setting
  "browser.search.separatePrivateDefault" = true;
  "browser.search.separatePrivateDefault.ui.enabled" = true;

  ## PASSWORDS
  # See:
  #  <https://support.mozilla.org/kb/use-primary-password-protect-stored-logins-and-pas>

  # Disable auto-filling username & password form fields
  # Can leak in cross-site forms *and* be spoofed
  # Username & password is still available when you enter the field
  # See:
  #  <https://freedom-to-tinker.com/2017/12/27/no-boundaries-for-user-identities-web-trackers-exploit-browser-login-managers/>
  #  <https://homes.esat.kuleuven.be/~asenol/leaky-forms>
  "signon.autofillForms" = false;

  # Disable formless login capture for Password Manager
  "signon.formlessCapture.enabled" = false;

  # Limit (or disable) HTTP authentication credentials dialogs triggered by sub-resources.
  # Hardens against potential credentials phishing
  #  - 0 = don't allow sub-resources to open HTTP authentication credentials dialogs
  #  - 1 = don't allow cross-origin sub-resources to open HTTP authentication credentials dialogs
  #  - 2 = allow sub-resources to open HTTP authentication credentials dialogs (default)
  "network.auth.subresource-http-auth-allow" = 0;

  # Disable enforcing no automatic authentication on Microsoft sites
  # See:
  #  <https://support.mozilla.org/kb/windows-sso>
  "network.http.windows-sso.enabled" = false; # nope!

  ## DISK AVOIDANCE
  # Disable disk cache
  "browser.cache.disk.enable" = false;

  # Disable media cache from writing to disk in Private Browsing
  "browser.privatebrowsing.forceMediaMemoryCache" = true;
  "media.memory_cache_max_size" = 65536; # 64MB

  # Disable storing extra session data
  # Define on which sites to save extra session data such as form content, cookies and POST data
  # - 0=everywhere
  # - 1=unencrypted sites
  # - 2=nowhere
  "browser.sessionstore.privacy_level" = 2;

  # Disable automatic Firefox start and session restore after reboot
  # See:
  #  <https://bugzilla.mozilla.org/603903>
  "toolkit.winRegisterApplicationRestart" = false;

  # Disable favicons in shortcuts
  # URL shortcuts use a cached randomly named .ico file which is stored in your
  # profile/shortcutCache directory. The .ico remains after the shortcut is deleted
  # If set to false then the shortcuts use a generic Firefox icon
  "browser.shell.shortcutFavicons" = false;

  ##  TTPS (SSL/TLS / OCSP / CERTS / HPKP)
  # Your cipher and other settings can be used in server side fingerprinting
  # See:
  #  <https://www.securityartwork.es/2017/02/02/tls-client-fingerprinting-with-bro>

  # Require safe negotiation
  # From Arkenfox user.js:
  # "Blocks connections to servers that don't support RFC 5746 [2] as they're potentially vulnerable to a
  # MiTM attack. A server without RFC 5746 can be safe from the attack if it disables renegotiations
  # but the problem is that the browser can't know that. Setting this pref to true is the only way for the
  # browser to ensure there will be no unsafe renegotiations on the channel between the browser and the server"
  # Also see:
  #  <https://wiki.mozilla.org/Security:Renegotiation>
  #  <https://datatracker.ietf.org/doc/html/rfc5746>
  #  <https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2009-3555>
  # Note:
  #  SSL Labs (May 2024) reports over 99.7% of top sites have secure renegotiation
  #  - <https://www.ssllabs.com/ssl-pulse/>
  "security.ssl.require_safe_negotiation" = true;

  # Disable TLS1.3 0-RTT (round-trip time)
  # This data is not forward secret, as it is encrypted solely under keys derived using
  # the offered PSK. There are no guarantees of non-replay between connections.
  # Also see:
  #  <https://github.com/tlswg/tls13-spec/issues/1001>
  #  <https://www.rfc-editor.org/rfc/rfc9001.html#name-replay-attacks-with-0-rtt>
  #  <https://blog.cloudflare.com/tls-1-3-overview-and-q-and-a>
  "security.tls.enable_0rtt_data" = false;

  ## OCSP (Online Certificate Status Protocol)
  #  <https://scotthelme.co.uk/revocation-is-broken>
  #  <https://blog.mozilla.org/security/2013/07/29/ocsp-stapling-in-firefox>

  # Enforce OCSP fetching to confirm current validity of certificates
  #  - 0=disabled
  #  - 1=enabled (Firefox default)
  #  - 2=enabled for EV certificates only
  # OCSP (non-stapled) leaks information about the sites you visit to the CA (cert authority)
  # It's a trade-off between security (checking) and privacy (leaking info to the CA)
  # Note: his pref only controls OCSP fetching and does not affect OCSP stapling
  # Also see:
  #  <https://en.wikipedia.org/wiki/Ocsp>
  "security.OCSP.enabled" = 1;

  # Set OCSP fetch failures (non-stapled, see 1211) to hard-fail
  # When a CA cannot be reached to validate a cert, Firefox just continues the connection (=soft-fail)
  # Setting this pref to true tells Firefox to instead terminate the connection (=hard-fail)
  # From Arkenfox user.js:
  # "It is pointless to soft-fail when an OCSP fetch fails: you cannot confirm a cert is still valid (it
  # could have been revoked) and/or you could be under attack (e.g. malicious blocking of OCSP servers)"
  # Also see:
  #  <https://blog.mozilla.org/security/2013/07/29/ocsp-stapling-in-firefox>
  #  <https://www.imperialviolet.org/2014/04/19/revchecking.html>
  "security.OCSP.require" = true;

  ## CERTS / HPKP (HTTP Public Key Pinning)
  # Enable strict PKP (Public Key Pinning)
  #  - 0=disabled
  #  - 1=allow user MiTM (default; such as your antivirus)
  #  - 2=strict
  "security.cert_pinning.enforcement_level" = 2;

  # Enable CRLite
  #  - 0 = disabled
  #  - 1 = consult CRLite but only collect telemetry
  #  - 2 = consult CRLite and enforce both "Revoked" and "Not Revoked" results
  #  - 3 = consult CRLite and enforce "Not Revoked" results, but defer to OCSP for "Revoked" (default)
  # Also see:
  #  <https://bugzilla.mozilla.org/buglist.cgi?bug_id=1429800,1670985,1753071>
  #  <https://blog.mozilla.org/security/tag/crlite>
  "security.remote_settings.crlite_filters.enabled" = true;
  "security.pki.crlite_mode" = 2;

  ## Mixed Content

  # [BREAKING] Disable insecure passive content (such as images) on https pages
  # "security.mixed_content.block_display_content" = true;

  # Enable HTTPS-Only mode in all windows
  # When the top-level is HTTPS, insecure subresources are also upgraded
  "dom.security.https_only_mode" = true;

  # Disable HTTP background requests
  # From Arkenfox user.js:
  # "When attempting to upgrade, if the server doesn't respond within 3 seconds, Firefox sends
  # a top-level HTTP request without path in order to check if the server supports HTTPS or not
  # his is done to avoid waiting for a timeout which takes 90 seconds"
  # See:
  #  <https://bugzilla.mozilla.org/buglist.cgi?bug_id=1642387,1660945>
  "dom.security.https_only_mode_send_http_background_request" = false;

  ## User Interface (UI)
  # Display warning on the padlock for "broken security"
  # Also see:
  #  <https://wiki.mozilla.org/Security:Renegotiation>
  #  <https://bugzilla.mozilla.org/1353705>
  "security.ssl.treat_unsafe_negotiation_as_broken" = true;

  # Display advanced information on Insecure Connection warning pages
  # !!! Only works when it's possible to add an exception, i.e., it does
  # NOT work for HSTS discrepancies (https://subdomain.preloaded-hsts.badssl.com/) !!!
  # See https://expired.badssl.com/ for testing.
  "browser.xul.error_pages.expert_bad_cert" = true;

  ## REFERRERS
  # See:
  #  <https://feeding.cloud.geek.nz/posts/tweaking-referrer-for-privacy-in-firefox/>

  # Control the amount of cross-origin information to send
  #  - 0=send full URI (Firefox default)
  #  - 1=scheme+host+port+path
  #  - 2=scheme+host+port
  "network.http.referer.XOriginTrimmingPolicy" = 2;

  ## CONTAINERS

  # Enable Container Tabs and its UI setting
  "privacy.userContext.enabled" = true;
  "privacy.userContext.ui.enabled" = true;

  # Set behavior on "+ Tab" button to display container menu on left click
  # Note: The menu is always shown on long press and right click
  "privacy.userContext.newTabContainerOnLeftClick.enabled" = false;

  # Set external links to open in site-specific containers
  # Depending on your container extension(s) and their settings
  #  - true=Firefox will not choose a container (so your extension can)
  #  - false=Firefox will choose the container/no-container (default)
  # See:
  #  <https://bugzilla.mozilla.org/1874599>
  "browser.link.force_default_user_context_id_for_external_opens" = true;

  ## PLUGINS / MEDIA / WEBRTC

  # Force WebRTC inside the proxy
  "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;

  # Force a single network interface for ICE candidates generation
  # When using a system-wide proxy, it uses the proxy interface
  # Also see:
  #  <https://developer.mozilla.org/docs/Web/API/RTCIceCandidate>
  #  <https://wiki.mozilla.org/Media/WebRTC/Privacy>
  "media.peerconnection.ice.default_address_only" = true;

  # Force exclusion of private IPs from ICE candidates
  # Note: This will protect your private IP even in TRUSTED scenarios after you
  # grant device access, but often results in breakage on video-conferencing platforms
  "media.peerconnection.ice.no_host" = true;

  # Disable GMP (Gecko Media Plugins)
  # See:
  # <https://wiki.mozilla.org/GeckoMediaPlugins>
  # "media.gmp-provider.enabled" = false;

  ## DOM (DOCUMENT OBJECT MODEL)
  # Prevent scripts from moving and resizing open windows
  "dom.disable_window_move_resize" = true;

  ## MISCELLANEOUS
  # Remove temp files opened from non-PB windows with an external application
  # See:
  #  <https://bugzilla.mozilla.org/buglist.cgi?bug_id=302433,1738574>
  "browser.download.start_downloads_in_tmp_dir" = true;
  "browser.helperApps.deleteTempFileOnExit" = true;

  # Disable UITour backend so there is no chance that a remote page can use it
  "browser.uitour.enabled" = false;
  "browser.uitour.url" = "";

  # Reset remote debugging to disabled
  # Also see:
  #  <https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/16222>
  "devtools.debugger.remote-enabled" = false;

  # Disable websites overriding Firefox's keyboard shortcuts
  #  - 0 (Firefox default)
  #  - 1=allow
  #  - 2=block
  "permissions.default.shortcuts" = 2;

  # Remove special permissions for certain mozilla domains
  "permissions.manager.defaultsUrl" = "";

  # Use Punycode in Internationalized Domain Names to eliminate possible spoofing
  # Note: Might be undesirable for non-latin alphabet users since legitimate IDN's
  # are also punycoded. Test here: https://www.xn--80ak6aa92e.com/
  # Also see:
  #  <https://wiki.mozilla.org/IDN_Display_Algorithm>
  #  <https://en.wikipedia.org/wiki/IDN_homograph_attack>
  #  <https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=punycode+firefox>
  #  <https://www.xudongz.com/blog/2017/idn-phishing>
  "network.IDN_show_punycode" = true;

  # Enforce PDFJS, disable PDFJS scripting
  # From Arkenfox user.js:
  # 'This setting controls if the option "Display in Firefox" is available in the setting below
  # and by effect controls whether PDFs are handled in-browser or externally ("Ask" or "Open With")'
  # Note: JS can still force a pdf to open in-browser by bundling its own code
  # You may prefer a different pdf reader for security/workflow reasons
  # Also see:
  #  <https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=pdf.js+firefox>
  "pdfjs.disabled" = false; # default: false
  "pdfjs.enableScripting" = false;

  # Disable middle click on new tab button opening URLs or searches using clipboard
  "browser.tabs.searchclipboardfor.middleclick" = false;

  # Disable content analysis by DLP (Data Loss Prevention) agents
  # DLP agents are background processes on managed computers that allow enterprises to monitor locally running
  # applications for data exfiltration events, which they can allow/block based on customer defined DLP policies.
  #  - 0=Block all requests
  #  - 1=Warn on all requests (which lets the user decide)
  #  - 2=Allow all requests
  # See:
  #  <https://github.com/chromium/content_analysis_sdk>
  "browser.contentanalysis.enabled" = false;
  "browser.contentanalysis.default_result" = 0;

  ## DOWNLOADS
  # Enable user interaction for security by always asking where to download
  "browser.download.useDownloadDir" = false;

  # Disable downloads panel opening on every download
  "browser.download.alwaysOpenPanel" = false;

  # Disable adding downloads to the system's "recent documents" list
  "browser.download.manager.addToRecentDocs" = false;

  # Enable user interaction for security by always asking how to handle new mimetypes
  "browser.download.always_ask_before_handling_new_types" = true;

  ## EXTENSIONS
  # Limit allowed extension directories
  #  - 1=profile
  #  - 2=user
  #  - 4=application
  #  - 8=system
  #  - 16=temporary
  #  -31=all
  # The pref value represents the sum: e.g. 5 would be profile and application directories
  # !!! Breaks usage of files which are installed outside allowed directories !!!
  "extensions.enabledScopes" = 5; # profile & application directories

  # Disable bypassing 3rd party extension install prompts
  # See:
  #  <https://bugzilla.mozilla.org/buglist.cgi?bug_id=1659530,1681331>
  "extensions.postDownloadThirdPartyPrompt" = false;

  # Disable webextension restrictions on certain mozilla domains
  # See:
  #  <https://bugzilla.mozilla.org/buglist.cgi?bug_id=1384330,1406795,1415644,1453988>
  "extensions.webextensions.restrictedDomains" = "";

  ## ETP (ENHANCED TRACKING PROTECTION)

  # Enable ETP Strict Mode
  # ETP Strict Mode enables Total Cookie Protection (TCP)
  # Note: Adding site exceptions disables all ETP protections for that site and increases the risk of
  # cross-site state tracking e.g. exceptions for SiteA and SiteB means PartyC on both sites is shared
  # See:
  #  <https://blog.mozilla.org/security/2021/02/23/total-cookie-protection>
  "browser.contentblocking.category" = "strict";
  "browser.contentblocking.report.monitor.enabled" = false; # default: false
  "browser.contentblocking.report.monitor.home_page_url" = "";

  # Disable ETP web compat features
  # Includes skip lists, heuristics (SmartBlock) and automatic grants
  # Opener and redirect heuristics are granted for 30 days.
  # See:
  #  <https://blog.mozilla.org/security/2021/07/13/smartblock-v2/>
  #  <https://hg.mozilla.org/mozilla-central/rev/e5483fd469ab#l4.12>
  #  <https://developer.mozilla.org/docs/Web/Privacy/State_Partitioning#storage_access_heuristics>
  "privacy.antitracking.enableWebcompat" = false;

  ## SHUTDOWN & SANITIZING

  # Enable Firefox to clear items on shutdown
  # Note: In FF129+ clearing "siteSettings" on shutdown (2811), or manually via site data (2820) and
  # via history (2830), will no longer remove sanitize on shutdown "cookie and site data" site exception
  "privacy.sanitize.sanitizeOnShutdown" = security.sanitizeOnShutdown.enable;

  # Set/enforce what items to clear on shutdown
  # Note: If "history" is true, downloads will also be cleared
  "privacy.clearOnShutdown_v2.cache" = security.sanitizeOnShutdown.sanitize.cache;
  "privacy.clearOnShutdown_v2.downloads" = security.sanitizeOnShutdown.sanitize.downloads;
  "privacy.clearOnShutdown_v2.formdata" = security.sanitizeOnShutdown.sanitize.formdata;
  "privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = security.sanitizeOnShutdown.sanitize.history;
  "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = false;
  "privacy.clearOnShutdown_v2.siteSettings" = security.sanitizeOnShutdown.sanitize.siteSettings;

  # Set Session Restore to clear on shutdown
  "privacy.clearOnShutdown.openWindows" = security.noSessionRestore; #  Not needed if Session Restore is not used

  ## SANITIZE ON SHUTDOWN: RESPECTS "ALLOW" SITE EXCEPTIONS FF103+ | v2 migration is FF128+ ***/
  # Set "Cookies" and "Site Data" to clear on shutdown (if 2810 is true) [SETUP-CHROME]
  # Exceptions: A "cookie" permission also controls "offlineApps" (see note below). For cross-domain logins,
  # add exceptions for both sites e.g. https://www.youtube.com (site) + https://accounts.google.com (single sign on)
  #  - "offlineApps": Offline Website Data: localStorage, service worker cache, QuotaManager (IndexedDB, asm-cache)
  #  - "sessions": Active Logins (has no site exceptions): refers to HTTP Basic Authentication, not logins via cookies
  # !!! Be selective with what sites you "Allow", as they also disable partitioning !!!
  #
  # Note: To add site exceptions: Ctrl+I > Permissions > Cookies > Allow (when on the website in question)
  # XXX: There is no declarative way to to manage site exceptions.
  #
  # See:
  #  <https://en.wikipedia.org/wiki/Basic_access_authentication>
  # "privacy.clearOnShutdown.cookies" = true;
  # "privacy.clearOnShutdown.offlineApps" = true;
  # "privacy.clearOnShutdown.sessions" = true;
  # "privacy.clearOnShutdown_v2.cookiesAndStorage" = true;

  ## SANITIZE SITE DATA: IGNORES "ALLOW" SITE EXCEPTIONS
  # Set manual "Clear Data" items
  # Firefox remembers your last choices. This will reset them when you start Firefox
  # "privacy.clearSiteData.cache" = true;
  # "privacy.clearSiteData.cookiesAndStorage" = false; # keep false until it respects "allow" site exceptions
  # "privacy.clearSiteData.historyFormDataAndDownloads" = true;
  # "privacy.clearSiteData.siteSettings" = true;
  # "privacy.cpd.openWindows" = false;
  # "privacy.cpd.passwords" = false;
  # "privacy.cpd.siteSettings" = false;
  # "privacy.clearHistory.siteSettings" = false;

  ## SANITIZE MANUAL: TIMERANGE
  # Set "Time range to clear" for "Clear Data" and "Clear History"
  # Firefox remembers your last choice. This will reset the value when you start Firefox
  #  - 0=everything
  #  - 1=last hour
  #  - 2=last two hours
  #  - 3=last four hours
  #  - 4=today
  # Note: Values 5 (last 5 minutes) and 6 (last 24 hours) are not listed in the dropdown,
  # which will display a blank value, and are not guaranteed to work
  "privacy.sanitize.timeSpan" = 0;

  ## FPP (fingerprintingProtection)
  # RFP overrides FPP
  # From Arkenfox user.js:
  # "In FF118+ FPP is on by default in private windows and in FF119+ is controlled
  # by ETP. FPP will also use Remote Services in future to relax FPP protections
  # on a per site basis for compatibility."
  # Also see:
  #  <https://searchfox.org/mozilla-central/source/toolkit/components/resistfingerprinting/RFPTargetsDefault.inc>

  # Set RFP new window size max rounded values
  # Sizes round down in hundreds: width to 200s and height to 100s, to fit your screen
  # See:
  #  <https://bugzilla.mozilla.org/1330882>
  "privacy.window.maxInnerWidth" = 1600;
  "privacy.window.maxInnerHeight" = 900;

  # Dynamically resizes the inner window by applying margins in stepped ranges
  "privacy.resistFingerprinting.letterboxing" = true;

  # Disable mozAddonManager Web API
  # See:
  #  <https://bugzilla.mozilla.org/buglist.cgi?bug_id=1384330,1406795,1415644,1453988>
  "privacy.resistFingerprinting.block_mozAddonManager" = true;

  # Disable RFP spoof English prompt
  #  - 0=prompt
  #  - 1=disabled
  #  - 2=enabled
  # Note: when changing from value 2, preferred languages ('intl.accept_languages') is not reset, and
  # sets 'en-US, en' for displaying pages and 'en-US' as locale.
  "privacy.spoof_english" = 1;

  # Disable using system colors
  "browser.display.use_system_colors" = false;
  "widget.non-native-theme.use-theme-accent" = false;

  # Enforce links targeting new windows to open in a new tab instead
  #  - 1=most recent window or tab
  #  - 2=new window
  #  - 3=new tab
  # Stops malicious window sizes and some screen resolution leaks.
  # You can still right-click a link and open in a new window.
  # To test: https://arkenfox.github.io/TZP/tzp.html#screen
  # See:
  #  <https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/9881>
  "browser.link.open_newwindow" = 3; # default: 3

  # Set all open window methods to abide by "browser.link.open_newwindow"
  # See:
  #  <https://searchfox.org/mozilla-central/source/dom/tests/browser/browser_test_new_window_from_content.js>
  "browser.link.open_newwindow.restriction" = 0;

  # Disable WebGL (Web Graphics Library)
  "webgl.disabled" = cfg.misc.disableWebgl;

  ## OPTIONAL OPSEC
  # Disk avoidance, application data isolation, eyeballs

  # Disable saving passwords
  # Note: This does not clear any passwords already saved
  # Prefer using a dedicated password manager instead.
  "signon.rememberSignons" = false;

  ## Optional Hardening
  # Enforce Firefox blocklist
  # Warning: this is a dial-home feature! Set to
  # false explicitly if this is undesirable.
  "extensions.blocklist.enabled" = true;

  # Don't enforce no referer spoofing
  # Spoofing can affect CSRF (Cross-Site Request Forgery) protections
  "network.http.referer.spoofSource" = false;

  # Enforce a security delay on some confirmation dialogs such as install, open/save
  # See:
  #  <https://www.squarefree.com/2004/07/01/race-conditions-in-security-dialogs>
  "security.dialog_enable_delay" = 1000;

  # Enforce no First Party Isolation
  # Warning: Replaced with network partitioning (FF85+) and TCP (2701), and enabling FPI
  # disables those. FPI is no longer maintained except at Tor Project for Tor Browser's config
  "privacy.firstparty.isolate" = false;

  # Enforce SmartBlock shims (about:compat)
  # See:
  #  <https://blog.mozilla.org/security/2021/03/23/introducing-smartblock/>
  "extensions.webcompat.enable_shims" = true;

  # Enforce no TLS 1.0/1.1 downgrades
  # To test: https://tls-v1-1.badssl.com:1010/
  "security.tls.version.enable-deprecated" = false;

  # Enforce disabling of Web Compatibility Reporter
  # Web Compatibility Reporter adds a "Report Site Issue" button to send data to Mozilla
  "extensions.webcompat-reporter.enabled" = false;

  # Enforce Quarantined Domains
  # See:
  #  <https://support.mozilla.org/kb/quarantined-domains>
  "extensions.quarantinedDomains.enabled" = true;

  ## Schizofox Policies

  # Enable `@-moz-document` media query
  "layout.css.moz-document.content.enabled" = true;

  # Set default page colors
  "browser.display.background_color.dark" = "#${background}";
  "browser.display.focus_background_color.dark" = "#${background-darker}";
  "browser.display.foreground_color.dark" = "#${foreground}";
  "browser.display.focus_text_color" = "#${foreground}";

  # Do not tell what plugins do we have enabled.
  # See:
  #  <https://mail.mozilla.org/pipermail/firefox-dev/2013-november/001186.html>
  # To test: https://www.deviceinfo.me/
  "plugins.enumerable_names" = "";

  # Disable Firefox View Button
  # Note: currently does not work, and must be managed imperatively.
  # XXX: Enterprise policy might be able to resolve this.
  "browser.tabs.firefox-view" = false;

  # Whether to display bookmarks in the Toolbar
  "browser.toolbars.bookmarks.visibility" = cfg.misc.displayBookmarksInToolbar;
  "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

  # Disable addon signatures
  # Note: this is a security flaw, but it is necessary
  # for custom Dark Reader builds.
  "xpinstall.signatures.required" = false;

  "browser.eme.ui.enabled" = cfg.misc.drm.enable;
  "media.eme.ui.enabled" = cfg.misc.drm.enable;

  # User agent
  "general.useragent.override" = cfg.security.userAgent;

  # Keybindings
  "ui.key.textcontrol.prefer_native_key_bindings_over_builtin_shortcut_key_definitions" = true;
  # https://searchcode.com/codesearch/view/26755902/
  # default - 17 (ctrl)
  "ui.key.accelKey" = 17;
  # default - 18 (alt)
  "ui.key.menuAccessKey" = 18;
  "ui.key.menuAccessKeyFocuses" = true;

  # Release notes and vendor URLs
  "app.releaseNotesURL" = "http://127.0.0.1/";
  "app.vendorURL" = "http://127.0.0.1/";
  "app.privacyURL" = "http://127.0.0.1/";

  # Disable plugin installer
  "plugins.hide_infobar_for_missing_plugin" = true;
  "plugins.hide_infobar_for_outdated_plugin" = true;
  "plugins.notifyMissingFlash" = false;

  # Speeding it up
  "network.http.pipelining" = true;
  "network.http.proxy.pipelining" = true;
  "network.http.pipelining.maxrequests" = 10;
  "nglayout.initialpaint.delay" = 0;
  "nglayout.initialpaint.delay_in_oopif" = 0;
  "browser.startup.preXulSkeletonUI" = false;
  "content.notify.interval" = 100000;

  # Disable session restore
  "browser.sessionstore.resume_from_crash" = !cfg.security.noSessionRestore;

  # query stripping
  "privacy.query_stripping.strip_list" = "__hsfp __hssc __hstc __s _hsenc _openstat dclid fbclid gbraid gclid hsCtaTracking igshid mc_eid ml_subscriber ml_subscriber_hash msclkid oft_c oft_ck oft_d oft_id oft_ids oft_k oft_lk oft_sk oly_anon_id oly_enc_id rb_clickid s_cid twclid vero_conv vero_id wbraid wickedid yclid";
  # Extensions cannot be updated without permission
  "extensions.update.enabled" = false;

  "media.autoplay.default" = 5;

  "intl.accept_languages" = "en-US, en";

  # Allow unsigned langpacks
  "extensions.langpacks.signatures.required" = false;

  # Disable default browser checking.
  "browser.shell.checkDefaultBrowser" = false;

  # Prevent EULA dialog to popup on first run
  "browser.EULA.override" = true;

  # Don't disable extensions dropped in to a system
  # location, or those owned by the application
  "extensions.autoDisableScopes" = 3;

  # Disable dial-home features.
  "app.update.url" = "http://127.0.0.1/";
  "startup.homepage_welcome_url" = "";
  "browser.startup.homepage_override.mstone" = "ignore";

  # Help url
  "app.support.baseURL" = "http://127.0.0.1/";
  "app.support.inputURL" = "http://127.0.0.1/";
  "app.feedback.baseURL" = "http://127.0.0.1/";
  "browser.uitour.themeOrigin" = "http://127.0.0.1/";
  "plugins.update.url" = "http://127.0.0.1/";
  "browser.customizemode.tip0.learnMoreUrl" = "http://127.0.0.1/";

  # Privacy & Freedom Issues
  "browser.translation.engine" = "";
  "media.gmp-provider.enabled" = false;
  "browser.urlbar.update2.engineAliasRefresh" = true;
  "browser.newtabpage.activity-stream.feeds.topsites" = false;

  "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
  "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
  "browser.urlbar.suggest.engines" = false;
  "browser.urlbar.suggest.topsites" = false;

  "browser.discovery.containers.enabled" = false;
  "browser.discovery.enabled" = false;
  "browser.discovery.sites" = "http://127.0.0.1/";
  "services.sync.prefs.sync.browser.startup.homepage" = false;
  "dom.ipc.plugins.flash.subprocess.crashreporter.enabled" = false;
  "browser.safebrowsing.downloads.remote.url" = "";
  "browser.safebrowsing.enabled" = false;
  "browser.safebrowsing.malware.enabled" = false;
  "browser.safebrowsing.provider.google4.dataSharingURL" = "";
  "browser.safebrowsing.provider.google4.gethashURL" = "";
  "browser.safebrowsing.provider.google4.updateURL" = "";
  "browser.safebrowsing.provider.google.gethashURL" = "";
  "browser.safebrowsing.provider.google.updateURL" = "";
  "browser.safebrowsing.provider.mozilla.gethashURL" = "";
  "browser.safebrowsing.provider.mozilla.updateURL" = "";
  "services.sync.privacyURL" = "http://127.0.0.1/";
  "social.enabled" = false;
  "social.remote-install.enabled" = false;
  "datareporting.usage.uploadEnabled" = false;
  "datareporting.healthreport.about.reportUrl" = "http://127.0.0.1/";
  "datareporting.healthreport.service.enabled" = false;
  "datareporting.healthreport.documentServerURI" = "http://127.0.0.1/";
  "healthreport.uploadEnabled" = false;
  "social.toast-notifications.enabled" = false;
  "browser.slowStartup.notificationDisabled" = true;
  "network.http.sendRefererHeader" = 2;
  "browser.ml.chat.enabled" = false;

  # Prevent sites from taking over copy/paste
  "dom.event.clipboardevents.enabled" = false;
  # Prevent sites from taking over right click
  "dom.event.contextmenu.enabled" = cfg.misc.contextMenu.enable;

  # Disable gamepad API to prevent USB device enumeration
  # https://www.w3.org/TR/gamepad/
  # https://trac.torproject.org/projects/tor/ticket/13023
  "dom.gamepad.enabled" = false;

  # APS
  "privacy.partition.always_partition_third_party_non_cookie_storage" = true;
  "privacy.partition.always_partition_third_party_non_cookie_storage.exempt_sessionstorage" = false;

  "devtools.selfxss.count" = 0;

  # We don't want to send the Origin header
  "network.http.originextension" = false;
  "network.user_prefetch-next" = false;
  "network.http.sendSecureXSiteReferrer" = false;
  "experiments.manifest.uri" = "";

  "plugin.state.flash" = 0;
  "browser.search.update" = false;

  # Disable sensors
  "dom.battery.enabled" = false;
  "device.sensors.enabled" = false;
  "camera.control.face_detection.enabled" = false;
  "camera.control.autofocus_moving_callback.enabled" = false;

  # No search suggestions
  "browser.urlbar.userMadeSearchSuggestionsChoice" = true;

  # Always ask before restoring the browsing session
  "browser.sessionstore.max_resumed_crashes" = 0;

  # Don't ping Mozilla for MitM detection, see <https://bugs.torproject.org/32321>
  "security.certerrors.mitm.priming.enabled" = false;
  "security.certerrors.recordEventTelemetry" = false;

  # Disable shield/heartbeat
  "extensions.shield-recipe-client.enabled" = false;
  "browser.selfsupport.url" = "";

  # Don't download ads for the newtab page
  "browser.newtabpage.directory.source" = "";
  "browser.newtabpage.directory.ping" = "";
  "browser.newtabpage.introShown" = true;

  # Disable geolocation
  "geo.enabled" = false;
  "geo.wifi.uri" = "";
  "browser.search.geoip.url" = "";
  "browser.search.geoSpecificDefaults" = false;
  "browser.search.geoSpecificDefaults.url" = "";
  "browser.search.modernConfig" = false;

  # Canvas fingerprint protection
  "privacy.resistFingerprinting" = true;
  "privacy.trackingprotection.cryptomining.enabled" = true;
  "privacy.trackingprotection.fingerprinting.enabled" = true;

  # Services
  "gecko.handlerService.schemes.mailto.0.name" = "";
  "gecko.handlerService.schemes.mailto.1.name" = "";
  "handlerService.schemes.mailto.1.uriTemplate" = "";
  "gecko.handlerService.schemes.mailto.0.uriTemplate" = "";
  "browser.contentHandlers.types.0.title" = "";
  "browser.contentHandlers.types.0.uri" = "";
  "browser.contentHandlers.types.1.title" = "";
  "browser.contentHandlers.types.1.uri" = "";
  "gecko.handlerService.schemes.webcal.0.name" = "";
  "gecko.handlerService.schemes.webcal.0.uriTemplate" = "";
  "gecko.handlerService.schemes.irc.0.name" = "";
  "gecko.handlerService.schemes.irc.0.uriTemplate" = "";

  "font.default.x-western" = "sans-serif";

  "extensions.getAddons.langpacks.url" = "http://127.0.0.1/";
  "lightweightThemes.getMoreURL" = "http://127.0.0.1/";
  "browser.geolocation.warning.infoURL" = "";
  "browser.xr.warning.infoURL" = "";

  # Mobile
  "privacy.announcements.enabled" = false;
  "browser.snippets.enabled" = false;
  "browser.snippets.syncPromo.enabled" = false;
  "identity.mobilepromo.android" = "http://127.0.0.1/";
  "browser.snippets.geoUrl" = "http://127.0.0.1/";
  "browser.snippets.updateUrl" = "http://127.0.0.1/";
  "browser.snippets.statsUrl" = "http://127.0.0.1/";
  "datareporting.policy.firstRunTime" = 0;
  "datareporting.policy.dataSubmissionPolicyVersion" = 2;
  "browser.webapps.checkForUpdates" = 0;
  "browser.webapps.updateCheckUrl" = "http://127.0.0.1/";
  "app.faqURL" = "http://127.0.0.1/";

  # PFS url
  "pfs.datasource.url" = "http://127.0.0.1/";
  "pfs.filehint.url" = "http://127.0.0.1/";

  # Disable Link to FireFox Marketplace, currently loaded with non-free "apps"
  "browser.apps.URL" = "";

  # Disable Firefox Hello
  "loop.enabled" = false;

  # Use old style user_preferences, that allow javascript to be disabled
  "browser.user_preferences.inContent" = false;

  # Disable home snippets
  "browser.aboutHomeSnippets.updateUrl" = "data:text/html";

  # In <about:user_preferences>, hide "More from Mozilla"
  "browser.user_preferences.moreFromMozilla" = false;

  # Disable SSDP
  "browser.casting.enabled" = false;

  # Disable directory service
  "social.directories" = "";

  # Don't report TLS errors to Mozilla
  "security.ssl.errorReporting.enabled" = false;

  # Crypto hardening
  # https://gist.github.com/haasn/69e19fc2fe0e25f3cff5
  # General settings
  "security.tls.unrestricted_rc4_fallback" = false;
  "security.tls.insecure_fallback_hosts.use_static_list" = false;
  "security.tls.version.min" = 3;
  "security.ssl3.rsa_seed_sha" = true;

  # Avoid logjam attack
  "security.ssl3.dhe_rsa_aes_128_sha" = false;
  "security.ssl3.dhe_rsa_aes_256_sha" = false;
  "security.ssl3.dhe_dss_aes_128_sha" = false;

  # Disable Pocket integration
  "browser.pocket.enabled" = false;
  "extensions.pocket.enabled" = false;

  # Disable More from Mozilla
  "browser.preferences.moreFromMozilla" = false;

  # Enable extensions by default in private mode
  "extensions.allowPrivateBrowsingByDefault" = true;

  # Disable screenshots extension
  "extensions.screenshots.disabled" = true;

  # Disable onboarding
  "browser.onboarding.newtour" = "performance,private,addons,customize,default";
  "browser.onboarding.updatetour" = "performance,library,singlesearch,customize";
  "browser.onboarding.enabled" = false;

  # New tab settings
  "browser.newtabpage.activity-stream.showTopSites" = false;
  "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
  "browser.newtabpage.activity-stream.disableSnippets" = true;
  "browser.newtabpage.activity-stream.tippyTop.service.endpoint" = "";
  "browser.newtabpage.activity-stream.showWeather" = false;

  # Enable xrender
  "gfx.xrender.enabled" = true;

  # Disable push notifications
  "dom.webnotifications.enabled" = false;
  "dom.push.enabled" = false;

  # Disable recommended extensions
  "browser.newtabpage.activity-stream.asrouter.useruser_prefs.cfr" = false;
  "extensions.htmlaboutaddons.discover.enabled" = false;

  # Disable the settings server
  "services.settings.server" = "";

  # Disable use of WiFi region/location information
  "browser.region.network.scan" = false;
  "browser.region.network.url" = "";
  "browser.region.update.enabled" = false;

  # Disable VPN/mobile promos
  "browser.contentblocking.report.hide_vpn_banner" = true;
  "browser.contentblocking.report.mobile-ios.url" = "";
  "browser.contentblocking.report.mobile-android.url" = "";
  "browser.contentblocking.report.show_mobile_app" = false;
  "browser.contentblocking.report.vpn.enabled" = false;
  "browser.contentblocking.report.vpn.url" = "";
  "browser.contentblocking.report.vpn-promo.url" = "";
  "browser.contentblocking.report.vpn-android.url" = "";
  "browser.contentblocking.report.vpn-ios.url" = "";
  "browser.privatebrowsing.promoEnabled" = false;

  # https://support.mozilla.org/en-US/kb/privacy-preserving-attribution
  "dom.private-attribution.submission.enabled" = false;

  # Show more ssl cert infos
  "security.identityblock.show_extended_validation" = true;

  # Purge session icon in Private Browsing windows
  "browser.privatebrowsing.resetPBM.enabled" = true;

  # Disable url trimming
  "browser.urlbar.trimURLs" = false;

  # Whether to enable Firefox AI Runtime features
  "browser.ml.enable" = cfg.misc.aiRuntime.enable;
  "browser.ml.modelHubRootUrl" = cfg.misc.aiRuntime.url;

  # Enable creation of Text Fragment URLs
  "dom.text_fragments.create_text_fragment.enabled" = true;
}
