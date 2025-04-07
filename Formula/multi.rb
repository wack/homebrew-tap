class Multi < Formula
  desc "Move fast without breaking things."
  homepage "https://multitool.run/"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.2.1/multitool-aarch64-apple-darwin.tar.xz"
      sha256 "1c5b751e5519b71e76b8bb9b2313c17660630558813660b8ded65d67875b2e7a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.2.1/multitool-x86_64-apple-darwin.tar.xz"
      sha256 "ebdff70811ea4f0e0d4dc6f39e7806237c07acd244d5f0820d816bcc736f8aac"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.2.1/multitool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "52eed94add39f41adb87af72fe64bd0d5c0255671f8a6a8510e524cd7357f7d7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.2.1/multitool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0e7b13bcc24a1808d101f7b7100b2f2540f94dd5d33c50589766677c498da7e3"
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
