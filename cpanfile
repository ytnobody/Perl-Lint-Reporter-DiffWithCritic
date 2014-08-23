requires 'perl', '5.014';
requires 'Term::ANSIColor';
requires 'Perl::Critic';
requires 'List::MoreUtils';
requires 'Text::WordDiff';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Test::Differences';
    requires 'Perl::Lint';
    requires 'Capture::Tiny';
};

