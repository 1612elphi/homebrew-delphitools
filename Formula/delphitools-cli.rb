class DelphitoolsCli < Formula
  desc "delphitools CLI — indie toolkit for designers (colour, image, PDF, type, calc)"
  homepage "https://delphi.tools"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/1612elphi/delphitools-cli/releases/download/v0.1.0/delphitools-cli-aarch64-apple-darwin.tar.xz"
      sha256 "e7fbff80112a6549e7d98fe8b5d3b52b20ddf402416f006ba9facc6009d0cfd1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/1612elphi/delphitools-cli/releases/download/v0.1.0/delphitools-cli-x86_64-apple-darwin.tar.xz"
      sha256 "c54312aba2f9dd1d5e2ca5865376f9c6f52f3b6c761165c6e67f6e4b9240898f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/1612elphi/delphitools-cli/releases/download/v0.1.0/delphitools-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b07f4eb1820eb41e6a3f7d3ebb547d61399aca446a52562132ddfc8c78da2ab3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/1612elphi/delphitools-cli/releases/download/v0.1.0/delphitools-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "96a11360914c552282053aa517703b5a6025ce8658b55fd8ed82dcf939c1be08"
    end
  end
  license "0BSD"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "delphi", "delphitools", "dt" if OS.mac? && Hardware::CPU.arm?
    bin.install "delphi", "delphitools", "dt" if OS.mac? && Hardware::CPU.intel?
    bin.install "delphi", "delphitools", "dt" if OS.linux? && Hardware::CPU.arm?
    bin.install "delphi", "delphitools", "dt" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
