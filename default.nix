with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "cloudi-${version}";
  version = "1.7.5";

  src = fetchzip {
    url = "https://osdn.net/dl/cloudi/${name}.tar.gz";
    sha256 = "0aj0rwzfyad99gnm27km705ba46nsdy1ww87qgk3cfpi0017wx86";
  };

  patches = [ ./no-mkdir-logs.diff ];

  preAutoreconf = "cd src";

  postFixup = ''
    substituteInPlace $out/etc/cloudi/cloudi.conf --replace $out/lib/${name}/logs /tmp
    substituteInPlace $out/lib/${name}/bin/cloudi --replace '$ROOTDIR/logs' /tmp
  '';

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ 
    boost
    erlang
    ncurses 
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
    "--localstatedir=/var"
    "--with-boost-libdir=${boost}/lib" # autoconf expects a different location
    "--with-integration-tests=no"
  ];
}
