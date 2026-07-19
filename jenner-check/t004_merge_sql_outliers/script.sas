/*2.3. Užduotis. Išskirčių pašalinimas.
Rikiuojame abu duomenų rinkinius pagal ID, pašaliname pažymėtas išskirtis
(anti-join per MERGE) ir suskaičiuojame, kiek stebinių liko.

Stand-in for the two upstream data sets the outlier-removal step joins:
`analize.isskirtys` (all observations with a response column Z) and
`analize.Diagnostics` (the rows flagged as outliers). The original builds
these from hb3b.sas7bdat + PROC ROBUSTREG diagnostics; here we seed a small
sample plus a short list of flagged ids so the author's sort / merge /
PROC SQL code below runs unchanged (80 - 4 = 76 remaining). */
data isskirtys;
  call streaminit(20240719);
  do id = 1 to 80;
    X6 = rand('normal'); X7 = rand('normal'); Z = rand('normal');
    output;
  end;
run;

data Diagnostics;
  do id = 5, 22, 49, 69;
    output;
  end;
run;

/* 1. Rikiuojame abu duomenų rinkinius pagal ID */
proc sort data=isskirtys;   by id; run;
proc sort data=Diagnostics; by id; run;

/* 2. Šaliname išskirtis */
data data_clean;
    merge isskirtys(in=a) Diagnostics(in=b);
    by id;
    if a and not b;
run;

/* 3. Pasitikriname, kiek įrašų liko */
proc sql;
    select count(*) as Pradinis_kiekis from isskirtys;
    select count(*) as Iskirtys        from Diagnostics;
    select count(*) as Po_valymo        from data_clean;
quit;
