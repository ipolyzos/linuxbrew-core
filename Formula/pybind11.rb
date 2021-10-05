class Pybind11 < Formula
  desc "Seamless operability between C++11 and Python"
  homepage "https://github.com/pybind/pybind11"
  url "https://github.com/pybind/pybind11/archive/v2.8.0.tar.gz"
  sha256 "9ca7770fc5453b10b00a4a2f99754d7a29af8952330be5f5602e7c2635fa3e79"
  license "BSD-3-Clause"

  depends_on "cmake" => :build
  depends_on "python@3.9"

  def install
    # Install /include and /share/cmake to the global location
    system "cmake", "-S", ".", "-B", "build",
           "-DPYBIND11_TEST=OFF",
           "-DPYBIND11_NOPYTHON=ON",
           *std_cmake_args
    system "cmake", "--install", "build"

    # Install Python package too
    system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec)

    version = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    site_packages = "lib/python#{version}/site-packages"
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-pybind11.pth").write pth_contents

    # Also pybind11-config
    bin.install Dir[libexec/"bin/*"]
  end

  test do
    (testpath/"example.cpp").write <<~EOS
      #include <pybind11/pybind11.h>

      int add(int i, int j) {
          return i + j;
      }
      namespace py = pybind11;
      PYBIND11_MODULE(example, m) {
          m.doc() = "pybind11 example plugin";
          m.def("add", &add, "A function which adds two numbers");
      }
    EOS

    (testpath/"example.py").write <<~EOS
      import example
      example.add(1,2)
    EOS

    version = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    site_packages = "lib/python#{version}/site-packages"

    python_flags = `#{Formula["python@3.9"].opt_bin}/python3-config --cflags --ldflags --embed`.split
    system ENV.cxx, "-shared", "-fPIC", "-O3", "-std=c++11", "example.cpp", "-o", "example.so", *python_flags
    system Formula["python@3.9"].opt_bin/"python3", "example.py"

    test_module = shell_output("#{Formula["python@3.9"].opt_bin/"python3"} -m pybind11 --includes")
    assert_match (libexec/site_packages).to_s, test_module

    test_script = shell_output("#{opt_bin/"pybind11-config"} --includes")
    assert_match test_module, test_script
  end
end
