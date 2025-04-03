class Multi < Formula
  desc "Move fast without breaking things."
  homepage "https://multitool.run/"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.2.0/multitool-aarch64-apple-darwin.tar.xz"
      sha256 "a1c9204ae362cb1922f7eabbb2077f2ba54eb341a6ce00642c7ebf4aa8c5700a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.2.0/multitool-x86_64-apple-darwin.tar.xz"
      sha256 "732fac6738abea57ebc6b77ac584c5d1b52dbdc0bcda979f63ee7c38310cdf25"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.2.0/multitool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "eff8dc6cdf8af2e8c2b87022139bba194f59ca75a2ab3342f316c6e4a5dd9e7e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.2.0/multitool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "88a6b28c7322cf67dc48b6106e42ebf2fa35175c661445cbc4f1a862ebc4c409"
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
