/*

Title: Family Preservation Analysis Program
Program: s14b_FamilyPres_Analysis_2014_05_06_sb.sas
Programmer: Scott Brown
Created Date: 5/7/2014
Last Updated: 6/17/2014

Input Datasets: 
	s14_fam_pres_impacts_vand_140510_sb
	fpres.s14_fampres_ind_140617_jmr

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



/*INDIVIDUAL OUTCOMES (JMR) */
ODS RTF FILE="E:\Family Options\Output\Exploratory\FamPres Individual Descriptive Stats_140617_jmr.doc";

/*Distribution of validInd variables */
PROC FREQ DATA=fpres.s14_fampres_ind_140617_jmr;
	TITLE "Distribution of validInd variables ";
	* By site_id;
	TABLES 	validInd_any_spoupart_sep*site_id
			validInd_any_child_sep*site_id
			validInd_any_foster*site_id
			validInd_any_spoupart_reunif*site_id
			validInd_any_child_reunif*site_id
			/norow nopercent;
	* By RA_Result;
	TABLES 	validInd_any_spoupart_sep*RA_Result
			validInd_any_child_sep*RA_Result
			validInd_any_foster*RA_Result
			validInd_any_spoupart_reunif*RA_Result
			validInd_any_child_reunif*RA_Result
			/norow nopercent chisq;
RUN;

/*Frequencies of individual-level outcomes */
PROC FREQ DATA=fpres.s14_fampres_ind_140617_jmr;
	TITLE "Frequencies of individual-level outcome";
	TABLES 	f18_any_sep*validInd_any_spoupart_sep
			f18_any_sep*validInd_any_child_sep
			f18_any_foster*validInd_any_foster 
			f18_with*validInd_any_spoupart_reunif 
			f18_with*validInd_any_child_reunif
			/missing norow nopercent;
RUN;

/*Descriptive statistics on spouse/partner separations */
PROC FREQ DATA=fpres.s14_fampres_ind_140617_jmr;
	TITLE "Descriptive statistics on spouse/partner separations";
	*By individual characteristics;
	TABLES 	f18_any_sep*b_sex 
			f18_any_sep*b_felony 
			f18_any_sep*b_work_for_pay 
			f18_any_sep*b_work_disab 
			/norow nopercent chisq;
	*By household characteristics;
	TABLES	f18_any_sep*Gender
			f18_any_sep*Race_cat
			f18_any_sep*RA_Result
			f18_any_sep*site_id
			/norow nopercent chisq;
	WHERE validInd_any_spoupart_sep=1;
RUN;

PROC SORT DATA=fpres.s14_fampres_ind_140617_jmr;
	BY f18_any_sep;
PROC MEANS DATA=fpres.s14_fampres_ind_140617_jmr n mean std;
	TITLE "Descriptive statistics on spouse/partner separations";
	VAR b_age
		f18_d17_weeks
		AgeatRA
		;
	BY f18_any_sep;
	WHERE validInd_any_spoupart_sep=1;
RUN;

/*Descriptive statistics on child separations */
PROC FREQ DATA=fpres.s14_fampres_ind_140617_jmr;
	TITLE "Descriptive statistics on child separations";
	*By individual characteristics;
	TABLES 	f18_any_sep*b_sex 
			f18_any_sep*b_otherpar_present
			f18_any_sep*b_past_separtn
			/nopercent norow chisq;
	*By household characteristis;
	TABLES	f18_any_sep*Gender
			f18_any_sep*Race_cat
			f18_any_sep*RA_Result
			f18_any_sep*site_id
			/norow nopercent chisq;
	WHERE validInd_any_child_sep=1;
RUN;

PROC SORT DATA=fpres.s14_fampres_ind_140617_jmr;
	BY f18_any_sep;
PROC MEANS DATA=fpres.s14_fampres_ind_140617_jmr n mean std;
	TITLE "Descriptive statistics on child separations";
	VAR b_age
		f18_d17_weeks
		AgeatRA
		;
	BY f18_any_sep;
	WHERE validInd_any_child_sep=1;
RUN;

/*Descriptive statistics on foster care placements */
PROC FREQ DATA=fpres.s14_fampres_ind_140617_jmr;
	TITLE "Descriptive statistics on foster care placements";
	*By individual characteristics;
	TABLES 	f18_any_foster*b_sex 
			f18_any_foster*b_otherpar_present
			f18_any_foster*b_past_separtn
			/nopercent norow chisq;
	*By household characteristis;
	TABLES	f18_any_foster*Gender
			f18_any_foster*Race_cat
			f18_any_foster*RA_Result
			f18_any_foster*site_id
			/norow nopercent chisq;
	WHERE validInd_any_foster=1;
RUN;

PROC SORT DATA=fpres.s14_fampres_ind_140617_jmr;
	BY f18_any_foster;
PROC MEANS DATA=fpres.s14_fampres_ind_140617_jmr n mean std;
	TITLE "Descriptive statistics on foster care placements";
	VAR b_age
		f18_d17_weeks
		AgeatRA
		;
	BY f18_any_foster;
	WHERE validInd_any_foster=1;
RUN;

/*Descriptive statistics on spouse/partner reunifications */
PROC FREQ DATA=fpres.s14_fampres_ind_140617_jmr;
	TITLE "Descriptive statistics on spouse/partner reunifications";
	*By individual characteristics;
	TABLES 	f18_with*b_sex 
			f18_with*b_felony 
			f18_with*b_work_for_pay 
			f18_with*b_work_disab 
			/norow nopercent chisq;
	*By household characteristics;
	TABLES	f18_with*Gender
			f18_with*Race_cat
			f18_with*RA_Result
			f18_with*site_id
			/norow nopercent chisq;
	WHERE validInd_any_spoupart_reunif=1;
RUN;

PROC SORT DATA=fpres.s14_fampres_ind_140617_jmr;
	BY f18_with;
PROC MEANS DATA=fpres.s14_fampres_ind_140617_jmr n mean std;
	TITLE "Descriptive statistics on spouse/partner reunifications";
	VAR b_age
		f18_d17_weeks
		AgeatRA
		;
	BY f18_with;
	WHERE validInd_any_spoupart_reunif=1;
RUN;

/*Descriptive statistics on child reunifications */
PROC FREQ DATA=fpres.s14_fampres_ind_140617_jmr;
	TITLE "Descriptive statitics on child reunifications";
	*By individual characteristics;
	TABLES 	f18_with*b_sex 
			f18_with*b_otherpar_present
			f18_with*b_past_separtn
			/nopercent norow chisq;
	*By household characteristis;
	TABLES	f18_with*Gender
			f18_with*Race_cat
			f18_with*RA_Result
			f18_with*site_id
			/norow nopercent chisq;
	WHERE validInd_any_child_reunif=1;
RUN;

PROC SORT DATA=fpres.s14_fampres_ind_140617_jmr;
	BY f18_with;
PROC MEANS DATA=fpres.s14_fampres_ind_140617_jmr n mean std;
	TITLE "Descriptive statitics on child reunifications";
	VAR b_age
		f18_d17_weeks
		AgeatRA
		;
	BY f18_with;
	WHERE validInd_any_child_reunif=1;
RUN;

ODS RTF CLOSE;


