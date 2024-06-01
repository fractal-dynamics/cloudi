{
  pkgs,
  ...
}:
with pkgs;
  stdenv.mkDerivation rec {
    name = "cloudi-${version}";
    version = "2.0.7";

    src = fetchzip {
      url = "https://downloads.sourceforge.net/project/cloudi/${version}/${name}.tar.gz";
      sha256 = "sha256-/W6VGxGF379nS+Qsh8vvTC3gBIm9Qh3n6tsczKIAos4=";
    };

    preAutoreconf = "cd src";

    postFixup = ''
      substituteInPlace $out/etc/cloudi/cloudi.conf --replace $out/lib/${name}/logs /tmp
      substituteInPlace $out/lib/${name}/bin/cloudi --replace '$ROOTDIR/logs' /tmp
    '';

    nativeBuildInputs = [autoreconfHook];

    buildInputs = [
      boost
      erlang
      gmp
      ncurses
      python3
      systemd
    ];

    configureFlags = [
      "--enable-java-support=no"
      "--enable-javascript-support=no"
      "--enable-perl-support=no"
      "--enable-php-support=no"
      "--enable-ruby-support=no"
      "--enable-python-support=no"
      "--enable-python-c-support=no"
      "--localstatedir=/tmp"
      "--with-boost-libdir=${boost}/lib" # autoconf expects a different location
      "--with-integration-tests=yes"
    ];
  }
