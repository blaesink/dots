let
  me = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDqd3hnGqK9vb/GPW4kOLr1glLw83wIO5M0nGQlvSqVU";
in {
  "cloudflare_tunnel_token.age".publicKeys = [ me ];
  "cloudflare_tunnel_id.age".publicKeys = [ me ];
  "secrets/cloudflare_token.age".publicKeys = [ me ];
}
