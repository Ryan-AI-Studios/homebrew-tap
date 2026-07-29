# Homebrew formula template for Ledgerful (CLI formula, not cask).
# Maintained in-engine; release CI bumps version + sha256 from published
# checksum files via scripts/bump-manifests.{ps1,sh}.
#
# Tap: Ryan-AI-Studios/homebrew-tap
# Install (after tap is seeded): brew install Ryan-AI-Studios/tap/ledgerful
#
# macOS interim: release artifacts are not Apple-codesigned/notarized.
# Homebrew formula installs usually avoid browser quarantine, but if
# Gatekeeper blocks first run on a downloaded binary:
#   xattr -d com.apple.quarantine "$(which ledgerful)"
# Proper fix is codesign+notarize in the release pipeline (upstream of 0051).

class Ledgerful < Formula
  desc "Local-first change intelligence CLI for impact analysis and verification"
  homepage "https://github.com/Ryan-AI-Studios/Ledgerful"
  version "0.2.3"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/Ryan-AI-Studios/Ledgerful/releases/download/v0.2.3/ledgerful-aarch64-apple-darwin.tar.gz"
      sha256 "9d809566cad5096a63239947778dacc9dfcda2961f79b00c9af13c0c261870ba"
    end
    on_intel do
      url "https://github.com/Ryan-AI-Studios/Ledgerful/releases/download/v0.2.3/ledgerful-x86_64-apple-darwin.tar.gz"
      sha256 "9eedaad20adad050cc9c9e8b37f4215265a212af404ef1adb9033225388f77d8"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/Ryan-AI-Studios/Ledgerful/releases/download/v0.2.3/ledgerful-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4f19997e6a8db237201ac0c77d7b6c2a6ec38439cddf1dba309e339ff1a7f48d"
    end
  end

  def install
    # Release archives nest the binary: ledgerful-{target}/ledgerful
    binary = Dir["ledgerful-*/ledgerful"].first
    odie "ledgerful binary not found in archive" if binary.nil?

    bin.install binary => "ledgerful"
  end

  def caveats
    <<~EOS
      macOS release binaries are not currently Apple-notarized.
      If Gatekeeper reports "developer cannot be verified" on first run:
        xattr -d com.apple.quarantine "$(which ledgerful)"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ledgerful --version")
  end
end
