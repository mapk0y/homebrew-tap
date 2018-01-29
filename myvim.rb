class Myvim < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https://vim.sourceforge.io/"
  # curl -s https://api.github.com/repos/vim/vim/tags | jq .[0]
  url "https://github.com/vim/vim/archive/v8.0.1428.tar.gz"
  sha256 "481f0f3478dbf6dcf4d0a63d7974966fc0773b17630c46a95825773608ea1f22"
  head "https://github.com/vim/vim.git"

  option "with-gui", "Build with GUI vim(GVim)."
  option "without-override-system-vi", "Not override system vi"
  option "with-client-server", "Enable client/server mode"
  option "without-luajit", "Build vim without luajit support"

  LANGUAGES_OPTIONAL = %w[perl lua].freeze
  LANGUAGES_DEFAULT  = %w[python python3 ruby].freeze

  LANGUAGES_OPTIONAL.each do |language|
    option "with-#{language}", "Build vim with #{language} support"
  end
  LANGUAGES_DEFAULT.each do |language|
    option "without-#{language}", "Build vim without #{language} support"
  end

  depends_on "python" => :recommended
  depends_on "python3" => :recommended
  depends_on "ruby" => "1.8" # Can be compiled against 1.8.x or >= 1.9.3-p385.
  depends_on "perl" => "5.3"
  depends_on "luajit" => :recommended
  if OS.mac?
    depends_on :x11 if build.with? "client-server"
  end 
  depends_on "gettext" => :recommended
  depends_on "ncurses" unless OS.mac?

  conflicts_with "ex-vi",
    :because => "vim and ex-vi both install bin/ex and bin/view"

  conflicts_with "vim",
    :because => "MyVim and vim both install bin/ex and bin/view"

  def install
    # https://github.com/Homebrew/homebrew-core/pull/1046
    ENV.delete("SDKROOT")

    # vim doesn't require any Python package, unset PYTHONPATH.
    ENV.delete("PYTHONPATH")

    if build.with?("python") && which("python").to_s == "/usr/bin/python" && !MacOS::CLT.installed?
      # break -syslibpath jail
      ln_s "/System/Library/Frameworks", buildpath
      ENV.append "LDFLAGS", "-F#{buildpath}/Frameworks"
    end

    opts = []

    (LANGUAGES_OPTIONAL + LANGUAGES_DEFAULT).each do |language|
      opts << "--enable-#{language}interp" if build.with? language
    end

    #if opts.include?("--enable-pythoninterp") && opts.include?("--enable-python3interp")
    #  # only compile with either python or python3 support, but not both
    #  # (if vim74 is compiled with +python3/dyn, the Python[3] library lookup segfaults
    #  # in other words, a command like ":py3 import sys" leads to a SEGV)
    #  opts -= %w[--enable-pythoninterp]
    #end

    if build.with? "gui"
      opts << "--enable-gui=yes"
    else
      opts << "--enable-gui=no"
    end

    if build.with? "client-server"
      opts << "--with-x"
    else
      opts << "--without-x"
    end

    if build.with?("lua") || build.with?("luajit")
      ENV["LUA_PREFIX"] = HOMEBREW_PREFIX
      opts << "--enable-luainterp"
      opts << "--with-luajit" unless build.without? "luajit"

      if build.with?("lua") && build.with?("luajit")
        onoe <<-EOS.undent
          Vim will not link against both Luajit & Lua simultaneously.
          Proceeding with Lua.
        EOS
        opts -= %w[--with-luajit]
      end
    end

    # We specify HOMEBREW_PREFIX as the prefix to make vim look in the
    # the right place (HOMEBREW_PREFIX/share/vim/{vimrc,vimfiles}) for
    # system vimscript files. We specify the normal installation prefix
    # when calling "make install".
    # Homebrew will use the first suitable Perl & Ruby in your PATH if you
    # build from source. Please don't attempt to hardcode either.
    system "./configure", "--prefix=#{HOMEBREW_PREFIX}",
                          "--with-features=huge",
                          "--mandir=#{man}",
                          "--enable-multibyte",
                          "--with-tlib=ncurses",
                          "--enable-cscope",
                          "--enable-terminal",
                          "--enable-fail-if-missing",
                          "--with-compiledby=Homebrew",
                          *opts
    system "make"
    # Parallel install could miss some symlinks
    # https://github.com/vim/vim/issues/1031
    ENV.deparallelize
    # If stripping the binaries is enabled, vim will segfault with
    # statically-linked interpreters like ruby
    # https://github.com/vim/vim/issues/114
    system "make", "install", "prefix=#{prefix}", "STRIP=#{which "true"}"
    bin.install_symlink "vim" => "vi" unless build.without? "override-system-vi"
  end

  test do
    if build.with? "python3"
      (testpath/"commands.vim").write <<-EOS.undent
        :python3 import vim; vim.current.buffer[0] = 'hello python3'
        :wq
      EOS
      system bin/"vim", "-T", "dumb", "-s", "commands.vim", "test.txt"
      assert_equal "hello python3", File.read("test.txt").chomp
    elsif build.with? "python"
      (testpath/"commands.vim").write <<-EOS.undent
        :python import vim; vim.current.buffer[0] = 'hello world'
        :wq
      EOS
      system bin/"vim", "-T", "dumb", "-s", "commands.vim", "test.txt"
      assert_equal "hello world", File.read("test.txt").chomp
    end
    if build.with? "gettext"
      assert_match "+gettext", shell_output("#{bin}/vim --version")
    end
  end
end
