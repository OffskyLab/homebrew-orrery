class OrrerySync < Formula
  desc "Orrery P2P memory sync daemon"
  homepage "https://github.com/OffskyLab/orrery-sync"
  version "2.0.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/OffskyLab/orrery-sync/releases/download/v#{version}/orrery-sync-darwin-arm64.tar.gz"
      sha256 "0269317f4a13cbe0105546d66c1a2cc5d35b56547aeb4ce8a7c1609e28b71a19"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/OffskyLab/orrery-sync/releases/download/v#{version}/orrery-sync-linux-x86_64.tar.gz"
      sha256 "70a2fad8f1f2b924f672cfcda654a4d30238d93f19d9602481b13f245540c755"
    end
    on_arm do
      url "https://github.com/OffskyLab/orrery-sync/releases/download/v#{version}/orrery-sync-linux-arm64.tar.gz"
      sha256 "84a9c3e8199ca2643c7cf4725b3a6e1c8a8a6d093def0b1590774e0e0413ffcb"
    end
  end

  conflicts_with "orbital-sync",
    because: "orbital-sync was renamed to orrery-sync; install one or the other"

  def install
    bin.install "orrery-sync"
  end

  test do
    assert_match "#{version}", shell_output("#{bin}/orrery-sync --version")
  end
end
