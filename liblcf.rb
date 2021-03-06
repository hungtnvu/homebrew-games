class Liblcf < Formula
  desc "Library for RPG Maker 2000/2003 games data"
  homepage "https://easy-rpg.org/"
  url "https://github.com/EasyRPG/liblcf/archive/0.4.1.tar.gz"
  sha256 "2bc4ae3b57b8d0797ab042b7a52f52e9ae5f80239577db3beccedc6fdeac1f0e"
  head "https://github.com/EasyRPG/liblcf.git"
  revision 1

  bottle do
    cellar :any
    sha256 "a8eeea30a9dbf6a5361ddfb6c006101020535acc4ad01ca6bf153238751b04dc" => :el_capitan
    sha256 "99921363016ac15ea7ffcbe7360b692c58c4df0e4c26fc26f8436ae36fa02e16" => :yosemite
    sha256 "dc3b4c5ad1ce20bd88063b7e7a5d5def1c140a28b1e4fc1a4be25528436e4d8b" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "expat"

  def install
    system "autoreconf", "-i"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include "lsd_reader.h"
      #include <cassert>

      int main() {
        std::time_t const current = std::time(NULL);
        assert(current == LSD_Reader::ToUnixTimestamp(LSD_Reader::ToTDateTime(current)));
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}/liblcf", "-L#{lib}", "-llcf", "-std=c++11", \
      "-o", "test"
    system "./test"
  end
end
