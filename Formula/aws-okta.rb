class AwsOkta < Formula
  desc "Authenticate with AWS using your Okta credentials"
  homepage "https://github.com/segmentio/aws-okta"
  url "https://github.com/segmentio/aws-okta/archive/v1.0.11.tar.gz"
  sha256 "444a84cd9c81097a7c462f806605193c5676879133255cfa0f610b7d14756b65"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6de4fd8fa42cddba3a914ed99123469230646bc2ac2598ff40fd0d0c9bf51efe"
    sha256 cellar: :any_skip_relocation, big_sur:       "178f359eaabc71c8a677f89e1acb35fe73ae35ba4010a06876bdb630b66878b2"
    sha256 cellar: :any_skip_relocation, catalina:      "2edc4ebb817ff4f0a3188a0c0eea6416ce2a83a6d9b5cc5b3969034ee65e27ca"
    sha256 cellar: :any_skip_relocation, mojave:        "910418c2dd89b78a7d665cdd8082d9941de433c6c8db800ce0515dfb6c1eb25b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58c9a49a4f7a27c1ef8b4a60999ce66bbff62817571db92ac14bb88a6725dda9" # linuxbrew-core
  end

  # See https://github.com/segmentio/aws-okta/issues/278
  deprecate! date: "2020-01-20", because: :deprecated_upstream

  depends_on "go" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libusb"
  end

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.Version=#{version}"
  end

  test do
    require "pty"

    PTY.spawn("#{bin}/aws-okta --backend file add") do |input, output, _pid|
      output.puts "organization\n"
      input.gets
      output.puts "us\n"
      input.gets
      output.puts "fakedomain.okta.com\n"
      input.gets
      output.puts "username\n"
      input.gets
      output.puts "password\n"
      input.gets
      input.gets
      input.gets
      input.gets
      input.gets
      input.gets
      input.gets
      assert_match "Failed to validate credentials", input.gets.chomp
      input.close
    end
  end
end
