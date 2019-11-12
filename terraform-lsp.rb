class TerraformLsp < Formula

  TARGET_NAME = "terraform-lsp"
  VERSION = "0.0.9"
  # V=$(curl -sL https://api.github.com/repos/juliosueiras/terraform-lsp/tags | jq -r .[0].name)
  # && curl -sL https://github.com/juliosueiras/terraform-lsp/releases/download/${V}/terraform-lsp_${V#v}_linux_amd64.tar.gz | sha256sum
  # && curl -sL https://github.com/juliosueiras/terraform-lsp/releases/download/${V}/terraform-lsp_${V#v}_darwin_amd64.tar.gz | sha256sum
  SHA256_LINUX = "55fec793344f6377f53b6955a394cc87e15c4384d2ac9b4193c792de90c13f7a"
  SHA256_MAC = "eb78efa0ead93a9e0b7e05349334e57b7e70c11a818a2feded65079604de3b71"

  desc "Language Server Protocol for Terraform"
  homepage "https://github.com/juliosueiras/terraform-lsp"
  head "https://github.com/juliosueiras/terraform-lsp.git", branch: "master"
  version VERSION

  if OS.mac?
    BIN_NAME = "#{TARGET_NAME}_#{VERSION}_darwin_amd64.tar.gz"
    sha256 SHA256_MAC
  else
    BIN_NAME = "#{TARGET_NAME}_#{VERSION}_linux_amd64.tar.gz"
    sha256 SHA256_LINUX
  end

  url "https://github.com/juliosueiras/terraform-lsp/releases/download/v#{VERSION}/#{BIN_NAME}"

  def install
    bin.install "#{TARGET_NAME}" => "#{TARGET_NAME}"
  end

  test do
    output = shell_output("#{bin}/#{TARGET_NAME} -h 2>&1", result = 2)
    assert_match /Usage of .*terraform-lsp:/, output
  end
end
