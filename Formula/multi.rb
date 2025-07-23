class Multi < Formula
  desc "Move fast without breaking things."
  homepage "https://multitool.run/"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.3.1/multitool-aarch64-apple-darwin.tar.xz"
      sha256 "4bb1fc95f328a66b01eabe62cc54415efb2e44e974d4cd7a1f5bd6e32bdd1f1b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.3.1/multitool-x86_64-apple-darwin.tar.xz"
      sha256 "771553710b4dd7c998ddea94f8aa19f779126c5963b9da55b7aa91693e19cfba"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.3.1/multitool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a8da0240c2f4a566eae22fdeb5d6c16bc307693c047f1c13ab2f012ef746ef1d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.3.1/multitool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e71236e5a303cefeb3f68bbb79a12e6dc367e6cd64a44450c59a86629cccf4c1"
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
