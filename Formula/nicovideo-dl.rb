class NicovideoDl < Formula
  include Language::Python::Shebang

  desc "Command-line program to download videos from www.nicovideo.jp"
  homepage "https://osdn.net/projects/nicovideo-dl/"
  # Canonical: https://osdn.net/dl/nicovideo-dl/nicovideo-dl-0.0.20190126.tar.gz
  url "https://dotsrc.dl.osdn.net/osdn/nicovideo-dl/70568/nicovideo-dl-0.0.20190126.tar.gz"
  sha256 "886980d154953bc5ff5d44758f352ce34d814566a83ceb0b412b8d2d51f52197"
  revision 2

  livecheck do
    url "https://osdn.net/projects/nicovideo-dl/releases/"
    regex(%r{value=.*?/rel/nicovideo-dl/v?(\d+(?:\.\d+)+)["']}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "df91f21b1000cfe99ea4b2e28663b4e0555fdb191844879e98eaa317270ced88" # linuxbrew-core
  end

  depends_on "python@3.9"

  def install
    rewrite_shebang detected_python_shebang, "nicovideo-dl"
    bin.install "nicovideo-dl"
  end

  test do
    system "#{bin}/nicovideo-dl", "-v"
  end
end
