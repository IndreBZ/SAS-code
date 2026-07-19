/*2.3. Užduotis. Prekybos įmonės klientų apklausos matrica HB3B.
Patikrinkite atsitiktinio vektoriaus (X6, X7, ...., X18) struktūrą
pagrindinių komponenčių metodu (principal components).*/
proc factor data=analize_data method=principal;
   var X6-X18;
run;
