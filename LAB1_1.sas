/*Prekybos įmonės vadovai suinteresuoti tiksliau prognozuoti bendrą klientų pasitenkinimo lygį  ir 
išsiaiškinti nuo ko jis labiausiai priklauso. Jie nori sužinoti, kaip bendrasis klientų pasitenkinimas 
(kintamasis X19) priklauso nuo atskirų įmonės paslaugų vertinimo (kintamieji  X6-X18) ir nuo 
kliento įmonės dydžio (X3).   
Duota duomenų matrica HB1 . Iš matricos ištrinkite 3 eilutes 10,39 ir 59.
Sudarykite geriausią regresijos modelį klientų pasitenkinimo prognozavimui, kai 
duotas priklausomas kintamasis Y=X19 ir 14 regresorių X3, X6-X18. Kintamųjų prasmė pateikta 
lentelėje.  
2.  Sudarykite geriausią regresijos  modelį X19 prognozavimui, kai duoti regresoriai X3, X6
X18.  */

libname lab1  "/home/u64062745/sasuser.v94/Daugiamate Statistika/LAB1";
/*
proc import datafile='hb1.sas7bdat'
    out=lab1.hb1
    dbms=sas replace;
run;
*/
data lab1.data;
    set lab1.hb1;
    if _N_ = 10 or _N_ = 39 or _N_ = 59 then delete;  /* Čia triname  eilutes nuo 18 iki 57 */
run;

/* Trečdalį duomenų pasilieka kaip bandymo duomenis, o likusius du trečdalius – kaip treniruočių duomenys */

data lab1.trainingData lab1.testData;
    set lab1.data; /* Pakeiskite 'work.pradiniai_duomenys' į jūsų duomenų rinkinio pavadinimą */
    if ranuni(12345) < 2/3 then output lab1.trainingData;
    else output lab1.testData;
run;


/*1.1 */
/*Sudarykite geriausią lengvai interpretuojamą regresijos  modelį X19 prognozavimui, kuris 
paaiškintų regresorių įtaką  X3, X6-X18 įtaką klientų pasitenkinimui X19*/
proc reg data=lab1.data;
   model X19 = x3 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 /stb partial spec vif;
   run;

proc reg data=lab1.data;
   model X19 = x3 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 /nonprint;
   output out=res r=r;
run;
proc univariate data=res normal;
	var r;
	qqplot/normal(mu=est sigma=est);
	histogram/kernel;
run;

/* Paprastas regresijos modelis su stepwise kintamųjų atranka */
proc reg data=lab1.data;
    model X19 = X3 X6-X18 / selection=stepwise slentry=0.05 slstay=0.05 stb partial spec vif;
    output out=res r=r;
    title "Interpretuojamas regresijos modelis X19 paaiškinimui";
run;
quit;


proc reg data=lab1.data;
   model X19 = X3 x6 X7  X9 x12 /stb partial spec vif;;
   output out=res r=r;
run;
proc univariate data=res normal;
	var r;
	qqplot/normal(mu=est sigma=est);
	histogram/kernel;
run;


/*Išskirtys*/

proc robustreg data=lab1.data;
model X19 = X3 x6 X7  X9 x12 / diagnostics
leverage(MCDInfo CUTOFFALPHA=0.025 MCDALPHA=0.025);
  
ods select SummaryStatistics MCDCenter MCDCov MCDCorr;
ods output diagnostics=Diagnostics(where=(leverage=1));
run;

 /*1.2*/  
/*  parinktis STOP=NONE, atranka tęsiama tol, kol modelyje bus visi nurodyti efektai */
/* plots=asePlot Vidutinės kvadratinės paklaidos (ASE) diagrama */
/*1 modelis*/
proc glmselect data=lab1.trainingData testdata=lab1.testData
plots=(CoefficientPanel(unpack) asePlot Criteria);
model X19 = x3|x6|x7|x8|x9|x10
|x11|x12|x13|x14|x15|x16|x17|x18 @1
/selection=forward(stop=none);
run;
/*2 modelis*/
proc glmselect data=lab1.trainingData testdata=lab1.testData
plots=(CoefficientPanel(unpack) asePlot Criteria);
model X19 = x3|x6|x7|x8|x9|x10
|x11|x12|x13|x14|x15|x16|x17|x18 @1
/selection=forward (select=sbc stop=aic);
 run;
/*3 modelis*/
proc glmselect data=lab1.trainingData testdata=lab1.testData
plots=(CoefficientPanel(unpack) asePlot Criteria);
model X19 = x3|x6|x7|x8|x9|x10
|x11|x12|x13|x14|x15|x16|x17|x18 @1
/selection = stepwise(select=sl);
run;
/*4 modelis*/
proc glmselect data=lab1.trainingData testdata=lab1.testData
plots=(CoefficientPanel(unpack) asePlot Criteria);
model X19 = x3|x6|x7|x8|x9|x10
|x11|x12|x13|x14|x15|x16|x17|x18 @1
/selection = stepwise(select=sl choose=press);
run;

/**/

proc reg data=lab1.data;
   model X19 = x6 X7 x12 /stb partial spec vif;;
   output out=res r=r;
run;
proc univariate data=res normal;
	var r;
	qqplot/normal(mu=est sigma=est);
	histogram/kernel;
run;


