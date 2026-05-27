class Orrery < Formula
  desc "Orrery — AI CLI environment manager for Claude Code, Codex, and Gemini CLI"
  homepage "https://github.com/OffskyLab/Orrery"
  version "3.0.3"
  license "Apache-2.0"

  on_macos do
    depends_on macos: :sequoia
    on_arm do
      url "https://github.com/OffskyLab/Orrery/releases/download/v#{version}/orrery-darwin-arm64.tar.gz"
      sha256 "f6cd66ade75bbd380222b69884a93578bd8c29e98b783f8f11f0a510bd3ba23c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/OffskyLab/Orrery/releases/download/v#{version}/orrery-linux-x86_64.tar.gz"
      sha256 "c18e00ca4beca88f35f5bcf23833239da55413d9647a2caf86ecfeb51a72982d"
    end
    on_arm do
      url "https://github.com/OffskyLab/Orrery/releases/download/v#{version}/orrery-linux-arm64.tar.gz"
      sha256 "dd8bf18a57b665dbe463a5467cb02ff4cbd84904a5a5f3b008ae5347bd84a8e2"
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

        orrery exit

      Upgrading from Orbital? Just run `orrery` — it will auto-move
      ~/.orbital/ to ~/.orrery/ and update your shell rc file on first run.
    EOS
  end

  test do
    assert_match "#{version}", shell_output("#{bin}/orrery-bin --version")
  end
end
