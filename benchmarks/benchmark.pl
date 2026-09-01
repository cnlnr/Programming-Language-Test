use strict;
use warnings;
use Time::HiRes qw(time);
sub fibonacci { my ($number) = @_; return $number if $number < 2; return fibonacci($number - 1) + fibonacci($number - 2); }
sub count_primes {
    my ($limit) = @_; my @is_prime = (1) x ($limit + 1); $is_prime[0] = $is_prime[1] = 0;
    for my $number (2 .. int(sqrt($limit))) { next unless $is_prime[$number]; for (my $multiple = $number * $number; $multiple <= $limit; $multiple += $number) { $is_prime[$multiple] = 0; } }
    my $count = 0; $count += $_ for @is_prime; return $count;
}
my $fibonacci_input = $ARGV[0] // 35; my $prime_limit = $ARGV[1] // 200000;
my $start = time(); my $fibonacci_result = fibonacci($fibonacci_input); my $fibonacci_time = time() - $start;
$start = time(); my $prime_result = count_primes($prime_limit); my $prime_time = time() - $start;
printf "%.6f,%.6f\n", $fibonacci_time, $prime_time;
