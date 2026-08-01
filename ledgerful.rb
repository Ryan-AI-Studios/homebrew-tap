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
      sha256 "1ea28789544e529e3603dcc45e60f8771cb03de39c1c68fa1595a34afb1158e4"
    end
    on_intel do
      url "https://github.com/Ryan-AI-Studios/Ledgerful/releases/download/v0.2.4/ledgerful-x86_64-apple-darwin.tar.gz"
      sha256 "34d0ea4a1384044a08d58775d2d41f9073f77c2b54de2cbdbdbb2be348de4be7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/Ryan-AI-Studios/Ledgerful/releases/download/v0.2.4/ledgerful-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "431b2208f4aaace343ce1517271991ee36a6245c57e8d6a3e130f3de9d8ce7fe"
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
