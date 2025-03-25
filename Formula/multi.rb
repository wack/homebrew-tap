class Multi < Formula
  desc "Move fast without breaking things."
  homepage "https://multitool.run/"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.1.1/multitool-aarch64-apple-darwin.tar.xz"
      sha256 "fefa0ef4fa5dde173cd51a6c24358e69427b1c8f4543f1ebd8bcb067cc5df055"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.1.1/multitool-x86_64-apple-darwin.tar.xz"
      sha256 "a55601241b6b845179997b1ef7a820045be9460cc63157c650f4b1265844aeb7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/wack/multitool/releases/download/v0.1.1/multitool-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "55c02d4318da4c1b68aa90b48703ca862c7b9ef53c4ec112689530eb2d4b5723"
    end
    if Hardware::CPU.intel?
      url "https://github.com/wack/multitool/releases/download/v0.1.1/multitool-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8894cb2b1ca5af56d3ace7334260c41219a015a6c04f757e16963737237e3563"
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
