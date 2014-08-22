package Perl::Lint::Reporter::DiffWithCritic;
use 5.014;
use strict;
use warnings;

use parent 'Exporter';
use Term::ANSIColor;
use Perl::Critic;
use List::MoreUtils qw/uniq/;

our $VERSION = 0.01;
our @EXPORT = qw/report_violations_with_diff/;

sub report_violations_with_diff {
    my ($violations, %critic_options) = @_;

    my @lint_vio_list = @$violations;
    my @files = uniq sort {$a->{filename} cmp $b->{filename}} map {$_->{filename}} @lint_vio_list;

    my @critic_vio_list = _critic_violations([@files], %critic_options);
}

sub _critic_violations {
    my ($files, %critic_options) = @_;

    my $critic = Perl::Critic->new(%critic_options);

    my @violations = ();
    for my $file (@$files) {
        push @violations, $critic->critique($file);
    }

    return map {_transform_violation_lintstyle($_)} @violations;
}

sub _transform_violation_lintstyle {
    my $critic_vio = shift;
    +{
        explanation => $critic_vio->explanation,
        filename    => $critic_vio->filename,
        policy      => $critic_vio->policy =~ s/^Perl::Critic::/Perl::Lint::/r,
        line        => $critic_vio->line_number,
        description => $critic_vio->description,
    };
}

1;
__END__

=encoding utf-8

=head1 NAME

Perl::Lint::Reporter::DiffWithCritic - It's new $module

=head1 SYNOPSIS

    use Perl::Lint::Reporter::DiffWithCritic;

=head1 DESCRIPTION

Perl::Lint::Reporter::DiffWithCritic is ...

=head1 LICENSE

Copyright (C) ytnobody.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

ytnobody E<lt>ytnobody@gmail.comE<gt>

=cut

