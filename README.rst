Host-target data transfers in function calls with OpenMP and OpenACC
====================================================================

This is an example of calling a function on device whose data has been
transferred outside of the function call.

Device code is generated with OpenACC and OpenMP.  The Makefile is configured
for Nvidia (``nvfortran``).

Each array is 100k elements of 4 bytes; the total size is 0.4 MB.

The function is called multiple times within a loop specific by a command line
argument, saved as ``nk``.

Data transfer is profiled with ``nsys nvprof``.  When the OpenACC version is
called with ``nk = 10``::

   Total (MB)  Count  Avg (MB)  Med (MB)  Min (MB)  Max (MB)  StdDev (MB)           Operation
   ----------  -----  --------  --------  --------  --------  -----------  ----------------------------
        0.800      2     0.400     0.400     0.400     0.400        0.000  [CUDA memcpy Host-to-Device]
        0.400      1     0.400     0.400     0.400     0.400        0.000  [CUDA memcpy Device-to-Host]

This matches the expected data transfer outside of the function.  No data
transfer is presumably computed within the function.

TODO:

* The function just repeats itself, so there's no actual indication that it is
  called multiple times.  Set it up as a cumulant.

* Should OpenMP use a target data region, to mirror OpenACC?


Role of `present()`
-------------------

The OpenACC data region uses ``present()`` to indicate that ``x``, ``y``, and
``z`` are already on the device.  This does not appear to be strictly
necessary, however, and there are no data transfers within the function if this
is removed.

There is no equivalent OpenMP ``target data`` in the code (``map(present, to:
x, y)`` or whatever) since it is not widely supported across compilers.

In truth, I am not exactly sure of the exact role of this clause/clause
modifier.  It may only be a compiler hint?
