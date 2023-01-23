let
  rustOverlay = import (builtins.fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz");
  pkgs = import <nixpkgs> { overlays = [ rustOverlay ]; };
  rustVersion = pkgs.rust-bin.stable.latest.default;
  # bakery-start = pkgs.writeShellScriptBin "bakery-start" ''
  #   RUST_LOG=debug cargo run --bin the-bakery  
  #   '';
in
pkgs.mkShell {
  buildInputs = [
        (rustVersion.override {extensions = [ "rust-src" ]; })
        pkgs.postgresql
        pkgs.docker
        pkgs.dbeaver
       # bakery-start
    ];
  shellHook = ''
      export PGHOST=$PWD/postgres
      export PGDATA=$PWD/postgres_data
      export PGDATABASE=bakery_db_dev
      export PGLOG=$PGHOST/postgres.log
  '';
}
