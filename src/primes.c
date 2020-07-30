#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>

#define test(p) (primes[p >> 6] & 1 << (p & 0x3f))
#define set(p) (primes[p >> 6] |= 1 << (p & 0x3f))
#define is_prime(p) !test(p)

int main()
{
	int limit = 33333333;
	size_t primes_size = ((limit >> 6) + 1);
	uint64_t *primes = (uint64_t*)calloc(primes_size, sizeof(uint64_t));
	int64_t p = 2, sqrt_limit = (int64_t)sqrt(limit);
	while (p <= limit >> 1) {
		for (int64_t n = 2 * p; n <= limit; n += p) if (!test(n)) set(n);
		while (++p <= sqrt_limit && test(p));
	}
	for (int i = limit; i > 0; i--) {
		if (is_prime(i)) {
			printf("%d\n", i);
			return 0;
		}
	}
};
