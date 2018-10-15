use strict;
use warnings;
use Digest::MD5 qw(md5 md5_hex md5_base64);
use Digest::file qw(digest_file_hex);

my $DB_Name = 'save.ini';
my %map_digest;

Menu();
sub Menu {
    while (1){
        print "Enter 1:  Giam Sat File. \n";
        print "Enter 2:  Kiem Tra Giam Sat Thu Muc. \n";
        print "Enter 3:  Luu Trang Thai Thu Muc. \n";
        print "Enter 0: Thoat.\n";
        
        my $menu = <STDIN>;
        chomp $menu;

        if ($menu == 1) {
            monitorFile();
        }elsif ($menu == 2){
            my $foldername = InputFolder();            
            monitorFolder($foldername);
        }if ($menu == 3) {
            my $foldername = InputFolder();
            saveFolderStatus($foldername);
        }elsif ($menu == 0){
            exit;
        }
    }
}

sub monitorFile {
    print "Nhap File Theo Can Giam Sat: ";
    my $fileinput = <STDIN>;
    chomp $fileinput;

    open DATA, "<$fileinput" or die "File Not Exit";

    my $olddigest = md5_hex(<DATA>);
    close(DATA);

    #writeDB("$fileinput:$olddigest");

    while (1) {
        open (DATAFILE, "<$fileinput") or die ("error initial File");
        my $newdigest = md5_hex(<DATAFILE>);
        close(DATAFILE);
        if ($newdigest eq $olddigest){
            sleep 1;
        } else {
            print "File changed \n";
            exit;
        }
    }
}
sub ReadDB {
    open(my $fh, '<', $DB_Name) or die "Could not open file '$DB_Name' $!";;
    while(my $line = <$fh>){
        chomp($line);
        my ($key,$digest) = split(':', $line);
        $map_digest{$key} = $digest;
    }
    close($fh);
}

sub InputFolder {
    print "Nhap Thu Muc Can Giam Sat: ";
    my $directory = <STDIN>;
    chomp $directory;
    opendir (DIR, $directory) or die $!;

    return $directory
}
sub monitorFolder {
    my $directory;
    foreach (@_) {
        $directory = $_;
    } 

    ReadDB();
    print %map_digest;
    while(my $input_file = readdir(DIR)){
        next if ($input_file =~ /^\./);
        if (exists $map_digest{$input_file}) { 
            if ($map_digest{$input_file} ne digest_file_hex($directory.'/'.$input_file, "MD5")){
                print "File $input_file changed! \n";
            }
            else{
                print "File $input_file not changed! \n";
            }
        }else{ 
            if(-e $directory.'/'.$input_file){
                print "File $input_file changed!!! \n";
            }else{
                print "File $input_file is not exist!";
            }
        }
    }
    
}

sub saveFolderStatus {
    my $directory;
    foreach (@_) {
        $directory = $_;
    }  
    open(my $DBFILE, '>', $DB_Name);
    while(my $file = readdir(DIR)){
        #next if ($file ne ".." || $file ne ".." );
        next if ($file =~ /^\./);
        my $file_path = $directory.'/'.$file;
        print $DBFILE "$file:", digest_file_hex($file_path, "MD5"),"\n" ;
    }
    close($DBFILE);
}