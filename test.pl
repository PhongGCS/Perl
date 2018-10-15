use strict;
use warnings;
use Digest::MD5 qw(md5 md5_hex md5_base64);
use Digest::file qw(digest_file_hex);
print digest_file_hex('save.ini', "MD5");