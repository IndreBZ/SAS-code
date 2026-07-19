options obs=100;  /* cap input rows for the captured run */

/* Stand-in for the upstream `libname analize` + PROC IMPORT of hb3b.sas7bdat
   (the HB3B customer-survey matrix). Builds a small sample carrying the
   ID + X6..X18 columns the factor analysis reads, so the author's
   PROC FACTOR code below runs unchanged. */
data analize_data;
  call streaminit(20240719);
  do id = 1 to 80;
    X6  = rand('normal'); X7  = rand('normal'); X8  = rand('normal');
    X9  = rand('normal'); X10 = rand('normal'); X11 = rand('normal');
    X12 = rand('normal'); X13 = rand('normal'); X14 = rand('normal');
    X15 = rand('normal'); X16 = rand('normal'); X17 = rand('normal');
    X18 = rand('normal');
    output;
  end;
run;
