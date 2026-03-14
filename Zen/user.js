// Zen Browser user.js — Portable preferences.
//
// This file is copied into the active Zen profile during bootstrap.
// Zen reads it on startup and applies these preferences over prefs.js.
//
// To update: change settings in Zen, then run sync.sh to detect drift.

// =============================================================================
// Fonts
// =============================================================================

user_pref("font.default.x-western", "sans-serif");
user_pref("font.minimum-size.x-western", 13);
user_pref("font.name.monospace.x-western", "PTMono Nerd Font");
user_pref("font.name.sans-serif.x-western", "Raleway");
user_pref("font.name.serif.x-western", "Nunito Sans");
user_pref("font.size.monospace.x-western", 15);

// =============================================================================
// Privacy & Security
// =============================================================================

// Content blocking: custom category
user_pref("browser.contentblocking.category", "custom");

// Tracking protection
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);
user_pref("privacy.trackingprotection.emailtracking.enabled", true);

// Fingerprinting protection
user_pref("privacy.fingerprintingProtection", true);

// Global Privacy Control
user_pref("privacy.globalprivacycontrol.was_ever_enabled", true);

// HTTPS-only mode
user_pref("dom.security.https_only_mode_ever_enabled", true);

// DNS over HTTPS (Cloudflare)
user_pref("network.trr.mode", 3);
user_pref("network.trr.uri", "https://mozilla.cloudflare-dns.com/dns-query");

// Disable DNS prefetching and speculative connections
user_pref("network.dns.disablePrefetch", true);
user_pref("network.http.speculative-parallel-limit", 0);
user_pref("network.prefetch-next", false);

// Disable password saving (use 1Password instead)
user_pref("signon.rememberSignons", false);

// Disable form autofill
user_pref("extensions.formautofill.addresses.enabled", false);
user_pref("extensions.formautofill.creditCards.enabled", false);

// Clear form data on shutdown
user_pref("privacy.clearOnShutdown_v2.formdata", true);

// Disable telemetry upload
user_pref("datareporting.usage.uploadEnabled", false);

// Cookie behavior (0 = accept all)
user_pref("network.cookie.cookieBehavior", 0);

// =============================================================================
// UI & Behavior
// =============================================================================

// Ctrl+Tab sorts by recently used
user_pref("browser.ctrlTab.sortByRecentlyUsed", true);

// Smooth scrolling
user_pref("general.smoothScroll", true);

// AI/ML features
user_pref("browser.ml.enable", true);

// about:config warning disabled
user_pref("browser.aboutConfig.showWarning", false);

// Sidebar hidden by default
user_pref("sidebar.visibility", "hide-sidebar");

// Picture-in-picture when switching tabs
user_pref("media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled", true);

// =============================================================================
// Zen-specific
// =============================================================================

// Accent color (pink)
user_pref("zen.theme.accent-color", "#ffb1c0");

// URL bar behavior
user_pref("zen.urlbar.behavior", "float");

// Tabs
user_pref("zen.tabs.dim-pending", false);
user_pref("zen.tabs.show-newtab-vertical", false);

// Workspaces
user_pref("zen.workspaces.container-specific-essentials-enabled", true);
user_pref("zen.workspaces.continue-where-left-off", true);
user_pref("zen.workspaces.show-workspace-indicator", true);

// Compact mode
user_pref("zen.view.compact.enable-at-startup", false);
user_pref("zen.view.use-single-toolbar", false);

// Swipe
user_pref("zen.swipe.is-fast-swipe", false);

// Keyboard shortcuts
user_pref("zen.keyboard.shortcuts", "{\"zenSplitViewGrid\":{\"ctrl\":true,\"alt\":true,\"shift\":false,\"meta\":false,\"key\":\"G\"},\"zenSplitViewVertical\":{\"ctrl\":true,\"alt\":true,\"shift\":false,\"meta\":false,\"key\":\"V\"},\"zenSplitViewHorizontal\":{\"ctrl\":true,\"alt\":true,\"shift\":false,\"meta\":false,\"key\":\"H\"},\"zenSplitViewClose\":{\"ctrl\":true,\"alt\":true,\"shift\":false,\"meta\":false,\"key\":\"U\"},\"zenChangeWorkspace\":{\"ctrl\":true,\"alt\":false,\"shift\":true,\"meta\":false,\"key\":\"E\"},\"zenToggleCompactMode\":{\"ctrl\":true,\"alt\":true,\"shift\":false,\"meta\":false,\"key\":\"C\"},\"zenToggleCompactModeSidebar\":{\"ctrl\":true,\"alt\":true,\"shift\":false,\"meta\":false,\"key\":\"S\"},\"zenToggleCompactModeToolbar\":{\"ctrl\":true,\"alt\":true,\"shift\":false,\"meta\":false,\"key\":\"T\"},\"zenToggleWebPanels\":{\"ctrl\":false,\"alt\":true,\"shift\":false,\"meta\":false,\"key\":\"P\"}}");

// Zen mods / UI customization
user_pref("uc.essentials.gap", "Normal");
user_pref("uc.essentials.transition-speed", "100ms");
user_pref("uc.essentials.width", "Normal");
user_pref("uc.pins.active-bg", false);
user_pref("uc.pins.auto-grow", false);
user_pref("uc.pins.bg", false);
user_pref("uc.pins.bg-color.pop", false);
user_pref("uc.pins.legacy-layout", false);
user_pref("uc.pins.transition-speed", "100ms");
user_pref("uc.tabs.show-separator", "essentials-shown");
user_pref("uc.workspace.icon.size", "small");

// Better Ctrl+Tab mod styling
user_pref("psu.better_ctrltab.background", "light-dark(rgba(144, 144, 144, 0.94), rgba(22, 22, 22, 0.92))");
user_pref("psu.better_ctrltab.padding", "16px");
user_pref("psu.better_ctrltab.preview_border_color", "light-dark(rgba(255, 255, 255, 0.1), rgba(1, 1, 1, 0.1))");
user_pref("psu.better_ctrltab.preview_border_width", "1px");
user_pref("psu.better_ctrltab.preview_favicon_outdent", "12px");
user_pref("psu.better_ctrltab.preview_favicon_size", "36px");
user_pref("psu.better_ctrltab.preview_focus_background", "light-dark(rgba(77, 77, 77, 0.8), rgba(204, 204, 204, 0.33))");
user_pref("psu.better_ctrltab.preview_font_size", "13px");
user_pref("psu.better_ctrltab.preview_letter_spacing", "0px");
user_pref("psu.better_ctrltab.roundness", "28px");
user_pref("psu.better_ctrltab.shadow_size", "18px");
user_pref("psu.better_ctrltab.zoom", "0.8");
user_pref("psu.tab_title_fixes.font_size", "14px");
user_pref("psu.tab_title_fixes.pending_opacity", "1.0");

// Super pins grid
user_pref("mod.superpins.essentials.grid-count", "1");
user_pref("mod.superpins.pins.grid-count", "1");

// Theme
user_pref("extensions.activeThemeID", "firefox-compact-light@mozilla.org");
