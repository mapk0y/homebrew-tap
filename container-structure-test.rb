class ContainerStructureTest < Formula

  CONTAINER_STRUCTURE_TEST_VERSION = "0.1.3"
  sha256_linux_binary = "ca63483984e9f8296f4bb3b74e70941e991086b19bfb1bfe8f0cb84ee22217ed"

  desc "Container Structure Tests: Unit Tests for Docker Images"
  homepage "https://github.com/GoogleCloudPlatform/container-structure-test"
  head "https://github.com/GoogleCloudPlatform/container-structure-test.git", :branch => 'master'
  version CONTAINER_STRUCTURE_TEST_VERSION

  if OS.mac?
    url "https://github.com/GoogleCloudPlatform/container-structure-test.git", :tag => "v#{CONTAINER_STRUCTURE_TEST_VERSION}"
    depends_on "make" => :build
    depends_on "go" => :build
  else
    url "https://storage.googleapis.com/container-structure-test/v#{CONTAINER_STRUCTURE_TEST_VERSION}/container-structure-test"
    sha256 sha256_linux_binary
  end

  def install
    if OS.mac?
      # https://github.com/Homebrew/homebrew-core/blob/master/Formula/termshare.rb
      ENV['GOPATH'] = buildpath
      path = buildpath/"src/github.com/GoogleCloudPlatform/container-structure-test"
      # root に git clone されたファイルを path にコピー
      path.install Dir["*"]

      cd path do
        system "make"
        bin.install "out/structure-test" => "container-structure-test"
      end
    else
      bin.install "container-structure-test"
    end
  end

  test do
    system "#{bin}/container-structure-test"
  end
end
