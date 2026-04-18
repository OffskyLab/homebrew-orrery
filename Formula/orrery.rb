class Orrery < Formula
  desc "Orrery — AI CLI environment manager for Claude Code, Codex, and Gemini CLI"
  homepage "https://github.com/OffskyLab/Orrery"
  version "2.3.2"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/OffskyLab/Orrery/releases/download/v#{version}/orrery-darwin-arm64.tar.gz"
      sha256 "2850772b2d31b34caa98efabfefbe382da2738a44f2de51bd45bccb52aa57783"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/OffskyLab/Orrery/releases/download/v#{version}/orrery-linux-x86_64.tar.gz"
      sha256 "9a6dfe14c82b83252d6cf3cdffa65835654b5f2f20f245339ff2501cd1ae16ce"
    end
    on_arm do
      url "https://github.com/OffskyLab/Orrery/releases/download/v#{version}/orrery-linux-arm64.tar.gz"
      sha256 "f685e3bb3a774c548eb179981cf828aa18e5b2c425456fbdbccd89ad8f77b0f1"
    end
  end

  depends_on "OffskyLab/orrery/orrery-sync"

  conflicts_with "orbital",
    because: "orbital was renamed to orrery; install one or the other"

  def install
    bin.install "orrery"
  end

  def caveats
    <<~EOS
      To get started, run:

        orrery setup && source ~/.orrery/activate.sh

      To return to your original config at any time:

        orrery use origin

      Upgrading from Orbital? Just run `orrery` — it will auto-move
      ~/.orbital/ to ~/.orrery/ and update your shell rc file on first run.
    EOS
  end

  test do
    assert_match "#{version}", shell_output("#{bin}/orrery --version")
  end
end
