# use File::Find;
# my $directory = "./subfolder";
# opendir (DIR, $directory) or die $!;
# find(\&getFile,  $directory);

# sub getFile {
#     if (-d){

#     }else{
#         print $File::Find::name, "\n";
#     }
# }
#  my $dir = "./subfolder";

# opendir DIR,$dir;
# my @dir = readdir(DIR);
# close DIR;
# foreach(@dir){
#     if (-f $dir . "/" . $_ ){
#         print $_,"   : file\n";
#     }elsif(-d $dir . "/" . $_){
#         print $_,"   : folder\n";
#     }else{
#         print $_,"   : other\n";
#     }
# }


use strict;
use warnings;
use File::Find;
use Digest::MD5 qw(md5 md5_hex md5_base64);
use Digest::file qw(digest_file_hex);
print digest_file_hex('./subfolder/file3.txt', "MD5"),"\n" ;