class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v1.1.6.tar.gz"
  sha256 "e453570f9db84a13ae83bc813c94f6abe3010f39bd9814af5dbba28db19c44c7"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "82bc886b7f70e545cba813893e1f39d795987ed4fd7097e67e86a5ec83e55ce7"
    sha256 cellar: :any_skip_relocation, big_sur:       "a39d81f8013b6a06c982714b32f64c4d90434b2249f1cd8ac7a91a67065b8500"
    sha256 cellar: :any_skip_relocation, catalina:      "b523a26f378ff0be0e23a1cddf20fcc0668850622fc084b52ed66d7270f262c1"
    sha256 cellar: :any_skip_relocation, mojave:        "e3a4f3b2958f608a0d034f6bb1d9f116a41744e28a5f4911b4094a6a19661f3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fd75a202f4155cae170d8dfaefaeaba688f00ad54eba8b7d348d711582ee629" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "ui"
  end

  service do
    run [opt_bin/"nomad", "agent", "-dev"]
    keep_alive true
    working_dir var
    log_path var/"log/nomad.log"
    error_log_path var/"log/nomad.log"
  end

  test do
    pid = fork do
      exec "#{bin}/nomad", "agent", "-dev"
    end
    sleep 10
    ENV.append "NOMAD_ADDR", "http://127.0.0.1:4646"
    system "#{bin}/nomad", "node-status"
  ensure
    Process.kill("TERM", pid)
  end
end
