class Krew < Formula
  desc "Package manager for kubectl plugins"
  homepage "https://sigs.k8s.io/krew/"
  url "https://github.com/kubernetes-sigs/krew.git",
      tag:      "v0.4.2",
      revision: "6fcdb794c532d3f2849bb4a8a942a19c09ef3002"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/krew.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9bd45bf4ce538f251c393ba6279d18c7599866abb46e556fb9fa26e2e7473249"
    sha256 cellar: :any_skip_relocation, big_sur:       "17c8fd8f71c8a92ede7c9f9d56382b1c6ffc962d4a7f6e9719e7e9a9d9f1755a"
    sha256 cellar: :any_skip_relocation, catalina:      "3405b2bbbedd29dad0cec63a9a74d959ff9f8ef1ee1ce8c9d540156a225492ed"
    sha256 cellar: :any_skip_relocation, mojave:        "500cfe13d69c132e42b689b2c575317dbdb1d4d1364d0edaeb53a3db07ebf055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d7b37896695e5f9c59b76c0f47714554205a28021775a7a1b80b80875af3b23" # linuxbrew-core
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "0"
    # build in local dir to avoid this error:
    # go build: cannot write multiple packages to non-directory /usr/local/Cellar/krew/0.3.2/bin/krew
    mkdir "build"

    ldflags = %W[
      -w
      -X sigs.k8s.io/krew/internal/version.gitCommit=#{Utils.git_short_head(length: 8)}
      -X sigs.k8s.io/krew/internal/version.gitTag=v#{version}
    ]

    system "go", "build", "-o", "build", "-tags", "netgo",
      "-ldflags", ldflags.join(" "), "./cmd/krew"
    # install as kubectl-krew for kubectl to find as plugin
    bin.install "build/krew" => "kubectl-krew"
  end

  test do
    ENV["KREW_ROOT"] = testpath
    ENV["PATH"] = "#{ENV["PATH"]}:#{testpath}/bin"
    system "#{bin}/kubectl-krew", "version"
    system "#{bin}/kubectl-krew", "update"
    system "#{bin}/kubectl-krew", "install", "ctx"
    assert_match "v#{version}", shell_output("#{bin}/kubectl-krew version")
    assert_predicate testpath/"bin/kubectl-ctx", :exist?
  end
end
