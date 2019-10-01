class CloudBuildLocal < Formula

  TARGET_NAME = "cloud-build-local"
  VERSION = "0.4.3"
  SHA256_MAC = "a13f728018c8effe3bd37c7550eded4c4f838f01105802e2d1a7516d7f799dea"
  SHA256_LINUX = "2ebc412741935e75161f96a11642043ed26340049b136bb38dd07bdc59d9ed38"

  desc "Local Build runs Google Cloud Build builds locally"
  homepage "https://github.com/GoogleCloudPlatform/cloud-build-local"
  head "https://github.com/GoogleCloudPlatform/cloud-build-local.git", :branch => 'master'
  version VERSION

  depends_on "go" => :build

  if OS.mac?
    BIN_NAME = "#{TARGET_NAME}_darwin_amd64-v#{VERSION}"
    sha256 SHA256_MAC
  else
    BIN_NAME = "#{TARGET_NAME}_linux_amd64-v#{VERSION}"
    sha256 SHA256_LINUX
  end

  url "https://storage.googleapis.com/local-builder/#{BIN_NAME}"

  def install
    bin.install "#{BIN_NAME}" => "#{TARGET_NAME}"
  end

  test do
    output = shell_output("#{bin}/#{TARGET_NAME} -version 2>&1")
    assert_match /Version:\s+v#{VERSION}/, output
  end
end
