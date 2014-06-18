/*
Exploring new datasets from Abt Associates
3/7/2014

Running proc contents and frequencies on some key variables to understand the datasets

*/


/*HOME observational data*/
PROC CONTENTS data=SASUSER.s06_18mo_home_vand_140227; run;
PROC PRINT data=SASUSER.s06_18mo_home_vand_140227 (obs=5); run;

/*htks*/
PROC CONTENTS data=SASUSER.s04_18mo_htks_vand_140227; run;
PROC PRINT data=SASUSER.s04_18mo_htks_vand_140227 (obs=5); run;
PROC FREQ data=SASUSER.s04_18mo_htks_vand_140227;
	TABLES age_years_recalc finished_test TT1_ZERO_SCORE HTKS_total_score tt_1_I;
RUN;
PROC FREQ data=SASUSER.s04_18mo_htks_vand_140227;
	TABLES finished_test REFUSE_ATTEMPT REFUSE_BEGIN REFUSE_CONTINUE REFUSE_REASON DEMO_INTERRUPTED DEMO_K_S_INTERRUPT
;
RUN;

/*ages and stages*/
PROC CONTENTS data=SASUSER.s05_18mo_ages_vand_140227; run;
PROC PRINT data=SASUSER.s05_18mo_ages_vand_140227 (obs=5); run;
PROC FREQ data=SASUSER.s05_18mo_ages_vand_140227;
	TABLES ASQ3_VERSION AGES_totalscore_COMM AGES_totalscore_FINE AGES_totalscore_GROS AGES_totalscore_PERS AGES_totalscore_PROB
		ChronologicalAge_MONTHS_recalc ChronologicalAge_YEARS_recalc PARENTAL_REFUSAL PARENTAL_STOPPED_DESC PARENTAL_STOPPED_ITEM 
;
RUN;
