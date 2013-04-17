# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Exceptions.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use lib '../lib';
use Test::More tests => 14;
use Exceptions;
ok(1); # If we made it this far, we're ok.

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $caught;
my $n;

no warnings qw(exiting);
## die and catch ##
eval{
  try{
    die "exception\n";
  }
  catch{
    $caught = $@;
  };
};
ok(!$@);
is($caught, "exception\n");

## throw Exception and catch ##
$caught = 0;
eval{
  try{
    throw Exception => "Exception";
  }
  catch{
    $caught = $@;
  };
};
ok(!$@);
is("$caught", "Exception\n");
isa_ok($caught, 'Exceptions::Exception');
can_ok($caught, 'msg');
is($caught->msg, 'Exception');

## throw Exception and catch Exception ##
$caught = 0;
eval{
  try{
    throw Exception => "Exception";
  }
  catch{
    $caught = $@;
  } 'Exceptions::Exception',
  catch{
    die "error";
  };
};
ok(!$@);
is($caught->msg, "Exception");

## die with string and catch the string ##
$caught = 0;
eval{
  try{
    die "Exception\n";
  }
  catch{
    die "error";
  } 'Exception',
  catch{
    $caught = $@;
  };
};
ok(!$@);
is($caught, "Exception\n");

## loop control statements ##
$n = 0;
eval{
  $n = 0;
  for (my $i = 0; $i < 10; $i++){
    try{
      throw Exception => "next";
    }
    catch{
      next;
    };
    $n++;
  }
};
ok(!$@);
is($n, 0);

