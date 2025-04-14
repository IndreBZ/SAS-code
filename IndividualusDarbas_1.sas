libname analize  "/home/u64062745/sasuser.v94/Daugiamate Statistika";

proc import datafile='id1.sas7bdat'
    out=analize.id1
    dbms=sas replace;
run;

data analize.data;
    set analize.id1;
    if _N_ >= 18 and _N_ <= 57 then delete;  /* Čia triname  eilutes nuo 18 iki 57 */
run;

/*1 Užduotis*/
/*1.1*/
/*Pagal imties X11 duomenis raskite empirinį skirstinį.*/

proc univariate data=analize.data freq;
   var x11;
   histogram X11 / midpoints=0 to 5 by 1
                     grid
                     barlabel=count
                     normal(color=red);
run;



/*1.2*/
 /* Pagal imties X2 duomenis apskaičiuokite skaitines charakteristikas, 
 raskite empirinį skirstinį ir įvertinkite jo parametrus. 
 Nubraižykite histogramą, stačiakampę diagramą ir Q-Q grafiką.
 Apskaičiuokite vidurkio, dispersijos, standartinio nuokrypio ir 0,1 0,5 0,75 kvantilių 90% simetrinius dvipusius pasikliovimo intervalus.*/



proc univariate data=analize.data plot cipctldf cibasic alpha=0.1;
    var X2;
    histogram X2 / grid barlabel=count normal(color=red);
    inset n mean std / position=ne;  /* Detalios statistikos */
     /* cibasic (type=TWOSIDED alpha=0.1) ;  *//* Populiacijos vidurkio ir standartinio nuokrypio pasikliautinieji intervalai */
    qqplot X2 / normal(color=read); /* Brėžiame X2 Q-Q grafiką, lygindami empirinius X2 kvantilius su teoriniais normaliojo 
                                           pasiskirstymo kvantiliais. mu=est ir sigma=est reiškia, kad teorinio normaliojo pasiskirstymo 
                                           vidurkis ir standartinis nuokrypis imami lygūs X2 imties vidurkiui ir stand. nuokrypiui */
run;

/*Stačiakampė diagrama (boxplot) kintamajam X2 */
proc sgplot data=analize.data;          /* Pradedame SGPLOT procedūrą su nurodytu duomenų rinkiniu (pakeiskite 'duomenys' savo duomenų rinkiniu) */
   vbox X2;                         /* Brėžiame stačiakampę (dėžutės) diagramą kintamajam X2. 
                                       Diagrama rodo medianą (vidinę liniją), 1-ą ir 3-ą kvartilius (dėžutės kraštus), 
                                       „ūsus“ (1.5 IQR atstumu) ir galimas išskirtis*/
   title "X2 stačiakampė diagrama (Boxplot)";  /* Suteikiame diagramai pavadinimą "X2 stačiakampė diagrama" */
run;  
              
/*1.3*/
/*Pagal imties X4 duomenis patikrinkite suderinamumą su normaliuoju skirstiniu. 
Nubraižykite histogramą, stačiakampę diagramą ir Q-Q grafiką, 
apskaičiuokite 0,1 0,5 0,75 kvantilių taškinius įverčius ir 90% vienpusius 
(su viršutiniu rėžiu(UPERR)) pasikliovimo intervalus.*/
proc univariate data=analize.data plot cipctldf(type=UPPER) /* cibasic(type=UPPER) */alpha=0.1 normal;
    var X4;
    histogram X4 / grid barlabel=count normal(color=read);
    inset n mean std / position=ne;  /* Detalios statistikos */
     /* cibasic (type=TWOSIDED alpha=0.1) ;  *//* Populiacijos vidurkio ir standartinio nuokrypio pasikliautinieji intervalai */
    qqplot X4 / normal(color=read);  /* Brėžiame X2 Q-Q grafiką, lygindami empirinius X2 kvantilius su teoriniais normaliojo 
                                           pasiskirstymo kvantiliais. mu=est ir sigma=est reiškia, kad teorinio normaliojo pasiskirstymo 
                                           vidurkis ir standartinis nuokrypis imami lygūs X2 imties vidurkiui ir stand. nuokrypiui */
                                    
run;

proc sgplot data=analize.data;          /* Pradedame SGPLOT procedūrą su nurodytu duomenų rinkiniu (pakeiskite 'duomenys' savo duomenų rinkiniu) */
   vbox X4;                         /* Brėžiame stačiakampę (dėžutės) diagramą kintamajam X2. 
                                       Diagrama rodo medianą (vidinę liniją), 1-ą ir 3-ą kvartilius (dėžutės kraštus), 
                                       „ūsus“ (1.5 IQR atstumu) ir galimas išskirtis*/
   title "X4 stačiakampė diagrama (Boxplot)";  /* Suteikiame diagramai pavadinimą "X2 stačiakampė diagrama" */
run; 

/*1.4*/
/*Sukurkite SAS grafikos šabloną (SAS Graph Template), 
kuris vaizduotų X1 ir X2 empirinius skirstinius bei X1 ir X2 empirinius skirstinius 
grupuotus pagal X10 vienoje panelėje (pateikite histogramas, branduolinius įvertinius, stačiakampes diagramas ir t.t.)*/

proc template;
    define statgraph complexgraph;
        begingraph;
        layout lattice / rows=2 columns=4;  /* Sukuria 2x4 išdėstymo tinklelį grafikams */
            /* Histograma X1 */
            layout overlay;
                histogram X1/ binwidth=2;
                title "X1 ir X2 skirstiniai ir pasiskirstymas pagal X10";
            endlayout;
            /* Boxplot X1 */
            layout overlay;
             histogram X1 / group=X10 binwidth=2 ;
             keylegend / location=inside position=topright across=1 title='Group: X10';
            endlayout;
            layout overlay;
               boxplot x=X10 y=X1;
            endlayout;
            layout overlay;
               boxplot y=X1;
            endlayout;
            layout overlay;
                histogram X2/ binwidth=2;
            endlayout;
            /* Boxplot X1 */
            layout overlay;
               histogram X2 / group=X10 binwidth=2 ;
            endlayout;
            layout overlay;
               boxplot x=X10 y=X2;
            endlayout;
            layout overlay;
               boxplot y=X2;
            endlayout;

        endlayout;
        endgraph;
    end;
run;

           
proc sgrender data=analize.data template=complexgraph;
run;


proc sgplot data=analize.data;
    histogram X1 / group=X10 binwidth=2;
    keylegend / title='Group: X10';
run;


proc sgplot data=analize.data;
    density x1 / type=kernel;
run;


proc sgplot data=analize.data;
    density x2 / type=kernel;
run;

/*1.5*/
/*Pagal dviejų nepriklausomų imčių duomenis ( imtis X1 pagal kintamąjį pagal X10 padalinama į dvi imtis) 
patikrinkite hipotezę apie dviejų populiacijų vidurkių lygybę, α=0,1 . 
Parašykite išvadas apie imtį ir populiaciją. Kokį kriterijų naudojote ir kodėl ? 
Koks yra populiacijos vidurkių skirtumas?*/
proc ttest data=analize.data alpha=0.1
              /*  Hipotezes apie du vidurkius tikrinimas (nepriklausomos imtys)*/
 sides =2;    /*  sides={2, U, L}*/          
 class x10;             
 var x1;

run;
