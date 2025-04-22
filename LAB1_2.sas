/*
2.1. Užduotis.   Duotas duomenų failas Reg24. Jame yra kiekybiniai regresoriai   X1, X2, ..., X30 ir  kokybiniai 
C1 bei C2, priklausomi kintamieji Y1, Y2, ..., Y30. Sudarykite geriausią interpretuojamą daugialypės tiesinės 
regresijos modelį Y9 prognozavimui ir regresorių įtakos Y9 vertinimui, čia N yra varianto numeris.  
2.2. Užduotis.   Duotas duomenų failas Reg24. Jame yra kiekybiniai regresoriai   X1, X2, ..., X30 ir  kokybiniai 
C1 bei C2, bei priklausomi kintamieji Y1, Y2, ..., Y30. Sudarykite geriausius  interpretuojamus  0,25,  0,5,   0,75   
daugialypės kvantilių  regresijos modelius, čia N yra varianto numeris.  
Nurodymai  modelių sudarymui:  
1. Modelių kūrimui  naudokite  SAS procedūras  GLMSELECT, REG,  QUANTSELECT, QUANTREG ir kitas 
reikalingas procedūras.   
2. Modelių sudarymui naudokite šiuos kintamuosius (regresorius): X1, X2, ... , X30 (arba jų 
transformacijas, jeigu reikia tiesinti); kokybinius kintamuosius C1, C2,  bei visas jų tarpusavio 
porines sąveikas (sandaugas po du), čia N - varianto numeris.  
3. Modelio sudarymui panaudokite bent du kintamųjų (regresorių) atrankos metodus ir parinkite 
tinkamiausius modelių atrankos metodų parametrus. Bent vienas atrankos metodas turi būti su 
reguliarizacijos metodas:  Lasso (L1),  Elastic net (L1, L2) ir t.t. Palyginkite gautus modelius tarpusavyje 
ir išrinkite geriausią. Pateikite modelių atrankai naudotus modelių kokybės rodiklius : ASE (paklaidų 
kvadratų vidurkis), MSE (vidutinė kvadratinė paklaida), RMSE (vidutinis kvadratinis nuokrypis), RSQ 
(apibrėžtumo koeficientas R2), ADJRSQ (pataisytasis apibrėžtumo koeficientas), R1 , ADR1, AIC, 
AICC, BIC, SBC (Akaikės, Akaikės pataisytasis, Bajeso, Švarco ir Bajeso informaciniai kriterijai), CP 
(Mallows’ Cp ) ir kitus. Atrenkant modelius rekomenduojama panaudoti ir kryžminį patvirtinimą. 
Atrenkant geriausią modelį stenkitės parinkti interpretuojamą ir mažiau parametrų turintį modelį, 
neužmirškite patikrinti ar modelis tenkina prielaidas. Pastaba: geriausias interpretuojamas  
modelis, tenkinantis prielaidas (arba tik su ,,švelniais“ pažeidimais),  turėtų gautis su 4-8 efektais. 
4.  Ataskaitoje būtina pateikti programos kodą, modelio sudarymo etapų pagrindinius rezultatus 
(paaiškinti su kokiomis problemomis susidūrėte ir kaip jas sprendėte, pateikti sudarytų modelių 
palyginimo rezultatus (būtina pateikti AIC, RSQ ir kitų naudotų kriterijų vertes), geriausio atrinkto 
modelio imties  regresijos lygtį, pateikti išvadas apie regresijos modelio prielaidų tenkinimą, 
apibūdinti atrinkto modelio privalumus ir trūkumus, pateikti išvadas apie imties ir populiacijos 
regresijos lygties koeficientus prie visų efektų įrašytų į daugialypės regresijos lygtis, */


libname lab1  "/home/u64062745/sasuser.v94/Daugiamate Statistika/LAB1";
/*
proc import datafile='hb1.sas7bdat'
    out=lab1.hb1
    dbms=sas replace;
run;
*/
data lab1.data;
    set lab1.reg24 (keep=Y9 X1 X2 x3 x4 x5 x6 x7 x8 x9 x10
x11 x12 x13 x14 x15 x16 x17 x18 x19 x20
x21 x22 x23 x24 x25 x26 x27 x28 x29 x30 C1 C2);
run;
/*1. duomenų paruošimas*/
proc contents data=lab1.data; run;
proc means data=lab1.data n nmiss mean std min max; run;
proc freq data=lab1.data; tables C1 C2; run;


/*2. Trečdalį duomenų pasilieka kaip bandymo duomenis, o likusius du trečdalius – kaip treniruočių duomenys */

data lab1.trainingData lab1.testData;
    set lab1.data; /* Pakeiskite 'work.pradiniai_duomenys' į jūsų duomenų rinkinio pavadinimą */
    if ranuni(0) < 2/3 then output lab1.trainingData;
    else output lab1.testData;
run;



/* Koreliacija su Y9 */
proc corr data=lab1.data;
   var x1-x30;
   with Y9;
run;

/*stepwise*/
/*1 modelis*/


proc glmselect data=lab1.trainingData testdata=lab1.testData
plots=(CoefficientPanel asePlot Criteria);
class C1 C2;
model Y9 = c1|c2|x9|x14|x16|x17|x18|x19|x20 @2
/selection = stepwise(select=aic choose=sbc)  stats=all;;
run;


proc glmselect data=lab1.trainingData valdata=lab1.testData
plots=(CoefficientPanel asePlot Criteria);
class C1 C2;
model Y9 = c1|c2|x9|x14|x16|x17|x18|x19|x20 @2
/selection = stepwise(select=aic choose=validate)  stats=all;;
run;

/*2 modelis*/
proc glmselect data=lab1.trainingData testdata=lab1.testData
plots=(CoefficientPanel asePlot Criteria);
class C1 C2;
model Y9 = c1|c2|x9|x14|x16|x17|x18|x19|x20 @2
/selection = stepwise(select=sl choose=press)  stats=all;;
run;

/*forward*/
/*3 modelis*/

proc glmselect data=lab1.trainingData testdata=lab1.testData
plots=(CoefficientPanel(unpack) asePlot Criteria);
class C1 C2;
model Y9 = c1|c2|x9|x14|x16|x17|x18|x19|x20 @2
/selection=forward (select=sbc stop=aic)stats=all;
run;

/*4 modelis*/

proc glmselect data=lab1.trainingData testdata=lab1.testData
plots=(CoefficientPanel(unpack) asePlot Criteria);
class C1 C2;
model Y9 = c1|c2|x9|x14|x16|x17|x18|x19|x20 @2
/selection=forward(select=sl choose=sbc)stats=all;
run;
/*5 modelis*/
proc glmselect data=lab1.trainingData testdata=lab1.testData
plots=(CoefficientPanel(unpack) asePlot Criteria);
class C1 C2;
model Y9 = c1|c2|x9|x14|x16|x17|x18|x19|x20 @2
/selection=forward(select=cv choose=sbc)stats=all;
run;

/*backward*/
/*6 modelis*/

proc glmselect data=lab1.trainingData testdata=lab1.testData
plots=(CoefficientPanel(unpack) asePlot Criteria);
class C1 C2;
model Y9 = c1|c2|x9|x14|x16|x17|x18|x19|x20 @2
/selection=backward(select=sl )stats=all;
run;

/*7 modelis*/

proc glmselect data=lab1.trainingData testdata=lab1.testData
plots=(aseplot coefficientpanel criteria);
class C1 C2;
model Y9 = c1|c2|x9|x14|x16|x17|x18|x19|x20 @2
/selection=elasticnet(choose=sbc stop=none)  stats=all;
run;

/*
selection=backward: tai metodas, kurį naudoji – backward eliminacija.
select=aic: kriterijus, pagal kurį šalinami kintamieji (gali būti sl, aic, sbc, adjrsq, cv, ir pan.)
choose=validate: nurodo, pagal ką pasirinkti galutinį modelį (gali būti aic, sbc, cv, press, ir pan.)

*/
/*8 modelis*/
proc glmselect data=lab1.trainingData testdata=lab1.testData
plots=(aseplot coefficientpanel criteria);
class C1 C2;
model Y9 = c1|c2|x9|x14|x16|x17|x18|x19|x20 @2
/selection=lasso(adaptive stop=none choose=sbc)stats=all;;
run;
/*9 modelis*/
proc glmselect data=lab1.trainingData testdata=lab1.testData
plots=(aseplot coefficientpanel criteria);
class C1 C2;
model Y9 = c1|c2|x9|x14|x16|x17|x18|x19|x20 @2
/selection=lasso(choose=CV stop=none) stats=all;;
run;

/*ntercept c2_1 x18 x19 x19*c1_1*/
proc reg data=lab1.data;
   model Y9 = C2 x18 x19 /stb partial spec vif;
   output out=res r=r;
run;
proc univariate data=res normal;
	var r;
	qqplot/normal(mu=est sigma=est);
	histogram/kernel;
run;


/**Atsparioji regresija*/
ods graphics on;
proc robustreg data=lab1.data plots=(rdplot ddplot histogram qqplot);
model Y9 =x17 x18 x19;
run;
ods graphics off;


data lab1.data_paruosta;
   set lab1.data;
   x9_c2     = x9  * c2;
   x14_c2    = x14 * c2;
   x19_c1    = x19 * c1;
   x9_x19    = x9  * x19;
run;

proc reg data=lab1.data_paruosta;
   model y9 = c2 x9 x9_c2 X14 x14_c2 x17 x18 x19  x19_c1 x9_x19  /stb partial spec vif;
   output out=res r=r;
run;
quit;
proc univariate data=res normal;
	var r;
	qqplot/normal(mu=est sigma=est);
	histogram/kernel;
run;

/*pasaliname nereiksmingus, kur p-reikšmė >0.050*/
 

proc reg data=lab1.data_paruosta;
   model y9 = x9 x9_c2 x17 x18   x19_c1   /stb partial spec vif;
   output out=res r=r;
run;
quit;
proc univariate data=res normal;
	var r;
	qqplot/normal(mu=est sigma=est);
	histogram/kernel;
run;
/*2.2*/
/* Daugialype kvantiliu regresija */
ods graphics on;
Proc QuantSelect data=lab1.data  seed=123
/* Modelio atrankos proceso LASSO koeficientu grafikai */
plots(stepaxis=normb)=coefficients plots=all;
partition fraction(Validate=0.3 );
/*Imties skaidymas į mokymo ir validavimo imtis */
Class C1 C2 /SPLIT ; 
/* kokybinių kintamųjų skaidymas į nepriklausomus dvireikšmius psiaudo kintamuosius */
Model Y9 = c1|c2|x9|x14|x16|x17|x18|x19|x20 @2
/quantile = 0.25 0.5 0.75
selection=LASSO(maxsteps=5 stop=sbc);
/* selection=Stepwise(SLE=0.05 SLS=0.05 maxsteps=5 stop=sbc); */
run;