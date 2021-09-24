class Linklint < Formula
  desc "Link checker and web site maintenance tool"
  homepage "http://linklint.org"
  url "http://linklint.org/download/linklint-2.3.5.tar.gz"
  sha256 "ecaee456a3c2d6a3bd18a580d6b09b6b7b825df3e59f900270fe3f84ec3ac9c7"

  livecheck do
    url "http://linklint.org/download.html"
    regex(/href=.*?linklint[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b3e69e9293cd50a460e6ac8ca468ffbb08f9e91bee792b6dd4297c6c77df0127" # linuxbrew-core
  end

  def install
    mv "READ_ME.txt", "README"

    doc.install "README"
    bin.install "linklint-#{version}" => "linklint"
  end

  test do
    (testpath/"index.html").write('<a href="/">Home</a>')
    system "#{bin}/linklint", "/"
  end
end
