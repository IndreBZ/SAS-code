/*1 Užduotis*/
/*1.1*/
/*Pagal imties X11 duomenis raskite empirinį skirstinį.*/
proc univariate data=analize_data freq;
   var x11;
   histogram X11 / midpoints=0 to 5 by 1
                     grid
                     barlabel=count
                     normal(color=red);
run;

/*1.2*/
/* Pagal imties X2 duomenis apskaičiuokite skaitines charakteristikas,
raskite empirinį skirstinį ir įvertinkite jo parametrus.
Apskaičiuokite vidurkio, dispersijos, standartinio nuokrypio ir 0,1 0,5 0,75
kvantilių 90% simetrinius dvipusius pasikliovimo intervalus.*/
proc univariate data=analize_data plot cipctldf cibasic alpha=0.1;
    var X2;
    histogram X2 / grid barlabel=count normal(color=red);
    inset n mean std / position=ne;  /* Detalios statistikos */
    qqplot X2 / normal(color=red);
run;
