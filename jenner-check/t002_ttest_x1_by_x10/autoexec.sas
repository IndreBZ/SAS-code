options obs=100;  /* cap input rows for the captured run */

/* Stand-in for the upstream `libname analize` + PROC IMPORT of id1.sas7bdat.
   Builds a small sample with the columns the t-test uses: X1 continuous,
   X10 a two-level grouping variable (with a genuine mean shift between the
   two groups so the test has something to detect), and X2 for the kernel
   density plot. The author's PROC TTEST / SGPLOT code below runs unchanged. */
data analize_data;
  call streaminit(20240719);
  do _n_ = 1 to 60;
    X10 = 1 + mod(_n_, 2);
    X1  = 10 + 3*rand('normal') + 2*(X10 = 2);
    X2  =  5 + 2*rand('normal');
    output;
  end;
run;
