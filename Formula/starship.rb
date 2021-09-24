class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.57.0.tar.gz"
  sha256 "fba20e4ea3c11cc06d50d7fb8422242f420085e109a46e37b4ed8cd51b514b81"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "575279c0be001bd4206b511fbf29f4891d9a85ea26ed4d7cf9fe3fdbd1f29fb8"
    sha256 cellar: :any_skip_relocation, big_sur:       "d185356ee85118002be8a24609baf78d3f161f9656ae79fe6cfafc57cfd48f55"
    sha256 cellar: :any_skip_relocation, catalina:      "d421eaa65546e6dec7117ceb9c15d812c64f2c9496a6f53963075e5a898c60ba"
    sha256 cellar: :any_skip_relocation, mojave:        "eb2181494769406a7dea374f6e4295acaf126eb193303ba836ad9c2bba0c0a39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65ff6c89c71f7039ff2bee30d172e774968ed029426f2bc98a63fbb5cc2026db" # linuxbrew-core
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "dbus"
  end

  def install
    system "cargo", "install", "--features", "notify-rust", *std_cargo_args

    bash_output = Utils.safe_popen_read("#{bin}/starship", "completions", "bash")
    (bash_completion/"starship").write bash_output

    zsh_output = Utils.safe_popen_read("#{bin}/starship", "completions", "zsh")
    (zsh_completion/"_starship").write zsh_output

    fish_output = Utils.safe_popen_read("#{bin}/starship", "completions", "fish")
    (fish_completion/"starship.fish").write fish_output
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
