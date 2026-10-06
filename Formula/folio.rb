class Folio < Formula
  include Language::Python::Shebang

  desc "Find and download books and papers from the terminal or an AI agent"
  homepage "https://github.com/jonaprieto/folio"
  url "https://github.com/jonaprieto/folio/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "8f51bcb89a55487da745a86ff94b43e1812779d3f3682878916ec648d98a9b43"
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
