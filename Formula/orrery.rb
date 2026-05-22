class Orrery < Formula
  desc "Orrery — AI CLI environment manager for Claude Code, Codex, and Gemini CLI"
  homepage "https://github.com/OffskyLab/Orrery"
  version "3.0.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/OffskyLab/Orrery/releases/download/v#{version}/orrery-darwin-arm64.tar.gz"
      sha256 "fd12b5d3b56b8bd6e8acb961f03db0d5d0fc47f91726ed6fe3c038a421c15c64"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/OffskyLab/Orrery/releases/download/v#{version}/orrery-linux-x86_64.tar.gz"
      sha256 "aa2c8cb108288743924e5a10f0d27ce87240da4a1cfe1251646e095ab5e600c7"
    end
    on_arm do
      url "https://github.com/OffskyLab/Orrery/releases/download/v#{version}/orrery-linux-arm64.tar.gz"
      sha256 "46c677a4f041bce41e3c1ad514fbbb3516e7dd8d36f3e7ac9044448f8df2693e"
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
