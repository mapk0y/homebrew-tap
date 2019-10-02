class ContainerStructureTest < Formula

  TARGET_NAME = "container-structure-test"
  VERSION = "1.8.0"
  SHA256_MAC = "14e94f75112a8e1b08a2d10f2467d27db0b94232a276ddd1e1512593a7b7cf5a"
  SHA256_LINUX = "cfdfedd77c04becff0ea16a4b8ebc3b57bf404c56e5408b30d4fbb35853db67c"

  desc "Container Structure Tests: Unit Tests for Docker Images"
  homepage "https://github.com/GoogleCloudPlatform/container-structure-test"
  head "https://github.com/GoogleCloudPlatform/container-structure-test.git", :branch => 'master'
  version VERSION

  if OS.mac?
    BIN_NAME = "#{TARGET_NAME}-darwin-amd64"
    sha256 SHA256_MAC
  else
    BIN_NAME = "#{TARGET_NAME}-linux-amd64"
    sha256 SHA256_LINUX
  end

  url "https://storage.googleapis.com/container-structure-test/v#{VERSION}/#{BIN_NAME}"

  def install
    bin.install "#{BIN_NAME}" => "#{TARGET_NAME}"
  end

  test do
    assert_equal "v#{VERSION}\n", shell_output("#{bin}/container-structure-test version", result = 0)
    assert_match "container-structure-test provides a powerful framework to validate\nthe structure of a container image.\n",
                  shell_output("#{bin}/container-structure-test help", result = 0)
  end
end
