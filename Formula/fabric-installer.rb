class FabricInstaller < Formula
  desc "Installer for Fabric for the vanilla launcher"
  homepage "https://fabricmc.net/"
  url "https://maven.fabricmc.net/net/fabricmc/fabric-installer/0.8.0/fabric-installer-0.8.0.jar"
  sha256 "9ff97d46e058fb036a9aa1e93882f48fe503d4a16438cc75370aa31813903f0d"
  license "Apache-2.0"

  # The first-party download page (https://fabricmc.net/use/) uses JavaScript
  # to create download links, so we check the related JSON data for versions.
  livecheck do
    url "https://meta.fabricmc.net/v2/versions/installer"
    regex(/["']url["']:\s*["'][^"']*?fabric-installer[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2b15ffabedf80145dec3bca262c28d4f9743c1cdb085bcc2e5802fcebb95e271" # linuxbrew-core
  end

  depends_on "openjdk"

  def install
    libexec.install "fabric-installer-#{version}.jar"
    bin.write_jar_script libexec/"fabric-installer-#{version}.jar", "fabric-installer"
  end

  test do
    system "#{bin}/fabric-installer", "server"
    assert_predicate testpath/"fabric-server-launch.jar", :exist?
  end
end
