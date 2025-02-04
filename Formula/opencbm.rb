class Opencbm < Formula
  desc "Provides access to various floppy drive formats"
  homepage "https://spiro.trikaliotis.net/opencbm"
  url "https://github.com/OpenCBM/OpenCBM/archive/v0.4.99.103.tar.gz"
  sha256 "026b0aa874b85763027641cfd206af92172d1120b9c667f35050bcfe53ba0b73"
  license "GPL-2.0-only"
  head "https://git.code.sf.net/p/opencbm/code.git", branch: "master"

  livecheck do
    url :homepage
    regex(/<h1[^>]*?>VERSION v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256                               arm64_big_sur: "14d82a0d9ca1fb0a90a012526fe7ca814291baabded7c794fdfedb050fe8dd1d"
    sha256                               big_sur:       "aaf54902db867f5d5116e5a5701320c52fd8bdaf587fe3824ccf57051671a5e6"
    sha256                               catalina:      "6d85698fdf68fcd53e794ff94495bb95de4f9f1bed54d8c2b31ede5e0e9dfb56"
    sha256                               mojave:        "78c7219df463cc71eb494724a5dee0444a218dadeb2a14308c529d8e0ea29126"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2f2f29fbe51c2451e52b747391ec9e255a607ebc2cd9382b7f6f124b19d3950" # linuxbrew-core
  end

  # cc65 is only used to build binary blobs included with the programs; it's
  # not necessary in its own right.
  depends_on "cc65" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  def install
    # This one definitely breaks with parallel build.
    ENV.deparallelize

    args = %W[
      -fLINUX/Makefile
      LIBUSB_CONFIG=#{Formula["libusb-compat"].bin}/libusb-config
      PREFIX=#{prefix}
      MANDIR=#{man1}
    ]

    system "make", *args
    system "make", "install-all", *args
  end

  test do
    system "#{bin}/cbmctrl", "--help"
  end
end
