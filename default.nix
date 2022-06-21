with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "cloudi-${version}";
  version = "2.0.4";

  src = fetchzip {
    url = "https://osdn.net/dl/cloudi/${name}.tar.gz";
    sha256 = "sha256-PMIpPKF26Vx3Q/HfbyaM57MyQLBBeKo3JURyBv6YSLw=";
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
