class Lumr < Formula
  desc "System intelligence for software teams."
  homepage "https://lumr.app"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lumrapp/lumr-cli/releases/download/v0.2.1/lumr-cli-aarch64-apple-darwin.tar.xz"
      sha256 "39cce4965b5e30642df773bafef3445330880c116d2bdba2e34026761c0ca98d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lumrapp/lumr-cli/releases/download/v0.2.1/lumr-cli-x86_64-apple-darwin.tar.xz"
      sha256 "2bf3d324aff8344a17033f50e72539fcdf71059f333b0b2fcec01bd63daa1cbc"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/lumrapp/lumr-cli/releases/download/v0.2.1/lumr-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "dc097d793ab7912774b5c0f15766825e4891fc6c4ef6d61e58cc1ca859166715"
  end
  license "UNLICENSED"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "lumr" if OS.mac? && Hardware::CPU.arm?
    bin.install "lumr" if OS.mac? && Hardware::CPU.intel?
    bin.install "lumr" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
