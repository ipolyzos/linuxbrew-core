class PipCompletion < Formula
  desc "Bash completion for Pip"
  homepage "https://github.com/ekalinin/pip-bash-completion"
  url "https://github.com/ekalinin/pip-bash-completion.git",
      revision: "321d8bd2c56bb1565ac20210367bd272a111a1aa"
  version "20200731"
  license "MIT"
  head "https://github.com/ekalinin/pip-bash-completion.git", branch: "master"

  # There currently aren't any versions of pip-completion and the formula
  # simply uses a revision from the upstream GitHub repo. The YYYYMMDD version
  # in the formula isn't from upstream and was created on our end to indicate
  # the date of the revision that's being used.
  livecheck do
    skip "No version information available"
  end

  def install
    bash_completion.install "pip"
  end

  test do
    assert_match "-F _pip",
      shell_output("source #{bash_completion}/pip && complete -p pip")
  end
end
