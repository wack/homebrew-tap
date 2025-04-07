class Multi < Formula
  desc "Move fast without breaking things."
  homepage "https://multitool.run/"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.2.2/multitool-aarch64-apple-darwin.tar.xz"
      sha256 "e703111f7518d619ec4a844ee4418b2c68c31d6fbd6c42b2083cc510ed145b5e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.2.2/multitool-x86_64-apple-darwin.tar.xz"
      sha256 "120125c58678fd35e1ed2fc889528edea008ab60ace65147d6275ac39e81604a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.2.2/multitool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "41816e477e16ce35620015aebf5a142716704ad7a0a959a4853b8ab6e91f08ab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.2.2/multitool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "33d52042fee3072664bc1502610f23c74bb03f5965feab45d08603c199b7f109"
    end
  end

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
    bin.install "multi" if OS.mac? && Hardware::CPU.arm?
    bin.install "multi" if OS.mac? && Hardware::CPU.intel?
    bin.install "multi" if OS.linux? && Hardware::CPU.arm?
    bin.install "multi" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
