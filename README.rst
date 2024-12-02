Host-target data transfers in function calls with OpenMP and OpenACC
====================================================================

Test code to try and understand the data transfers that happen when calling
functions which contain OpenMP and OpenACC directives.

Each array is 100k elements of 4 bytes each, so the size is 0.4 MB.

When the OpenACC version is called with ``nk = 10``::

   Total (MB)  Count  Avg (MB)  Med (MB)  Min (MB)  Max (MB)  StdDev (MB)           Operation
   ----------  -----  --------  --------  --------  --------  -----------  ----------------------------
        0.800      2     0.400     0.400     0.400     0.400        0.000  [CUDA memcpy Host-to-Device]
        0.400      1     0.400     0.400     0.400     0.400        0.000  [CUDA memcpy Device-to-Host]

.. The ``present(x)`` clause appears to prevent internal data transfers.

When the OpenMP version is called (without any support clauses)::

   Total (MB)  Count  Avg (MB)  Med (MB)  Min (MB)  Max (MB)  StdDev (MB)           Operation
   ----------  -----  --------  --------  --------  --------  -----------  ----------------------------
      4.800     12     0.400     0.400     0.400     0.400        0.000  [CUDA memcpy Host-to-Device]
      4.000     10     0.400     0.400     0.400     0.400        0.000  [CUDA memcpy Device-to-Host]

There are 12 transfers to the device and 10 off of the device.

It appears to be one extra transfer to and from the device per call.

This is bad for us, since we don't want any redundant transfers per call.

It is also a bit strange, why isn't it 8.8 and 4.4 MB total data transfer?
