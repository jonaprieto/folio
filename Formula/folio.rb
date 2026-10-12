class Folio < Formula
  include Language::Python::Shebang

  desc "Find and download books and papers from the terminal or an AI agent"
  homepage "https://github.com/jonaprieto/folio"
  url "https://github.com/jonaprieto/folio/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "b9deb5ee379b114a44d184775dea2c8656e2bd8ddf6461f8465ff6e6d888e68c"
  license "MIT"
  head "https://github.com/jonaprieto/folio.git", branch: "main"

  depends_on "python@3.13"

  def install
    rewrite_shebang detected_python_shebang, "folio"
    bin.install "folio"
  end

  test do
    assert_equal "ok", shell_output("#{bin}/folio selftest").strip
  end
end
