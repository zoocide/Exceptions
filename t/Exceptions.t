# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Exceptions.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use Test::More tests => 14;
use Exceptions;
ok(1); # If we made it this far, we're ok.

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $catched;

eval{
  try{
    die "exception\n";
  }
  catch{
    $catched = $@;
  };
};
ok(!$@);
is($catched, "exception\n");

eval{
  try{
    throw Exception => "Exception";
  }
  catch{
    $catched = $@;
  };
};
ok(!$@);
is("$catched", "Exception\n");
isa_ok($catched, 'Exceptions::Exception');
can_ok($catched, 'msg');
is($catched->msg, 'Exception');

eval{
  try{
    throw Exception => "Exception";
  }
  catch {
    $catched = $@;
  } 'Exceptions::Exception',
  catch{
    die "error";
  };
};
ok(!$@);
is($catched->msg, "Exception");

eval{
  try{
    die "Exception\n";
  }
  catch {
    die "error";
  } 'Exception',
  catch{
    $catched = $@;
  };
};
ok(!$@);
is($catched, "Exception\n");

TODO: {
  local $TODO = "Problem with loop control statements\n";
my $n;
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
is($n, 10);
}

