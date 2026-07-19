options obs=100;  /* cap input rows for the captured run */

/* Stand-in for the upstream `libname analize` + PROC IMPORT of id1.sas7bdat.
   The original reads a local SAS data set we do not have; this DATA step
   builds a small sample with the same columns the script uses
   (X1, X2, X4 continuous; X10 a two-level group; X11 a small count),
   so the author's PROC UNIVARIATE code below runs unchanged. */
data analize_data;
  call streaminit(20240719);
  do _n_ = 1 to 60;
    X1  = 10 + 3*rand('normal');
    X2  =  5 + 2*rand('normal');
    X4  = 20 + 4*rand('normal');
    X10 = 1 + mod(_n_, 2);
    X11 = floor(rand('uniform')*6);
    output;
  end;
run;
