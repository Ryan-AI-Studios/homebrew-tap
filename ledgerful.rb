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
  version "0.2.1"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/Ryan-AI-Studios/Ledgerful/releases/download/v0.2.1/ledgerful-aarch64-apple-darwin.tar.gz"
      sha256 "b6385d01291154af6b6792bb3ee41cbc1c6faad14bf5bd54e8369b163a9a969d"
    end
    on_intel do
      url "https://github.com/Ryan-AI-Studios/Ledgerful/releases/download/v0.2.1/ledgerful-x86_64-apple-darwin.tar.gz"
      sha256 "7d5e58c03a76597839e6636f41ea0df8831a92bbed1e1f7346170fe37b98eeb8"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/Ryan-AI-Studios/Ledgerful/releases/download/v0.2.1/ledgerful-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "db8a26f4ffa44e46dd1094b8c028caf0966782c43c7d1e504acb55ca5238deda"
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
