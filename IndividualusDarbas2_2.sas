
/*2.2*/
/*Sumodeliuokite dvimačio atsitiktinio vektoriaus, kurio skirstinys yra dvimatis 
normalusis (X1,X2)~N(𝜇,Σ),  su vidurkių vektoriumi 𝝁 ir kovariacijų matrica 𝚺  n = 100 imtį */

* Sukurkime kovariacijų matricos duomenų rinkinį;

data YCov(type=COV);
input _TYPE_ $ 1-8 _NAME_ $ 9-16 X1 X2;
datalines;
COV     X1      1.9  1
COV     X2      1    4
MEAN            6    12
;
run;

* Naudokime PROC SIMNORMAL duomenų generavimui;
proc simnormal data=YCov outsim=Daugiamatis_Normalusis
               nr = 100         /* size of sample */
               seed = 123456; /* random number seed */
   var X1 X2;
run;

/* Patikrinkite atsitiktinio vektoriaus(X1, X2) skirstinio suderinamumo su dvimačiu 
normaliuoju skirstiniu hipotezę*/
PROC MODEL data = Daugiamatis_Normalusis;
X1=a1;
X2=a2;

fit X1 X2 / normal ;
run;

proc univariate data=Daugiamatis_Normalusis;
   var X1 X2;
   histogram X1 / normal;  /* Histograma su normalumo kreive X1 */
   histogram X2 / normal;  /* Histograma su normalumo kreive X2 */
run;

/*Pagal imties duomenis apskaičiuokite  populiacijos skirstinio parametrų μ1, μ2, σ1, σ2 ρ 
taškinius įverčius */
/*proc means data=Daugiamatis_Normalusis mean std;
   var X1 X2;
run;*/
proc corr data=Daugiamatis_Normalusis COV ;
   var X1 X2;
run;

/*
Raskite populiacijos skirstinio parametro ρ (tiesinės koreliacijos koeficiento) 0,95 
pasikliautinąjį intervalą panaudojant Fišerio aproksimaciją (SAS PROC CORR su parametru 
FISHER). Parašykite išvadas apie populiacijos skirstinio parametrus.  */
proc corr data=Daugiamatis_Normalusis COV 
plots(maxpoints=NONE)=matrix(histogram)
 FISHER (alpha=0.05 TYPE=TWOSIDED);
   var X1 X2;
run; 

/*Išskirtys*/

DATA analize.isskirtys;
set Daugiamatis_Normalusis;
Z=rannor(2); /* atsako kintamojo pasirinkimas yra nesvarbus */

run;


proc robustreg data= analize.isskirtys plots=all;
   model Z = X1 X2;
run;

proc robustreg data=analize.isskirtys ;
   model Z = X1 X2 / diagnostics
   leverage(MCDInfo CUTOFFALPHA=0.025 MCDALPHA=0.025);
ID Rnum;
ods select SummaryStatistics MCDCenter MCDCov MCDCorr;
ods output diagnostics=Diagnostics(where=(leverage=1));
run;

proc print data=Diagnostics;
var Rnum Mahalanobis RobustDist;
run;

/*Pavaizduokite (X1,X2) imties tankio funkciją grafiškai */
proc kde data=Daugiamatis_Normalusis;
   bivar X1 X2 / plots=surface;
run;

