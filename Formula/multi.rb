class Multi < Formula
  desc "Move fast without breaking things."
  homepage "https://multitool.run/"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.6.0/multitool-aarch64-apple-darwin.tar.xz"
      sha256 "4d78b0652c2d7246cb45adcff47dcfc1d55c5bcd5ac49ea9eaa2069590bf5c5c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.6.0/multitool-x86_64-apple-darwin.tar.xz"
      sha256 "6587497b2bca497d065aa4df91b45e034023cc785a8618be932b87bf9daa1d85"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.6.0/multitool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "62defece2f82842207d98f0aa3c9668d474357b5ee264e4f0dd82b075ad011c3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.6.0/multitool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9a0e4f5956552f0c754d23b6f5bf7b52a941b0dff01240815d0af9e3db9d4f2c"
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
