/*1.5*/
/*Pagal dviejų nepriklausomų imčių duomenis (imtis X1 pagal kintamąjį X10 padalinama
į dvi imtis) patikrinkite hipotezę apie dviejų populiacijų vidurkių lygybę, alfa=0,1.
Kokį kriterijų naudojote ir kodėl? Koks yra populiacijos vidurkių skirtumas?*/
proc ttest data=analize_data alpha=0.1
 sides =2;    /*  sides={2, U, L}*/
 class x10;
 var x1;
run;

/*1.4*/
/*Empiriniai X1 skirstiniai grupuoti pagal X10 bei branduoliniai (kernel) įverčiai.*/
proc sgplot data=analize_data;
    histogram X1 / group=X10 binwidth=2;
    keylegend / title='Group: X10';
run;

proc sgplot data=analize_data;
    density x1 / type=kernel;
run;

proc sgplot data=analize_data;
    density x2 / type=kernel;
run;
