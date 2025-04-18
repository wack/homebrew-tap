class Multi < Formula
  desc "Move fast without breaking things."
  homepage "https://multitool.run/"
  version "0.2.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.2.5/multitool-aarch64-apple-darwin.tar.xz"
      sha256 "7e42070c95ba5db4e23fbe5257e0dba0f2822c7908f27df1f2a6fd0c16d24981"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.2.5/multitool-x86_64-apple-darwin.tar.xz"
      sha256 "5729be8f1dbea93b3a369b01f20040d725db78cf55cd0dd6eb14aab932341bbe"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.2.5/multitool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "babe391db3260683646ec7358c75377077ae1303cb04dc7cd11e7ea6677f2972"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.2.5/multitool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f5e96c88e2ff870760f3ac7dccb07ddbd8af4f834d21fb915871030e3f4d73da"
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
