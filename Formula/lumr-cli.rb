class LumrCli < Formula
  desc "System intelligence for software teams."
  homepage "https://lumr.app"
  version "0.1.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lumrapp/lumr-cli/releases/download/v0.1.9/lumr-cli-aarch64-apple-darwin.tar.xz"
      sha256 "067117b66cbdf69ba5cc50c2919340fac0f08655d89c69b7d22ba0dcfff4cf89"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lumrapp/lumr-cli/releases/download/v0.1.9/lumr-cli-x86_64-apple-darwin.tar.xz"
      sha256 "1782359841f8ca91eb6e84c357b1aa37040150c677550bc78e7dae300d476121"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/lumrapp/lumr-cli/releases/download/v0.1.9/lumr-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "a59df55f8754bd92500cd8c1947394d2020f2aa4a0a2fa64fb98dd39f474fbde"
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
