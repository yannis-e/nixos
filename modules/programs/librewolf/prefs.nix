{ config, lib, ... }:

let
  inherit (lib)
    mkOption
    types
    ;

  inherit (builtins)
    toJSON
    isBool
    isInt
    isString
    toString
    ;

  prefs = {
    # Set home page
    "browser.startup.homepage" = "about:home";

    # Don't Firefox Sync the homepage
    "services.sync.prefs.sync.browser.startup.homepage" = true;

    # Revert some security changes
    "webgl.disabled" = false;
    "librewolf.webgl.prompt" = false;
    "privacy.resistFingerprinting" = false;
    "privacy.clearOnShutdown.history" = false;
    "privacy.clearOnShutdown.cookies" = false;

    # Stop weirdness when relaunching browser sometimes
    "browser.sessionstore.resume_from_crash" = false;
    "browser.startup.couldRestoreSession.count" = 0;

    # Force hardware acceleration
    "media.hardware-video-decoding.force-enabled" = true;

    # Mouse behavior
    "middlemouse.paste" = false;
    "general.autoScroll" = true;

    # Disable touchpad overscroll
    "apz.overscroll.enabled" = false;

    # Disable smooth scrolling
    "general.smoothScroll" = true;

    # Enable Firefox accounts
    "identity.fxaccounts.enabled" = true;

    # Use system emoji fonts
    "font.name-list.emoji" = "emoji";
    "gfx.font_rendering.opentype_svg.enabled" = false;

    # Disable audio post processing
    "media.getusermedia.audio.processing.aec" = 0;
    "media.getusermedia.audio.processing.aec.enabled" = false;
    "media.getusermedia.audio.processing.agc" = 0;
    "media.getusermedia.audio.processing.agc.enabled" = false;
    "media.getusermedia.audio.processing.agc2.forced" = false;
    "media.getusermedia.audio.processing.noise" = 0;
    "media.getusermedia.audio.processing.noise.enabled" = false;
    "media.getusermedia.audio.processing.hpf.enabled" = false;

    # Disable speech dispatcher stuff
    "reader.parse-on-load.enabled" = false;
    "media.webspeech.synth.enabled" = false;

    # Disable bookmarks bar
    "browser.toolbars.bookmarks.visibility" = "never";

    # Use sans serif over serif
    "font.default.x-western" = "sans-serif";

    # Hide X button
    "browser.tabs.inTitlebar" = 0;

    # Enable compact UI
    "browser.compactmode.show" = true;
    "browser.uidensity" = 1;

    # Allow theming
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

    # Don't hide http(s):// in URL bar
    "browser.urlbar.trimURLs" = false;

    # Enable browser data backups
    "browser.backup.scheduled.enabled" = true;

    # Disable Nova
    "browser.nova.enabled" = false;
  };

  prefValue =
    pref:
    toJSON (
      if isBool pref || isInt pref || isString pref
      then pref
      else toString pref
    );

  jsPrefs =
    lib.concatMapAttrsStringSep "\n"
      (name: value:
        "lockPref(\"${name}\", ${prefValue value});"
      )
      prefs;

in
{
  options.cfg.programs.librewolf.prefs = mkOption {
    type = types.str;
    default = "";
    internal = true;
  };

  config.cfg.programs.librewolf.prefs = jsPrefs;
}
