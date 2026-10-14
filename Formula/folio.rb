class Folio < Formula
  include Language::Python::Shebang

  desc "Find and download books and papers from the terminal or an AI agent"
  homepage "https://github.com/jonaprieto/folio"
  url "https://github.com/jonaprieto/folio/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "23922512df243a7188cbd6a564d56e3af1073adb4314154e5a1891d9ddb217da"
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
