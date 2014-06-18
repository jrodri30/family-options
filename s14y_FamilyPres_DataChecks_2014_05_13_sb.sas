/*

Title: Family Preservation Data Checks Program
Program: s14y_FamilyPres_DataChecks_2014_05_13_sb.sas
Programmer: Scott Brown
Created Date: 5/7/2014
Last Updated: 5/7/2014

Input Datasets: fpres.s14_fampres_temp
				fpres.s14_fam_pres_impacts_vand_140510_sb
				fam18m.s02_18mo_vand_140211_scr
				fabase.s01_base_vand_140117

Output Dataset: 

Purpose: 
*/


libname fbase "E:\Family Options\Data\01_BaselineData";
libname fam18m "E:\Family Options\Data\02_18MonthData";
libname fpres "E:\Family Options\Data\14_18MonthFamilyPreservationData";

OPTIONS NOFMTERR;




/*    MISSING FAMILIES AND PERSONS ANALYSIS			*/

*#1: Q: How many total families are in the preservation file?
	 MISSING: 7 families of the 1877 completed 18 month surveys missing;
PROC MEANS DATA=fpres.s14_fam_preservation_vand_140504 NOPRINT MISSING;
	BY id_fam_vand;
	OUTPUT OUT=temp1 N(id_fam_vand)=tot_people;
RUN;

	*Identify family IDs of families missing from family preservation file;
	PROC SQL;
		SELECT A.id_fam_vand, B.tot_people
		FROM fam18m.s02_18mo_vand_140211_scr (KEEP= id_fam_vand) A LEFT JOIN temp1 B ON A.id_fam_vand=B.id_fam_vand
		HAVING B.tot_people=.;
	QUIT;

*#2: Q: Did any not have at least one member of household listed as spouse/partner/child or grandchild
	 MISSING: 8 families had children present listed under alternate coding;
PROC MEANS DATA=fpres.s14_fam_preservation_vand_140504 NOPRINT MISSING;
	WHERE b_relat in(1,2,3,4,14);
	BY id_fam_vand;
	OUTPUT OUT=temp1a N(id_pers_num_vand)=tot_people ;
RUN;

PROC SQL;
	SELECT A.id_fam_vand, B.tot_people
	FROM fpres.s14_fam_preservation_vand_140504 A 
		LEFT JOIN temp1a B ON A.id_fam_vand=B.id_fam_vand
	HAVING B.tot_people=.;
QUIT;

PROC PRINT DATA=fpres.s14_fampres_temp; 
	WHERE id_fam_vand in(2173, 2771, 2862, 2877, 2984, 3087, 3257, 3259);
	VAR id_fam_vand b_relat b_present b_age b_child f18_b1a;
RUN;


*#3: Q: Some families have members that they reported as DK/REF in response to B1a (is the family member with you now)
	 or did not answer the question. Do these missings result in any families being excluded entirely from the analysis?
	MISSING: 1 family missing info at follow-up for all children with them at baseline
			4 families missing all info for children not with them at baseline
			2 families missing all info for spouse/partner with them at baseline
			3 families missing info for spouse/partner not with them at baseline;
PROC PRINT DATA=fpres.s14_fam_preservation_vand_140504;
	WHERE f18_b1a not in(1,2);
RUN;
PROC PRINT DATA=fpres.s14_fampres_temp;
	WHERE id_fam_vand in(1015, 1052, 1254,1303,1461,1505,1939,1984,2025,
		2066, 2281, 2549, 2717, 2788, 2928, 3018, 3243);
	VAR id_fam_vand b_relat b_present b_age b_child f18_b1a;
RUN;




*#4: Q: After filtering for valid relationship statuses, do we lose any additional families on the child front
		because they did not have children within the correct age range?
	MISSING: ;
	*Missing age;
PROC FREQ DATA=fpres.s14_fampres_temp;	TABLES b_age b_relat; RUN;
PROC FREQ DATA=fpres.s14_fampres_temp;	WHERE b_relat in(1,2,3,4,14);	TABLES b_age; RUN;
PROC PRINT DATA=fpres.s14_fampres_temp; WHERE b_relat in(1,2,3,4,14) AND b_age=.; RUN; *ID 1572;
PROC PRINT DATA=fpres.s14_fampres_temp; WHERE b_relat in(1,2,3,4,14) AND id_fam_vand=1572; RUN; *ID 1572;


/*CREATE A NEW FAMILY ID BASE WITH THESE PEOPLE EXCLUDED
	-loss of 86 people, n=5082*/
DATA s14_fampres_temp2;
	SET fpres.s14_fampres_temp;
	IF b_relat in(1,2,3,4,14) and f18_b1a in(1,2) and b_age~=.;
RUN;
PROC MEANS DATA=s14_fampres_temp2 SUM NOPRINT MISSING;
	BY id_fam_vand;
	OUTPUT OUT=temp1z N(id_fam_vand)=tot_people SUM(b_child)=tot_child SUM(b_present)=tot_present SUM(f18_seplast6)=Totchx;
RUN;
PROC PRINT DATA=temp1z (obs=200);RUN;
PROC PRINT DATA=s14_fampres_temp2; WHERE id_fam_vand<=1256; var id_fam_vand b_present f18_with f18_seplast6; RUN;
	*Did not have children with family in valid age range;
		*No missings on b_present, b_child, id_fam_vand -- confirmed;
PROC FREQ DATA=fpres.s14_fampres_temp;	WHERE b_relat in(3,4,14);	TABLES   b_present b_child b_age; RUN;
		*Base of families that had children at baseline;
		PROC MEANS DATA=fpres.s14_fampres_temp SUM NOPRINT MISSING;
			WHERE b_relat in (3,4,14);
			BY id_fam_vand;
			OUTPUT OUT=temp2a N(id_fam_vand)=tot_child ;
		RUN;
		*Missing any children with relationship status of 3/4/14;
		PROC SQL;
			SELECT A.id_fam_vand, B.tot_child
			FROM temp1z A LEFT JOIN temp2a B ON A.id_fam_vand=B.id_fam_vand
			HAVING tot_child=.;
		QUIT;
		*Printout of families lost at this stage;
		PROC PRINT DATA=s14_fampres_temp2; WHERE id_fam_vand in(1432,1912,2757,2995,3129,3174); RUN;
		PROC PRINT DATA=fpres.s14_fampres_temp; WHERE id_fam_vand in(1432,1912,2757,2995,3129,3174); RUN;


		*Base of families that had children with them at baseline;
		PROC MEANS DATA=fpres.s14_fampres_temp SUM NOPRINT;
			WHERE b_relat in (3,4,14) and b_present=1;
			BY id_fam_vand;
			OUTPUT OUT=temp2b SUM(b_child)=tot_child_with;
		RUN;
		PROC SQL;
			SELECT A.id_fam_vand, B.tot_child_with
			FROM temp2a A LEFT JOIN temp2b B ON A.id_fam_vand=B.id_fam_vand
			HAVING tot_child_with=.;
		QUIT;
		PROC PRINT DATA=fpres.s14_fampres_temp; WHERE id_fam_vand in(1691,2865); RUN;

		*Base of families that had children age 0-17 present with them at baseline;
		PROC MEANS DATA=fpres.s14_fampres_temp SUM NOPRINT;
			WHERE b_relat in (3,4,14) and b_present=1 and b_age in(0:16);
			BY id_fam_vand;
			OUTPUT OUT=temp2c N(id_fam_vand)=n_child SUM(b_child)=tot_child_with2;
		RUN;
			*One less child, no change in family N;

		*Identify the 5 remaining missing families on the child separations analysis;
DATA s14_impacts_childsep_fam;
	SET fpres.s14_fam_pres_impacts_140506_sb;
	IF outcome_any_child_sep=.;
RUN;

PROC FREQ DATA=fpres.s14_fam_pres_impacts_140506_sb; TABLES outcome_any_child_sep; RUN;

PROC SQL;
	CREATE TABLE temp1v AS 
	SELECT A.id_fam_vand, B.tot_child_with2
	FROM s14_impacts_childsep_fam A LEFT JOIN temp2c B ON A.id_fam_vand=B.id_fam_vand;

	CREATE TABLE temp1w AS
	SELECT A.id_fam_vand, A.tot_child_with2, B.*
	FROM temp1v A LEFT JOIN fpres.s14_fampres_temp B ON A.id_fam_vand=B.id_fam_vand;
QUIT;

PROC PRINT DATA=temp1w; WHERE id_fam_vand NOT in(1172,2310,2554,2798,2882,2960,2981,2173,2771,2862,2877,2984,3087,3257,3259, 1432,1912,2757,
		2995,3129,3174,1691,2865, 1318, 1939,2100,2179,2575);
	VAR id_fam_vand b_spoupart b_child_FOdef b_relat b_present b_age f18_b1a f18_d16;
RUN;





	*5 additional missing families;
PROC PRINT DATA=s14_fampres_temp2; WHERE id_fam_vand in(1318,1939,2100, 2179,2575); RUN;
	*Check for DK/REF or other missings on f18_d16 when child with household;
PROC FREQ DATA=s14_fampres_temp2; WHERE f18_with=1 and b_relat in(3,4,14);
	TABLES f18_d16;
RUN;
	*Check for children with household being asked questions for those not with the household;
PROC FREQ DATA=s14_fampres_temp2; WHERE f18_with=1 and b_relat in(3,4,14);
	TABLES f18_d6a f18_d6b;
RUN;


	*Check for DK/REF or other missings on f18_d16 when spouse/partner with household;
PROC FREQ DATA=s14_fampres_temp2; WHERE f18_with=1 and b_relat in(1,2);
	TABLES f18_d16;
RUN;
	*Check for spouse/partner with household being asked questions for those not with the household;
PROC FREQ DATA=s14_fampres_temp2; WHERE f18_with=1 and b_relat in(1,2);
	TABLES f18_d6a f18_d6b;
RUN;



/*PART B: Missing families from spouse/partner analyses*/
	*1. Identify number of families with no spouse/partner reported at baseline;
PROC MEANS DATA=fpres.s14_fampres_temp NOPRINT;
	BY id_fam_vand;
	OUTPUT OUT=tempb1 N(id_fam_vand)=tot_hh_memb SUM(b_spoupart)=tot_spoupart;
RUN;
PROC FREQ DATA=tempb1; TABLES tot_spoupart; RUN;
		*What are the IDs of the 6 families have 2 spouses/partners
			A: 1015, 1333,1592,1666,1702,1811;
PROC PRINT DATA=tempb1; WHERE tot_spoupart>1; RUN;
		*Exploring families with more than one spouse/partner;
PROC PRINT DATA=fpres.s14_fampres_temp; WHERE id_fam_vand in(1015,1333,1592,1666,1702,1811);
	VAR id_fam_vand b_spoupart b_relat b_present b_age f18_b1a;
RUN;
	
	*Families that do have a spouse or partner--classify by present/absent;
PROC MEANS DATA=fpres.s14_fampres_temp NOPRINT;
	WHERE b_spoupart=1;
	BY id_fam_vand;
	OUTPUT OUT=tempb2 N(id_fam_vand)=tot_spoupart SUM(b_present)=tot_present MEAN(b_present)=m_present;
RUN;
PROC FREQ DATA=tempb2; TABLES tot_present; RUN;

	*SEPARATIONS: Only 2 families remaining with missing spouse/partners after subtract out non-missings and those we 
		deliberately exclude from the base (no spouse or partner OR only a spouse/partner not with them at baseline)
	These remaining 2 are those who were spouse or partners with family at baseline but missing on b1a at follow-up;
	PROC PRINT DATA=fpres.s14_fampres_temp; WHERE b_present=1 AND b_spoupart=1 AND f18_b1a not in(1,2);
		VAR id_fam_vand b_spoupart b_relat b_present b_age f18_b1a;
	RUN;

	*REUNIFICATIONS: Only 3 families remaining with missing spouse/partners after subtract out non-missings and those we 
		deliberately exclude from the base (no spouse or partner OR only a spouse/partner with them at baseline)
	These remaining 3 are those who were spouse or partners with family at baseline but missing on b1a at follow-up;
	PROC PRINT DATA=fpres.s14_fampres_temp; WHERE b_present=0 AND b_spoupart=1 AND f18_b1a not in(1,2);
		VAR id_fam_vand b_spoupart b_relat b_present b_age f18_b1a;
	RUN;

/* fpres.s14_fampres_temp  s14_fampres_temp2*/



/*PART C: Missing families from child reunification analyses*/
	*1. Identify number of families with no children absent at baseline;
PROC MEANS DATA=fpres.s14_fampres_temp NOPRINT;
	BY id_fam_vand;
	OUTPUT OUT=tempc1 N(id_fam_vand)=tot_hh_memb SUM(b_child_FOdef)=tot_child_FOdef;
RUN;
PROC FREQ DATA=tempc1; TABLES tot_child_FOdef; RUN;

	
	*Families that do have a child absent;
PROC MEANS DATA=fpres.s14_fampres_temp NOPRINT;
	WHERE b_child_FOdef=1;
	BY id_fam_vand;
	OUTPUT OUT=tempc2 N(id_fam_vand)=tot_child SUM(b_present)=tot_child_present MEAN(b_present)=m_present;
RUN;

DATA tempc3;
	SET tempc2;
	tot_child_np=tot_child-tot_child_present;
RUN;
PROC FREQ DATA=tempc3; TABLES tot_child_np /missing; RUN;

	*Identify the 11 families haven't classified reason for missingness;
PROC SQL;
	CREATE TABLE tempc4 AS
	SELECT A.id_fam_vand, A.outcome_any_child_reunif, B.tot_child_np
	FROM fpres.s14_fam_pres_impacts_140506_sb A LEFT JOIN tempc3 B ON A.id_fam_vand=B.id_fam_vand
	HAVING A.outcome_any_child_reunif=. AND (B.tot_child_np>0 OR B.tot_child_np=.);

	CREATE TABLE tempc5 AS
	SELECT A.id_fam_vand, A.tot_child_np, B.*
	FROM tempc4 A LEFT JOIN fpres.s14_fampres_temp B ON A.id_fam_vand=B.id_fam_vand;
QUIT;


PROC PRINT DATA=tempc5; WHERE id_fam_vand NOT in(1172,2310,2554,2798,2882,2960,2981);
	VAR id_fam_vand b_spoupart b_child_FOdef b_relat b_present b_age f18_b1a f18_d16;
RUN;


*PART D: Find  missing foster children families;
DATA s14_impacts_foster_fam;
	SET fpres.s14_fam_pres_impacts_140506_sb;
	IF outcome_any_foster=.;
RUN;

PROC SQL;
	CREATE TABLE tempd1 AS
	SELECT A.id_fam_vand, A.outcome_any_child_sep, B.*
	FROM s14_impacts_foster_fam A LEFT JOIN fpres.s14_fampres_temp B 
	ON A.id_fam_vand=B.id_fam_vand;
QUIT;

PROC PRINT DATA=tempd1; VAR id_fam_vand b_spoupart b_child_FOdef b_relat b_present b_age f18_b1a f18_d6a f18_d6b f18_d16 f18_d18a f18_d18b; RUN;
PROC PRINT DATA=tempd1; WHERE id_fam_vand NOT IN(2173,2771,2862,2877,2984,3087,3257, 3259, 1432, 1912, 2757, 2995,3129,3174,1939, 1172,2310,2554,2798,2882,2960,2981);
VAR id_fam_vand b_spoupart b_child_FOdef b_relat b_present b_age f18_b1a f18_d6a f18_d6b f18_d16 f18_d18a f18_d18b; RUN;



/*Exploratory: What were the characteristics of the seven families left out of pres file
	-refused family composition questions at baseline BUT answered follow-up questions*/
PROC PRINT DATA=fbase.s01_base_vand_140117; WHERE id_fam_vand in(1172,2310,2554,2798,2882,2960, 2981);
	VAR id_fam_vand E1 E2 E4 E5 E6 E6A;
RUN;
PROC PRINT DATA=fam18m.s02_18mo_vand_140211_scr; WHERE id_fam_vand in(1172,2310,2554,2798,2882,2960, 2981);
	VAR id_fam_vand D:;
RUN;

*Child of lover/partner;
PROC PRINT DATA=fpres.s14_fampres_temp; WHERE id_fam_vand in(1432, 3174);RUN;
PROC PRINT DATA=fpres.s14_fampres_temp; WHERE b_relat=6;RUN;
	*families not dropped from analysis but had child of lover/partner;
PROC PRINT DATA=fpres.s14_fampres_temp; WHERE id_fam_vand in(1132, 1901, 2223,2364,3042,3075);
	VAR id_fam_vand b_spoupart b_child_FOdef b_relat b_present b_age f18_b1a;RUN;

*Check from screener questions -- were all children sep from family?, YES;
PROC PRINT DATA=fpres.s14_fampres_temp; WHERE id_fam_vand=1008;
	VAR id_fam_vand b_spoupart b_child_FOdef b_relat b_present b_age f18_b1a;RUN;
RUN;

*Other location responses;
PROC FREQ DATA=fpres.s14_fampres_temp; where b_relat in(3,4,14) and b_age in(0:16);
	TABLES f18_d6b f18_d18b;RUN;
RUN;

*foster child recode;
PROC PRINT DATA=fpres.s14_fampres_temp; WHERE id_pers_num_vand=2218401;
	VAR id_fam_vand b_spoupart b_child_FOdef b_relat b_present b_age f18_b1a;RUN;
RUN;

*checking potentially missing foster child outcome families;
PROC PRINT DATA=fpres.s14_fampres_temp; WHERE id_fam_vand in(1254, 1303, 1461, 1505);
	VAR id_fam_vand b_spoupart b_child_FOdef b_relat b_present b_age f18_b1a f18_d6b f18_d16 f18_d18b;RUN;
RUN;

PROC PRINT DATA=fpres.s14_fam_pres_impacts_140506_sb; WHERE outcome_any_foster=.;
	VAR id_fam_vand;
RUN;

PROC PRINT DATA=fpres.s14_fampres_temp; WHERE id_fam_vand=1939;
	VAR id_fam_vand b_spoupart b_child_FOdef b_relat b_present b_age f18_b1a f18_d6b f18_d16 f18_d18b;RUN;
RUN;


PROC CORR DATA=fpres.s14_fam_pres_impacts_140506_sb; 
	VAR age_oldest_childwith ageatRA;
RUN;
