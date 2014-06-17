/*

Title: Family Preservation Analysis Program
Program: s14b_FamilyPres_Analysis_2014_05_06_sb.sas
Programmer: Scott Brown
Created Date: 5/7/2014
Last Updated: 5/7/2014

Input Datasets: s14_fam_pres_impacts_vand_140510_sb

Output Dataset: 

Purpose: 
*/

libname fpres "E:\Family Options\Data\14_18MonthFamilyPreservationData";
libname fbase "E:\Family Options\Data\01_BaselineData";
libname fam18m "E:\Family Options\Data\02_18MonthData";

OPTIONS FMTSEARCH=(fbase) NOFMTERR;


*FREQUENCIES -- All persons;

PROC CONTENTS DATA=fpres.S14_FAM_PRESERVATION_VAND_140504; RUN;
*Frequencies;

ODS RTF FILE="E:\Family Options\Output\Exploratory\Family Preservation Person Level Freqs_2014_05_07_sb.doc";
/*PROC FREQ DATA=fpres.S14_FAM_PRESERVATION_VAND_140504; 
	TITLE "With or not with family at 18 months by child status at baseline (using interim child definition)";
	WHERE b_relat in(1,2,3,4,14) ;
	TABLES f18_b1a*b_child /norow nopercent;
RUN;*/
PROC FREQ DATA=fpres.S14_FAM_PRESERVATION_VAND_140504; 
	TITLE "With or not with family at baseline versus follow-up, by child status";
	WHERE b_relat in(1,2,3,4,14) ;
	TABLES b_present*f18_b1a*b_child /norow nopercent ;
RUN;
/*PROC FREQ DATA=fpres.S14_FAM_PRESERVATION_VAND_140504; 
	TITLE "All raw frequencies";
	TABLES b: f18: ;
RUN;*/
PROC FREQ DATA=fpres.S14_FAM_PRESERVATION_VAND_140504; 
	TITLE "All raw frequencies: spouse/partner and interim child def only";
	WHERE b_relat in(1,2,3,4,14);
	TABLES b: f18: ;
RUN;
PROC FREQ DATA=fpres.S14_FAM_PRESERVATION_VAND_140504; 
	TITLE "Baseline composition freqs by child status";
	WHERE b_relat in(1,2,3,4,14);
	TABLES B:*b_child /norow nopercent ;
RUN;
PROC FREQ DATA=fpres.S14_FAM_PRESERVATION_VAND_140504; 
	TITLE "Follow-up freqs by child status";
	WHERE b_relat in(1,2,3,4,14);
	TABLES f18:*b_child /norow nopercent ;
RUN;



PROC FREQ DATA=fpres.S14_FAMPRES_temp; 
	TITLE "Outcome measures, person-level, spouse/partner";
	WHERE b_relat in(1,2) ;
	TABLES f18_b1a f18_notwith f18_with f18_seplast6 
		) /missing norow nopercent ;
RUN;
PROC FREQ DATA=fpres.S14_FAMPRES_temp; 
	TITLE "Outcome measures, person-level, child";
	WHERE b_relat in(1,2,3,4,14) ;
	TABLES b_child*(f18_b1a f18_notwith f18_with f18_seplast6 f18_foster_nw f18_foster_last6
		) /missing norow nopercent ;
RUN;



*Univariate stats on time variables;
PROC UNIVARIATE DATA=fpres.S14_FAMPRES_temp;
	TITLE "Person level stats on time variables: Time since last part of household (D5)";
	VAR f18_d5_months;
RUN;
PROC UNIVARIATE DATA=fpres.S14_FAMPRES_temp;
	TITLE "Person level stats on time variables: Total amount of time child has spent apart (D8a)";
	VAR f18_d8a_months;
RUN;
PROC UNIVARIATE DATA=fpres.S14_FAMPRES_temp;
	TITLE "Person level stats on time variables: Time in foster care (currently separated) (D6_C)";
	VAR f18_d6c_months;
RUN;
PROC UNIVARIATE DATA=fpres.S14_FAMPRES_temp;
	TITLE "Person level stats on time variables: Time in foster care in past 6 months (D18_C)";
	VAR f18_d18c_months;
RUN;
PROC UNIVARIATE DATA=fpres.S14_FAMPRES_temp;
	WHERE f18_foster_past6_months;
	TITLE "Person level stats on time variables: Total time in foster care in past 6 months (with 6 month ceiling)";
	VAR f18_foster_past6_months;
RUN;
PROC UNIVARIATE DATA=fpres.S14_FAMPRES_temp;
	WHERE f18_foster_past6_months>0;
	TITLE "Person level stats on time variables: Total time in foster care in past 6 months (of those with any placement)";
	VAR f18_foster_past6_months;
RUN;

ODS RTF CLOSE;




*FREQUENCIES: Family roll-up;
ODS RTF FILE="E:\Family Options\Output\Exploratory\Family Preservation Family Level Freqs_2014_05_07_sb.doc";
PROC FREQ DATA=fpres.s14_fam_pres_impacts_140506_sb;
	TITLE "Family level outcomes and freqs";
	TABLES outcome: age_oldest_childwith 
		tot_sep_spoupart_nw tot_sep_spoupart_last6
		tot_sep_child_nw tot_sep_child_last6 tot_foster_nw tot_foster_last6
		tot_reunif_spoupart tot_reunif_child N_:;
RUN;


ODS RTF CLOSE;
