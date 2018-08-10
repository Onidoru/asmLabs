# Assembly labs

This repository provides the most interesting part of assembly labs completed on the course of assembly programming. Assembly dialect: masm.

There are also some arithmetical operations in each lab, however they are not described because of simplicity. The main part of every lab is the conversion/lib procedures.

The code is organized with folders - each folder contains it's own lab and it is a separate project because of in each lab the previous procedures sometimes had to be refactored and their signature could change, which would've broken the previous lab. Also it is designed in the way that each procedure is maximally independent from others.

Some parts of the code (especially in lab8) can work not exactly how it is described here because it had been coded more than year and a half ago, however most of it works as it is formally described here.

### Lab5
Lab5 implements asm module for multiplication of integer numbers with any bitness, limited only with computer RAM. As a usage of module, a factorial of a number is found.

Multiplication algorithm is implemented via multiplying N-bit A number by 32-bit nibble of number B, and then adding result + carry flag of the previous operation. Multiplication NxN is done via Nx32 and longAdd procedure, that adds partial result to the final value.

Factorial is counted via iterating from N to (N-i) and multiplying via Nx32.

### Lab7
Lab7 implements StrHex to decimal number conversion, however for implementing a conversion it is required to implement a division D = A/B, where A is a n-bit number, B is a 4-bit 1010 (decimal 10).

One of the simplest algorithms can be implemented as follows:

1. i = n - 4
2. Take 4 last A digits, R = {a_{n-1}, a_{n-2}, a_{n-3}, a_{n-4}}
3.      if (R >= B) {
            R[i] = 1
            R -= B
        } else {
            R[i] = 0
        }
4. i = i - 1, if i < 0, stop.
5. Left shit of R (which is x2 multiplication). Add a_i to R.
6. Return to step 2.

Graphically it can be described as:

![](img/lab5-div.jpg?raw=true "Title")

### Lab8
Lab8 implements conversion of 32-bit floating point number to decimal and some x87 FPU arithmetic. The conversion from float to decimal is quite complicated, however it should be mentioned it is based on exponent and mantissa manipulations. In basics it can be described as:

1. Finding and analyzing exponent (e = E - 127)
2. If E < 0, the number is +/- 0.x
3. If E = 0, the number is +/- 1.x
4. If E > 0, the number is +/- y.x

FP numbers are represented as V = (-1)^S 2^E M.
V = 2^e * F, where F is a fractional part of mantissa. The conversion is simplified to converting each part of the number:

Integer part can be converted via dividing it on 1001 (decimal 10). Fractional part can be converted using multiplication on 10 - the quick way of doing this is one `shl A + shr A`, where shr is a logical shift right three times.





