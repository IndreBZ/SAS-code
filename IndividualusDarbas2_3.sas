/*2.3. Užduotis. Prekybos įmonės vadovai siekdami  didinti  klientų pasitenkinimo lygį atliko klientų 
apklausą, kurios dalis rezultatų pateikti duomenų matricoje  HB3B. Kintamųjų prasmė pateikta 
1 lentelėje. 
• Sudarykite matricą HB3B_N iš matricos HB3B ištrindami 3 eilutes (N, N+40 ir N+60),  čia 
N - jūsų varianto numeris) ir palikite kintamuosius ID,  X6-X18. Toliau dirbkite su matrica 
HB3B_N. 
• Patikrinkite atsitiktinio vektoriaus (X6, X7, ...., X18) suderinamumą su daugiamačiu 
normaliuoju skirstiniu. Parašykite išvadas. 
• Nustatykite ir pašalinkite išskirtis. Parašykite išvadas.  
• Po išskirčių pašalinimo patikrinkite atsitiktinio vektoriaus (X6, X7, ...., X18) suderinamumą 
su daugiamačiu normaliuoju skirstiniu. Parašykite išvadas. 
• Su kokiu didžiausiu koordinačių poaibiu  daugiamačio vektoriaus skirstinys suderinamas su 
daugiamačiu normaliuoju skirstiniu?  Pagrįskite  savo atsakymą.  Kiek ir kokios yra vektoriaus 
koordinatės? Kiek liko stebinių? Parašykite išvadas.  */

libname analize  "/home/u64062745/sasuser.v94/Daugiamate Statistika";

proc import datafile='hb3b.sas7bdat'
    out=analize.hb3b
    dbms=sas replace;
run;

data analize.data;
    set analize.hb3b;
    if _N_ = 9 or _N_ = 49  or _N_ = 69 then delete;  /* Čia triname  eilutes nuo 18 iki 57 */
run;

/*
Patikrinkite atsitiktinio vektoriaus (X6, X7, ...., X18) suderinamumą su daugiamačiu 
normaliuoju skirstiniu.*/

PROC MODEL data = analize.data;
X6=a6;
X7=a7;
X8=a8;
X9=a9;
X10=a10;
X11=a11;
X12=a12;
X13=a13;
X14=a14;
X15=a15;
X16=a16;
X17=a17;
X18=a18;
fit X6-X18 / normal ;
run;


proc factor data=analize.data method=principal;
   var X6-X18;
   run;

/*Nustatykite ir pašalinkite išskirtis. Parašykite išvadas.*/


/* Funkcija RANNOR pateikia kintamąjį, sugeneruotą iš normalaus skirstinio, kurio vidurkis 0 ir dispersija 1. */
DATA analize.isskirtys;
set analize.data;
Z=rannor(12); /* atsako kintamojo pasirinkimas yra nesvarbus */
*id = _N_; /* <-- ID pridėjimas */
run;




proc robustreg data=analize.isskirtys;
model Z = X6 X7 X8 X9 X10 X11 X12 X13 X14 X15 X16 X17 / diagnostics
leverage(MCDInfo CUTOFFALPHA=0.025 MCDALPHA=0.025);
ID id;
ods select SummaryStatistics MCDCenter MCDCov MCDCorr;
ods output diagnostics=analize.Diagnostics(where=(leverage=1));
run;

 
/* Arba robustreg */
ods graphics on;
proc robustreg data=analize.isskirtys plots=all;
   model Z = X6 X7 X8 X9 X10 X11 X12 X13 X14 X15 X16 X17;
run;
ods graphics off;


Title1 " Identifikuotos vektoriaus (X6 X7 X8 X9 X10 X11 X12 X13 X14 X15 X16 X17) imties išskirtys";
proc print data=Diagnostics;
var ID Mahalanobis RobustDist;
run;


/* 1. Rikiuojame abu duomenų rinkinius pagal ID */
proc sort data=analize.isskirtys; by id; run;
proc sort data=analize.Diagnostics; by id; run;

proc print data=analize.Diagnostics;
run;
/* 2. Šaliname išskirtis */
data analize.data_clean;
    merge analize.isskirtys(in=a) analize.Diagnostics(in=b);
    by id;
    if a and not b;
run;
/* 3. Pasitikriname, kiek įrašų liko */
proc sql;
    select count(*) as Pradinis_kiekis from analize.data;
    select count(*) as Iskirtys from analize.Diagnostics;
    select count(*) as Po_valymo from analize.data_clean;
quit;


PROC MODEL data = analize.data_clean;
X6=a6;
X7=a7;
X8=a8;
X9=a9;
X10=a10;
X11=a11;
X12=a12;
X13=a13;
X14=a14;
X15=a15;
X16=a16;
X17=a17;
X18=a18;
fit X6-X18 / normal ;
run;
