use strict;
use warnings;
use Perl::Lint qw/lint/;
use Perl::Lint::Reporter::DiffWithCritic;
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Terse = 1;

my $violations = lint([__FILE__]);
print Dumper(violations_diff($violations, -severity => 1));
