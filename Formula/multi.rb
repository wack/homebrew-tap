class Multi < Formula
  desc "Move fast without breaking things."
  homepage "https://multitool.run/"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.5.0/multitool-aarch64-apple-darwin.tar.xz"
      sha256 "1c247468af8d19a8ffde0bda6280ca0f1e655b98e97cebf00dbf504ea8e4e9b4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.5.0/multitool-x86_64-apple-darwin.tar.xz"
      sha256 "e1821498b209ed10fe2c5e79b1e48100e957ba22086c6b1d0e544bef4cbd9ca1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.5.0/multitool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "34aa849d9cc4bba2fbb401f2d90eff5f180af980878d5aace7e628da96718351"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.5.0/multitool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "630ad303856160216bdd7cdb3f264dbb1c8db33498e152ddb322e657a01327a0"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
