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
  version "0.2.7"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/Ryan-AI-Studios/Ledgerful/releases/download/v0.2.7/ledgerful-aarch64-apple-darwin.tar.gz"
      sha256 "9eb724c1307729eda79e328cc7e0de337d189de71f9f9e93b3fa3ba60fc9da2e"
    end
    on_intel do
      url "https://github.com/Ryan-AI-Studios/Ledgerful/releases/download/v0.2.7/ledgerful-x86_64-apple-darwin.tar.gz"
      sha256 "9267b6fc5a62500578d461e3583191a57f6e5cada330c6cd3d94c8a1a47c22af"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/Ryan-AI-Studios/Ledgerful/releases/download/v0.2.7/ledgerful-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5e1d6e284c3e9aec677c8381657b22d31870653120cd8056040b4faabd771267"
    end
  end

  def install
    # Archive tar nests ledgerful-{target}/…; Homebrew stages that directory as
    # buildpath, so the binary is usually a direct child. Nested glob is fallback
    # if staging ever leaves an extra level.
    binary = Pathname.glob(buildpath/"ledgerful").first ||
             Pathname.glob(buildpath/"ledgerful-*/ledgerful").first
    if binary.nil?
      children = begin
        Dir.children(buildpath).sort.join(", ")
      rescue StandardError
        "(unreadable)"
      end
      odie "ledgerful binary not found in archive (buildpath children: #{children})"
    end

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
