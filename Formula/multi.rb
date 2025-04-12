class Multi < Formula
  desc "Move fast without breaking things."
  homepage "https://multitool.run/"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.2.3/multitool-aarch64-apple-darwin.tar.xz"
      sha256 "b7b56a50bbb1efd8500f6dd476f9574f5fb26a21c97b3cc70311098a7d486361"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.2.3/multitool-x86_64-apple-darwin.tar.xz"
      sha256 "b49e88df3759fc5d9d2a8abd94178cbf40f3d4d9f3719ce93d6154f7dfa43095"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.2.3/multitool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "497203cf13ddd411e25b164abaada5ce3b65831c67cb6de0e534c8ce0eb0135d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.2.3/multitool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "69ef235638715cb2c400bca5290b86dca7b88aa14a6badb73642b2acfb7a4a7a"
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
