final: prev: {
  vintagestory = prev.vintagestory.overrideAttrs (old: rec{
    pname="vintagestory";
    version="1.21.5";

    src = prev.fetchurl {
      url = "https://cdn.vintagestory.at/gamefiles/stable/vs_client_linux-x64_${version}.tar.gz";
      hash = "sha256-dG1D2Buqht+bRyxx2ie34Z+U1bdKgi5R3w29BG/a5jg=";
    };
  });
}
