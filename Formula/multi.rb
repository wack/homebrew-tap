class Multi < Formula
  desc "Move fast without breaking things."
  homepage "https://multitool.run/"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.1.0/multitool-aarch64-apple-darwin.tar.xz"
      sha256 "f4356e74b43ffea68db3fe8e934c40678669b1d2034cfe8b906f14822026facf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.1.0/multitool-x86_64-apple-darwin.tar.xz"
      sha256 "a72c01e7b4bb80845348b419674e76ef38ec41c289deaf29d7caa632e9ddae27"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.1.0/multitool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e5576a05e07f5838370c8c9b03cae057df367465caa685f5f74402fba5038f16"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.1.0/multitool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "87e5dc0294edb03a533fd074cae9c8e66682c0ae0a621b37c5f42ff6ee938ea0"
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
