class CloudBuildLocal < Formula

  TARGET_NAME = "cloud-build-local"
  VERSION = "0.5.0"
  SHA256_MAC = "27019b14c8ae7680c3f667aab7c1a02e0ad17381cf2462ed40f6158ea3ca886d"
  SHA256_LINUX = "4c84e19f973236fbad580f0ec06d3e1e41a2e881da946bd3d9ca55d478f5c94e"

  desc "Local Build runs Google Cloud Build builds locally"
  homepage "https://github.com/GoogleCloudPlatform/cloud-build-local"
  head "https://github.com/GoogleCloudPlatform/cloud-build-local.git", :branch => 'master'
  version VERSION

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
