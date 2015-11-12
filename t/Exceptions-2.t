#!/usr/bin/perl
use strict;
use warnings;
use lib '../lib';
use Test::More tests => 15;

BEGIN{
  use_ok('Exceptions');
}

my ($e, $c);

##-------------------##
## try; die string; ##
$e = undef;
eval{
  try{
    die "message\n";
  };
  $e = $@;
};
ok(!$e);
is($@, "message\n");

##-------------------##
## try; throw Exception; ##
$e = undef;
eval{
  try{
    throw Exception => 'message';
  };
  $e = $@;
};
ok(!$e);
isa_ok($@, 'Exceptions::Exception');
is($@->msg, 'message');
is("$@", "message\n");

##-------------------##
## try; die string; catch Exception; ##
$e = undef;
$c = 0;
eval{
  try{
    die "message\n";
  }
  catch{
    $c = 1;
  } 'Exception';
  $e = $@;
};
ok(!$e);
is($@, "message\n");
is($c, 0);

##-------------------##
## try; die string; catch; ##
$e = undef;
$c = 0;
eval{
  try{
    die "message\n";
  }
  catch{
    $c = 1;
  };
  $e = $@;
};
ok(!$e);
ok(!$@);
is($c, 1);

##-------------------##
## trim_location ##
$e = undef;
my $msg = 'I stay at home';
my $msg2 = 'oops';
eval{
  try { die $msg; }
  string2exception
  catch {
    $@->trim_location;
    $msg2 = $@->msg;
  };
};
ok(!$e);
is($msg2, $msg);

##-------------------##
## try; throw Exception; catch; ##

##-------------------##
## try; throw Exception; catch Exception; ##

##-------------------##
## try; throw Exception; catch; catch Exception; ##

##-------------------##
## try; throw Exception; catch Exception; catch; ##

##-------------------##
## try{ try{ die string } catch Exception; } catch; ##

##-------------------##
## try{ try{ die string } catch; } catch; ##

##-------------------##
## try{ throw MyException } catch; ##

##-------------------##
## try{ throw MyException } catch 'Exception'; ##

##-------------------##
## try{ throw MyException } catch 'MyException'; ##

##-------------------##
## try{ throw MyException2 } catch 'MyException'; ##

##-------------------##
## try{ try{ throw MyException } catch 'MyException2'; } catch 'MyException'; ##

##-------------------##
## try{ try{ throw MyException } catch; } catch 'MyException'; ##

##-------------------##
## try{ try{ throw MyException } catch{ throw }; } catch 'MyException'; ##

##-------------------##
## try{ try{ throw MyException2 } catch MyException2{ throw MyException } } catch 'MyException'; ##
