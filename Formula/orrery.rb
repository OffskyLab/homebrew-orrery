class Orrery < Formula
  desc "Orrery — AI CLI environment manager for Claude Code, Codex, and Gemini CLI"
  homepage "https://github.com/OffskyLab/Orrery"
  version "2.4.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/OffskyLab/Orrery/releases/download/v#{version}/orrery-darwin-arm64.tar.gz"
      sha256 "0e14bad1a5764a1188e20fc960084010420966bedad34b7d99d69f6af891eb6b"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/OffskyLab/Orrery/releases/download/v#{version}/orrery-linux-x86_64.tar.gz"
      sha256 "ef5b5c6c7277bf43075c6aa861dd026b59b90fe5af1b6a745ac12464a7cdae78"
    end
    on_arm do
      url "https://github.com/OffskyLab/Orrery/releases/download/v#{version}/orrery-linux-arm64.tar.gz"
      sha256 "41ff2a3375a7373f7896a718eaf201aee6a81ef249aa95a3c4c588cb4c3744e3"
    end
  end

  depends_on "OffskyLab/orrery/orrery-sync"

  conflicts_with "orbital",
    because: "orbital was renamed to orrery; install one or the other"

  def install
    bin.install "orrery-bin"
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
