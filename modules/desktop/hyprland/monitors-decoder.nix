# Convert config.monitors into Hyprland's Lua config format
{ lib, monitors }:
let
  inherit (builtins) concatStringsSep map toString;
in
concatStringsSep "\n" (
  map (m: ''
    hl.monitor({
        output = "${m.name}",
        mode = ${
          if m.modeline == "" then
            ''"${toString m.width}x${toString m.height}@${toString m.refreshRate}"''
          else
            ''"modeline ${m.modeline}"''
        },
        position = "${toString m.x}x${toString m.y}",
        scale = ${m.scale},
    })
    ${lib.optionalString (m.workspace != null) ''
      hl.workspace_rule({
          workspace = "${m.workspace}",
          monitor = "${m.name}",
      })
    ''}
  '') monitors
)
