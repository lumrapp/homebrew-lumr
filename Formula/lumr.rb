class Lumr < Formula
  desc "System intelligence for software teams."
  homepage "https://lumr.app"
  version "0.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lumrapp/lumr-cli/releases/download/v0.2.3/lumr-cli-aarch64-apple-darwin.tar.xz"
      sha256 "77d1bd7c4af6ea4a1de90fbc439d7955ab8cbb843bf43045fdcf1fdf3e54a623"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lumrapp/lumr-cli/releases/download/v0.2.3/lumr-cli-x86_64-apple-darwin.tar.xz"
      sha256 "af116706b43f289176d06a3f01d1dc44307871237a0d4cb975d7977f2fadbf45"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/lumrapp/lumr-cli/releases/download/v0.2.3/lumr-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "d9f6193635437084acf90ab2ef799f4d6eb86be43b86cdc363c16e723f00bc08"
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
