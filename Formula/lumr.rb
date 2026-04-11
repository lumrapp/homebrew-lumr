class Lumr < Formula
  desc "System intelligence for software teams."
  homepage "https://lumr.app"
  version "0.1.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lumrapp/lumr-cli/releases/download/v0.1.11/lumr-cli-aarch64-apple-darwin.tar.xz"
      sha256 "43189d0abbb7ef35e928bcc201d2080a10db839018b877b9e70ed130480b7ef2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lumrapp/lumr-cli/releases/download/v0.1.11/lumr-cli-x86_64-apple-darwin.tar.xz"
      sha256 "0d9ac2c612fa0edd8ed8b7477646c5e5603112eaacb9b16b4b98efc2fb102a96"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/lumrapp/lumr-cli/releases/download/v0.1.11/lumr-cli-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "ae3d806a25864acdfe0a992531617c8bcea33a2f82db1cfd754595e575e7581d"
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
