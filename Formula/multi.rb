class Multi < Formula
  desc "Move fast without breaking things."
  homepage "https://multitool.run/"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.3.2/multitool-aarch64-apple-darwin.tar.xz"
      sha256 "4840fae3e3beb2ffe22ae1a5b4c1db8e92e138b2f68fb6199347ca72b7bdada2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.3.2/multitool-x86_64-apple-darwin.tar.xz"
      sha256 "0261233e33d3be156dc6c957858ed420cc890bfa9bf6e8409907872b949b3beb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.3.2/multitool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "31668a6df62d6d2343757a4ffa61cb46000c2ec868ab4ee9551d48e1b8af9c83"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.3.2/multitool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "186fa5f68abda15c2a52ff09cf34d217f02fab1843148c7881ac6070a3433c75"
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
