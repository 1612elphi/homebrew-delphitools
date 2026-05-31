class DelphitoolsCli < Formula
  desc "delphitools CLI — indie toolkit for designers (colour, image, PDF, type, calc)"
  homepage "https://delphi.tools"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/1612elphi/delphitools-cli/releases/download/v0.2.0/delphitools-cli-aarch64-apple-darwin.tar.xz"
      sha256 "0b464ebf3e6788c6218b213b6198da90bafcaf1de9968b7195df9acf1faa1673"
    end
    if Hardware::CPU.intel?
      url "https://github.com/1612elphi/delphitools-cli/releases/download/v0.2.0/delphitools-cli-x86_64-apple-darwin.tar.xz"
      sha256 "251497bd2ae14786fb0a9c8a835e4a25858b76c8f5d72d11ebbb9845db1896ba"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/1612elphi/delphitools-cli/releases/download/v0.2.0/delphitools-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ca4168beba276b871cc97d361050f2266cca7d45ce73c8dd16c7badc0e0910e0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/1612elphi/delphitools-cli/releases/download/v0.2.0/delphitools-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "261b9daf5951c8aba022b746e495c8b9d39b7d6e18161e829609afdf50ca10b0"
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
