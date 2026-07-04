class Orrery < Formula
  desc "Orrery — AI CLI environment manager for Claude Code, Codex, and Gemini CLI"
  homepage "https://github.com/OffskyLab/Orrery"
  version "3.1.1"
  license "Apache-2.0"

  on_macos do
    depends_on macos: :sequoia
    on_arm do
      url "https://github.com/OffskyLab/Orrery/releases/download/v#{version}/orrery-darwin-arm64.tar.gz"
      sha256 "0ea40113d5f5a9f50ba1a47be8cb1f52574a5a2e10b57a9c35203db00c0c409c"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/OffskyLab/Orrery/releases/download/v#{version}/orrery-linux-x86_64.tar.gz"
      sha256 "a9972cde94c4de54f4edd43f9d2e78c5c01a2010657867c106578c54780240d5"
    end
    on_arm do
      url "https://github.com/OffskyLab/Orrery/releases/download/v#{version}/orrery-linux-arm64.tar.gz"
      sha256 "d86d33b92e945033352be56daefc6576a26791578441b3995174c9cc5f127daa"
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
