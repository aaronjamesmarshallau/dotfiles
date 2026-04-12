final: prev: {
  vintagestory = prev.vintagestory.overrideAttrs (old: rec{
    pname="vintagestory";
    version="1.21.6";

    src = prev.fetchurl {
      url = "https://cdn.vintagestory.at/gamefiles/stable/vs_client_linux-x64_${version}.tar.gz";
      hash = "sha256-LkiL/8W9MKpmJxtK+s5JvqhOza0BLap1SsaDvbLYR0c=";
    };
  });
}
