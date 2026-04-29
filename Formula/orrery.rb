class Orrery < Formula
  desc "Orrery — AI CLI environment manager for Claude Code, Codex, and Gemini CLI"
  homepage "https://github.com/OffskyLab/Orrery"
  version "2.6.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/OffskyLab/Orrery/releases/download/v#{version}/orrery-darwin-arm64.tar.gz"
      sha256 "3dc541b61046863eef5949db761a793ff66a90f917ad29032cf811ed7d64ceb7"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/OffskyLab/Orrery/releases/download/v#{version}/orrery-linux-x86_64.tar.gz"
      sha256 "570433d65ed2f37e489212f6958a6327099e9df33ef74607e0c94640838d0424"
    end
    on_arm do
      url "https://github.com/OffskyLab/Orrery/releases/download/v#{version}/orrery-linux-arm64.tar.gz"
      sha256 "6cba0f51b7c2daad52384830c4f841af28595d4729e6f9f2eaf3e8e483875793"
    end
  end

  depends_on "OffskyLab/orrery/orrery-sync"

  conflicts_with "orbital",
    because: "orbital was renamed to orrery; install one or the other"

  def install
    bin.install "orrery-bin"
    Dir["orrery_OrreryThirdParty.*"].each { |d| bin.install d }
    # Legacy `orrery` binary from pre-2.4 installs must be gone — the shell
    # function in activate.sh is now the only way to invoke orrery.
    rm_f bin/"orrery"
  end

  def post_install
    # Generates ~/.orrery/activate.sh, patches the user's rc file with the
    # lazy-bootstrap stub, and performs origin takeover. `orrery-bin setup`
    # is idempotent and skips interactive prompts when /dev/tty is
    # unavailable, so it's safe on both fresh install and upgrade.
    system bin/"orrery-bin", "setup"
  rescue => e
    opoo "orrery setup failed: #{e.message}"
    opoo "Run `orrery setup` manually once brew finishes."
  end

  def caveats
    <<~EOS
      Activate Orrery in the current shell:

        source ~/.orrery/activate.sh

      New shells pick it up automatically via your rc file.

      To return to your original config at any time:

        orrery use origin

      Upgrading from Orbital? Just run `orrery` — it will auto-move
      ~/.orbital/ to ~/.orrery/ and update your shell rc file on first run.
    EOS
  end

  test do
    assert_match "#{version}", shell_output("#{bin}/orrery-bin --version")
  end
end
