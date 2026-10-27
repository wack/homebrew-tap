class Slcr < Formula
  desc "Write requirements as a graph and check them with validators"
  homepage "https://slcr.dev"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wack/slcr/releases/download/v0.1.0/slcr-aarch64-apple-darwin.tar.xz"
      sha256 "288041b45a24033d1b1fc94190115eecf84fa6e53719432cab4098e4393a1486"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/slcr/releases/download/v0.1.0/slcr-x86_64-apple-darwin.tar.xz"
      sha256 "e8f5e66b43d78c40bc2fb3c1066410df00f7f8ff30209567fc1805bfd53b3371"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wack/slcr/releases/download/v0.1.0/slcr-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "accd2316eab7e7d1978c1c0d46695fc8639906a6a99e3fa9765401600617c759"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/slcr/releases/download/v0.1.0/slcr-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f1046d2559bd79b1595cbeb48fc46607b940c57b9c6ae76ad9c11122bdfaf994"
    end
  end
  license "MIT"

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "slcr"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "slcr"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "slcr"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "slcr"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
