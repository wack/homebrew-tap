class Multi < Formula
  desc "Move fast without breaking things."
  homepage "https://multitool.run/"
  version "0.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.0.1/multitool-aarch64-apple-darwin.tar.xz"
      sha256 "6661e6391e8c1fb4a884667248e0510da4c466286ff625a00b5a8b66e886b9a0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.0.1/multitool-x86_64-apple-darwin.tar.xz"
      sha256 "57c34bde62fd5f2ce688a3bf3f7cc57a32fdf1b55a6d8acf7fd3decca84044cb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.0.1/multitool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0efae4c94bda8d25cb693daa5186d2ff43ab202df4f1250780641739d226391e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.0.1/multitool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c717b281902ccb85942bddbfaff620f591e38a1843cc74d2c3355324f69f1659"
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
