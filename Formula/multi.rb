class Multi < Formula
  desc "Move fast without breaking things."
  homepage "https://multitool.run/"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.4.0/multitool-aarch64-apple-darwin.tar.xz"
      sha256 "7d5e286ce3fcdb1acf7517daf0d0a08413b57308ff8690e49427e8d06b63bae3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.4.0/multitool-x86_64-apple-darwin.tar.xz"
      sha256 "e58fb4bfc017d2942120e686a7dcbe42c2ecc3d4b72ed9ff53b7755563fe9efc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.4.0/multitool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "48d66aeae5dce3588f03724a28f07cae53fdb31f2faae604794981c7935df3f6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.4.0/multitool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "26d6a5c5751ee160ff5e90cd35b8a286175b1bc064c91fad7baf8ff2d73796bf"
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
