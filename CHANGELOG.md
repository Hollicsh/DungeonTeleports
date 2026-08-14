## 🧩 Addon Updates (2026-08-14)

**Mythic Dungeon Teleports** — v2.1.10

**Changes:**
- None

**Fixes:**
- zhCN and zhTW locale files were built but never loaded by the .toc — Chinese clients were silently falling back to English
- Expansion selection (defaultExpansion/selectedExpansion) was saved using translated display text instead of a stable key; switching client language could make the teleport window come up empty. Existing saved selections are migrated automatically on first login after this update
- The teleport window could attempt to rebuild its teleport buttons (secure spell buttons) while in combat — via the slash command, the minimap icon, the settings panel's "Reset to Default", and toggling the keystone module — which could throw a combat lockdown/taint error instead of just opening; button rebuilds are now deferred until combat ends
- The Group Reminder popup could likewise touch its secure teleport button while in combat (e.g. accepting a group application mid-fight); it's now deferred the same way
- Fixed a settings-panel dropdown that could double-resolve an already-translated expansion name through the localization table
- Guarded a couple of C_SpellBook lookups that assumed the table always exists
- Removed dead code in the quick-cast menu (`divider`/`colGap`) that referenced a UI element which was never created

**Known issues:**
- None currently known
