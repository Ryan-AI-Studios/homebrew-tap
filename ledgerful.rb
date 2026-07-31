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
  version "0.2.4"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/Ryan-AI-Studios/Ledgerful/releases/download/v0.2.4/ledgerful-aarch64-apple-darwin.tar.gz"
      sha256 "0ec7f8fc21930b784d81e96cb7b51df0b539bdfc825179c512404b3106d20558"
    end
    on_intel do
      url "https://github.com/Ryan-AI-Studios/Ledgerful/releases/download/v0.2.4/ledgerful-x86_64-apple-darwin.tar.gz"
      sha256 "8f406dcd450cef353c01405b86fa6b5d90caea0079d848f09236e2de5f9f34e9"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/Ryan-AI-Studios/Ledgerful/releases/download/v0.2.4/ledgerful-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e019afb406306672014e1c367c9ad7e238fce087997d04c34c228e07b5db648b"
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
