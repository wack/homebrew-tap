class Multi < Formula
  desc "Move fast without breaking things."
  homepage "https://multitool.run/"
  version "0.3.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.3.4/multitool-aarch64-apple-darwin.tar.xz"
      sha256 "64d6d33b4b9d542713442d4bdd5a776698b7533b6b203865aa8bca3dc6d413a7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.3.4/multitool-x86_64-apple-darwin.tar.xz"
      sha256 "e7079a59efdabbd64dd6641f229aed70e142a915a5358add0f7cf497ac49b43a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.3.4/multitool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "987398ae12e1588fb4f43b0221c393cf149c361d919d9c6ac77a8194f6935027"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.3.4/multitool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d70ee1383844704d1138fb62e558cc9995b80070530550590acd9e1079e15216"
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
