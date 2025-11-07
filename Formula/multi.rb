class Multi < Formula
  desc "Move fast without breaking things."
  homepage "https://multitool.run/"
  version "0.3.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.3.5/multitool-aarch64-apple-darwin.tar.xz"
      sha256 "0d82e6b07b5526ea67471f493ee3fceb0543321d96bb03c8d50e21cc540f27d1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.3.5/multitool-x86_64-apple-darwin.tar.xz"
      sha256 "abcb166a30f9b989fdd771c23e0d6d20792c99e718e607969ab06bd8c4440295"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.3.5/multitool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "67a269ed1e73e87687c3714d9deaf735883087b8bda4d8fb65bcda05373d0ec7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.3.5/multitool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ed41aa5fa5470eb39ee5c5072554720efbbfe831451fa39adaadd592038848a3"
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
