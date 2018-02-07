class ContainerBuilderLocal < Formula


  TARGET_NAME = "container-builder-local"
  CONTAINER_BUILDER_LOCAL_VERSION = "0.2.6"
  SHA256_MAC = "7e1f4e3d61aac79f4ff55488948f9feea18826660fb0dae96e53adb230db1f34"
  SHA256_LINUX = "b433763842ba2434d9e0c7f7a778d5db7c560c8b7531b7d8170027a89bc452f3"


  desc "Local Builder runs Google Cloud Container Builder builds locally"
  homepage "https://github.com/GoogleCloudPlatform/container-builder-local"
  head "https://github.com/GoogleCloudPlatform/container-builder-local.git", :branch => 'master'
  version CONTAINER_BUILDER_LOCAL_VERSION

  depends_on "go" => :build

  if OS.mac?
    BIN_NAME = "#{TARGET_NAME}_darwin_amd64-v#{CONTAINER_BUILDER_LOCAL_VERSION}"
    sha256 SHA256_MAC
  else
    BIN_NAME = "#{TARGET_NAME}_linux_amd64-v#{CONTAINER_BUILDER_LOCAL_VERSION}"
    sha256 SHA256_LINUX
  end
  url "https://storage.googleapis.com/container-builder-local/#{BIN_NAME}"
    
  def install
    bin.install "#{BIN_NAME}" => "#{TARGET_NAME}"
  end

  test do
    output = shell_output("#{bin}/#{TARGET_NAME} -version 2>&1")
    assert_match /Version:\s+v#{CONTAINER_BUILDER_LOCAL_VERSION}/, output
  end
end
