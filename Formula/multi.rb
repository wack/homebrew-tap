class Multi < Formula
  desc "Move fast without breaking things."
  homepage "https://multitool.run/"
  version "0.3.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.3.3/multitool-aarch64-apple-darwin.tar.xz"
      sha256 "0f5fa1b0616f66fc04ba27306ecd03076f8dc72b4f025cf9695b112f9f80494a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.3.3/multitool-x86_64-apple-darwin.tar.xz"
      sha256 "73292316787f44f550f24ca05ea561f98d22d6c4892c90074978d812aa7bfaad"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.3.3/multitool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ca6f80342d55bb52c87e65edd2fdb094d47798c39e7ba6a629e09271f94477b8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.3.3/multitool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5d563ac20c05269002d81486ee65ce375291a638aeae3c50addd8b1d4e8eb637"
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
