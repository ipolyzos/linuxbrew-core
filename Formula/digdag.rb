class Digdag < Formula
  desc "Workload Automation System"
  homepage "https://www.digdag.io/"
  url "https://dl.digdag.io/digdag-0.10.3.jar"
  sha256 "200911b6a35a3d8b40e25f028753fb9652aeb19dbd05b8f950dc35ff69547c34"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/treasure-data/digdag.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "8a561558e9cb93fe1f12d10f9672b9a404e4961f4a5bc5aecadb8080db1868b9" # linuxbrew-core
  end

  depends_on arch: :x86_64 # openjdk@8 is not supported on ARM
  depends_on "openjdk@8"

  def install
    libexec.install "digdag-#{version}.jar"
    bin.write_jar_script libexec/"digdag-#{version}.jar", "digdag", java_version: "1.8"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/digdag --version")
  end
end
