class ContainerStructureTest < Formula

  CONTAINER_STRUCTURE_TEST_VERSION = "1.0.0"

  desc "Container Structure Tests: Unit Tests for Docker Images"
  homepage "https://github.com/GoogleCloudPlatform/container-structure-test"
  head "https://github.com/GoogleCloudPlatform/container-structure-test.git", :branch => 'master'
  version CONTAINER_STRUCTURE_TEST_VERSION

  url "https://github.com/GoogleCloudPlatform/container-structure-test.git", :tag => "v#{CONTAINER_STRUCTURE_TEST_VERSION}"
  depends_on "make" => :build
  depends_on "go" => :build

  def install
    # https://github.com/Homebrew/homebrew-core/blob/master/Formula/termshare.rb
    ENV['GOPATH'] = buildpath
    path = buildpath/"src/github.com/GoogleCloudPlatform/container-structure-test"
    # root に git clone されたファイルを path にコピー
    path.install Dir["*"]

    cd path do
      system "make"
      bin.install "out/structure-test" => "container-structure-test"
    end
  end

  test do
    assert_equal "Please supply path to image or tarball to test against\n", shell_output("#{bin}/container-structure-test", result = 1)
  end
end
