class Keydb < Formula
  desc "Multithreaded fork of Redis"
  homepage "https://keydb.dev"
  url "https://github.com/JohnSully/KeyDB/archive/v6.2.0.tar.gz"
  sha256 "61a2996c8d56e564930119b115674032d8a1de2b50d67a9c555be6e7975ed567"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "6a23ffe855a1778880d8dda557da1b993899a83472cfeae29822504812ded307"
    sha256 cellar: :any_skip_relocation, catalina:     "f14d248e73516c85b53a72285301dac6a43d78fa39606787a127d7e21bda8a0f"
    sha256 cellar: :any_skip_relocation, mojave:       "22932ae18bbe44f1f580f292ef9aceb379c0774573e6df30be20655a35161392"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f2b30d981ea356ceddf5c28841c17aa7fdd156770dff17634b4f233839519b7d" # linuxbrew-core
  end

  uses_from_macos "curl"

  on_linux do
    depends_on "util-linux"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/keydb-server --test-memory 2")
    assert_match "Your memory passed this test", output
  end
end
