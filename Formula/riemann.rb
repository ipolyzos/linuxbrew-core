class Riemann < Formula
  desc "Event stream processor"
  homepage "https://riemann.io/"
  url "https://github.com/riemann/riemann/releases/download/0.3.6/riemann-0.3.6.tar.bz2"
  sha256 "fa2e22b712ed53144bf3319a418a3cd502ed00fa8e6bcb50443039a2664ee643"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a7fc93a614414c28e1f2d726b8a1c786806596095bb42f72cc1d64606033c21c" # linuxbrew-core
  end

  depends_on "openjdk"

  def install
    inreplace "bin/riemann", "$top/etc", etc
    etc.install "etc/riemann.config" => "riemann.config.guide"

    # Install jars in libexec to avoid conflicts
    libexec.install Dir["*"]

    (bin/"riemann").write_env_script libexec/"bin/riemann", Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      You may also wish to install these Ruby gems:
        riemann-client
        riemann-tools
        riemann-dash
    EOS
  end

  service do
    run [opt_bin/"riemann", etc/"riemann.config"]
    keep_alive true
    log_path var/"log/riemann.log"
    error_log_path var/"log/riemann.log"
  end

  test do
    system "#{bin}/riemann", "-help", "0"
  end
end
