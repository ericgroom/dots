{ pkgs, ... }:

let
  # Workaround for https://github.com/NixOS/nixpkgs/issues/579204
  # The nixpkgs wrapper sets CLAUDE_CODE_CERT_STORE=system, which on darwin reads
  # the keychain (no public roots) and breaks TLS. Remove once fixed upstream.
  claude-code =
    if pkgs.stdenv.isDarwin then
      pkgs.symlinkJoin {
        name = "claude-code-${pkgs.claude-code.version}";
        paths = [ pkgs.claude-code ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/claude \
            --set NODE_EXTRA_CA_CERTS "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
        '';
      }
    else
      pkgs.claude-code;
in
{
  home.packages = [
    pkgs.herdr
    claude-code
  ];
  programs.mise = {
    enable = true;
    enableFishIntegration = true;
  };
}
