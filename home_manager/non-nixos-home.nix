{ config, pkgs, ... }:

let
nix-env-fish = pkgs.fetchFromGitHub {
  owner = "lilyball";
  repo = "nix-env.fish";
  rev = "00c6cc762427efe08ac0bd0d1b1d12048d3ca727";
  sha256 = "1hrl22dd0aaszdanhvddvqz3aq40jp9zi2zn0v1hjnf7fx4bgpma";
};
in
{
  home.file.".config/fish/conf.d/nix-env.fish" = {
    source = "${nix-env-fish}/conf.d/nix-env.fish";
  };
}
