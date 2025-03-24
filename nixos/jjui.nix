{ pkgs
, buildGoModule ? pkgs.buildGoModule
, fetchFromGitHub ? pkgs.fetchFromGitHub }:
buildGoModule rec {
  pname = "jjui";
  version = "0.7.2";
  src = fetchFromGitHub {
    owner = "idursun";
    repo = "jjui";
    rev = "v${version}";
    hash = "sha256-dtMkq94p9e6c336WWg+0noJMIezuca8mt5h+zLuYpCg=";
  };
  vendorHash = "sha256-84VMhT+Zbub9sw+lAKEZba1aXcRaTIbnYhJ7zJt118Y=";
}
