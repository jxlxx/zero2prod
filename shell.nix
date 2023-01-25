let
  rustOverlay = import (builtins.fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz");
  pkgs = import <nixpkgs> { overlays = [ rustOverlay ]; };
  rustVersion = pkgs.rust-bin.stable.latest.default;
  # bakery-start = pkgs.writeShellScriptBin "bakery-start" ''
  #   RUST_LOG=debug cargo run --bin the-bakery  
  #   '';
  rustNightlyNixRepo = pkgs.fetchFromGitHub {
       owner = "solson";
       repo = "rust-nightly-nix";
       rev = "9e09d579431940367c1f6de9463944eef66de1d4";
       sha256 = "03zkjnzd13142yla52aqmgbbnmws7q8kn1l5nqaly22j31f125xy";
  };
  nightlyRustPackages = pkgs.callPackage rustNightlyNixRepo { };
in
pkgs.mkShell {
  buildInputs = [
        (rustVersion.override {extensions = [ "rust-src" ]; })
        pkgs.postgresql
        pkgs.docker
        pkgs.dbeaver
        pkgs.cargo-watch
        pkgs.cargo-expand
        pkgs.clippy
        pkgs.rustfmt
        pkgs.rustup
        pkgs.openssl
        pkgs.pkg-config
        pkgs.sqlx-cli
        # bakery-start
    ];
  shellHook = ''
      chmod +x scripts/*.sh
      export PGHOST=$PWD/postgres
      export PGDATA=$PWD/postgres_data
      export PGDATABASE=newsletter
      export PGLOG=$PGHOST/postgres.log\
      export DB_USER=worm
      export DB_PORT=5432
      export DATABASE_URL=postgres://worm@localhost:5432/newsletter
  '';
}
