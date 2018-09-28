#!/usr/bin/perl
use Proc::Daemon;
use Proc::PID::File;
use File::Basename;
$name = basename($0);
$0 = $name;
$daemon = Proc::Daemon->new(
	work_dir => '/home/deploy/peatio/current/',
	pid_file     => '/home/deploy/peatio/current/'.$name.'.pid',
);
$daemon->Init;
$daemon->Status($$);
$pid = $$;
while(1){
    check($pid);
}
if(Proc::PID::File->running()){
    exit(0);
}

sub check() {
    $pid = $_;
    $| = 1;
    $date=`date '+%Y-%m-%d-%H:%M:%S'`;
    chomp($date);
    $checkbot = `ps xauf|grep marketbot-2|egrep -v 'grep|log' | awk '{print \$2}'`;
    chomp($checkbot);
    if (!$checkbot) {
	$startbot = `ruby /home/deploy/peatio/current/marketbot-2.rb > /home/deploy/peatio/current/marketbot-2_logs/marketbot-2-$date.log &`;
    }
    sleep(60);
}

