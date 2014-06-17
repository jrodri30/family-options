/*

Title: Family Preservation Impact Estimation Preparation
Program: s14a_FamilyPres_ImpactPrep_2014_06_02_sb.sas
Programmer: Scott Brown
Created Date: 5/6/2014
Last Updated: 6/17/2014

Input Datasets: 
	fpres.s14_fam_preservation_vand_140504.sas7bdat (NOTE: Sent by Danny Gubits on 5/5/2014)
	fbase.s01_base_vand_140117.sas7bdat
	fam18m.s02_18mo_vand_140211
	fdrop.s16_hfbase_flag_25ineligible_fam

Key Output Dataset: s14_fam_pres_impacts_vand_140510_sb

Intermediate Datasets: 
	s14_fampres_temp (individual level, with analysis variables)
	fpres.s14_fampres_ind_140617_jmr (s14_fampres_temp, merged with household outcomes)

Purpose: Prepare family-level data file for family preservation impact estimates
1) Do initial programming to create analysis variables
2) Calculate total partner/spouse and child separations + reunifications + placements in foster care
3) Merge calculations with select adult survey baseline data to get covariates
4) Calculate dummy variables for outcome variables (e.g., number of child separations -> any child separations)
5) Merge household outcomes dataset with individual-level dataset

*/

*Jason's folder;
libname jason "E:\Family Options\Jason";

*Baseline Data Source;
libname fbase "E:\Family Options\Data\01_BaselineData";

*18 month adult survey source;
libname fam18m "E:\Family Options\Data\02_18MonthData";

*Family preservation data file source;
libname fpres "E:\Family Options\Data\14_18MonthFamilyPreservationData";

*List of 25 ineligble families source;
libname fdrop "E:\Family Options\Data\01_BaselineData";

OPTIONS NOFMTERR;



/*Step 1: Read in individual-level data, create analysis variables*/

*First, drop the 25 families who were ineligible at baseline;
PROC SQL;
	CREATE TABLE s14_fampres_no25inelig AS
	SELECT A.*
	FROM fpres.s14_fam_preservation_vand_140504 A LEFT JOIN
		fdrop.s16_hfbase_flag_25ineligible_fam B ON A.id_fam_vand=b.id_fam_vand
	HAVING B.fam_ineligible=0;
QUIT;

*Now create individual analysis measures and include recoding based on "other" open ends;
DATA fpres.s14_fampres_temp;
	SET s14_fampres_no25inelig;

	
	/*A. Recoding for D6B and D18B from the "other" (=95) open ends sent by Danny Gubits
			on 5/21/2014 (filename=S14_family_preservation_file_nopii_vand_5-21-14.lst) 
		 to account for foster placements noted in the open-ends.  

		May later recode in cases where the "other" response fits with existing categories in 
		D6B / D18B																			*/

		*Recodes for D6B (f18_d6b_rc) and D18B (f18_d18b_rc);
		SELECT (id_pers_num_vand);
			WHEN (1226201) f18_d6b_rc=6; /*group home*/
			WHEN (1497402) f18_d6b_rc=6; /*group home*/
			WHEN (1738202) f18_d6b_rc=6; /*St. Joe's Children's home, child protective care*/
			WHEN (2148402) f18_d6b_rc=6; /*group home in California*/
			WHEN (2513201) f18_d6b_rc=6; /*DYS (department of youth services)*/

			WHEN (2218401) f18_d18b_rc=6; /*Texas Child Protective Services*/
		OTHERWISE DO; f18_d6b_rc=f18_d6b; f18_d18b_rc=f18_d18b; END;
		END;

	/*B. Create dummy variables for counting outcome measures and analysis & filtering purposes*/
	*with or not with family at 18 months;
	IF f18_b1a=2 THEN f18_notwith=1; ELSE IF f18_b1a=1 THEN f18_notwith=0;
	IF f18_b1a=1 THEN f18_with=1; ELSE IF f18_b1a=2 THEN f18_with=0;

	*with family but separated within the last 6 months;
	IF f18_d16=2 THEN f18_seplast6=0; ELSE IF f18_d16=1 THEN f18_seplast6=1;

	*Any separation (JMR);
	IF f18_notwith=1 OR f18_seplast6=1 THEN f18_any_sep=1;
		ELSE if f18_notwith=0 AND f18_seplast6=0 THEN f18_any_sep=0;

	*foster care placements: now and within last 6 months (JMR);
	IF b_age in(0:15) THEN DO;
		IF f18_d6b_rc in(2,4,6) THEN f18_foster_nw=1; ELSE IF f18_notwith=1 THEN f18_foster_nw=0;
		IF f18_d18b_rc in(2,4,6) THEN f18_foster_last6=1; ELSE IF f18_with=1 THEN f18_foster_last6=0;
		IF f18_foster_nw=1 OR f18_foster_last6=1 THEN f18_any_foster=1;
			ELSE IF (f18_foster_nw=0 AND f18_foster_last6=.) OR (f18_foster_nw=. AND f18_foster_last6=0) THEN f18_any_foster=0;
	END;

	*relationship status dummy variables;
	IF b_relat in(1,2) THEN b_spoupart=1; ELSE IF b_relat not in(.,97,98) THEN b_spoupart=0;
	IF b_relat in(3,4,14) AND b_age in(0:15) THEN b_child_FOdef=1; ELSE IF b_relat not in(.,97,98) THEN b_child_FOdef=0;


	/*C. Create additional descriptive variables*/
	*Time since family member last part of household (d5_1-4), in foster care (d6c_1-4);
	IF f18_d5_1>=0 THEN n_f18_d5_1=f18_d5_1; IF f18_d6c_1>=0 THEN n_f18_d6c_1=f18_d6c_1;
	IF f18_d5_2>=0 THEN n_f18_d5_2=f18_d5_2; IF f18_d6c_2>=0 THEN n_f18_d6c_2=f18_d6c_2;
	IF f18_d5_3>=0 THEN n_f18_d5_3=f18_d5_3; IF f18_d6c_3>=0 THEN n_f18_d6c_3=f18_d6c_3;
	IF f18_d5_4>=0 THEN n_f18_d5_4=f18_d5_4; IF f18_d6c_4>=0 THEN n_f18_d6c_4=f18_d6c_4;

		*calculate time;
	IF n_f18_d5_1~=. THEN f18_d5_days=SUM(SUM(n_f18_d5_1), SUM(n_f18_d5_2*7), SUM(n_f18_d5_3*30.4375), SUM(n_f18_d5_4*365.25));
	IF n_f18_d5_2~=. THEN f18_d5_weeks=SUM(SUM(n_f18_d5_1/7), SUM(n_f18_d5_2), SUM(n_f18_d5_3*4.3333), SUM(n_f18_d5_4*52));
	IF n_f18_d5_3~=. THEN f18_d5_months=SUM(SUM(n_f18_d5_1/30.4375), SUM(n_f18_d5_2/4.333), SUM(n_f18_d5_3), SUM(n_f18_d5_4*12));
	IF n_f18_d5_4~=. THEN f18_d5_years=SUM(SUM(n_f18_d5_1/365.25), SUM(n_f18_d5_2/52), SUM(n_f18_d5_3/12), SUM(n_f18_d5_4));

	IF n_f18_d6c_1~=. THEN f18_d6c_days=SUM(SUM(n_f18_d6c_1), SUM(n_f18_d6c_2*7), SUM(n_f18_d6c_3*30.4375), SUM(n_f18_d6c_4*365.25));
	IF n_f18_d6c_2~=. THEN f18_d6c_weeks=SUM(SUM(n_f18_d6c_1/7), SUM(n_f18_d6c_2), SUM(n_f18_d6c_3*4.3333), SUM(n_f18_d6c_4*52));
	IF n_f18_d6c_3~=. THEN f18_d6c_months=SUM(SUM(n_f18_d6c_1/30.4375), SUM(n_f18_d6c_2/4.333), SUM(n_f18_d6c_3), SUM(n_f18_d6c_4*12));
	IF n_f18_d6c_4~=. THEN f18_d6c_years=SUM(SUM(n_f18_d6c_1/365.25), SUM(n_f18_d6c_2/52), SUM(n_f18_d6c_3/12), SUM(n_f18_d6c_4));

	*time family member has been separated (d8a_1-2);
	IF f18_d8a_1>=0 THEN n_f18_d8a_1=f18_d8a_1; 
	IF f18_d8a_2>=0 THEN n_f18_d8a_2=f18_d8a_2; 

		*calculate time;
	IF n_f18_d8a_1~=. THEN f18_d8a_months=SUM(SUM(n_f18_d8a_1), SUM(n_f18_d8a_2*12));
	IF n_f18_d8a_2~=. THEN f18_d8a_years=SUM(SUM(n_f18_d8a_1/12), SUM(n_f18_d8a_2));

	*time family member was separated in past 6 months (d17);
	IF f18_d17_1>=0 THEN f18_d17_weeks=f18_d17_1;

	*time in foster care in past 6 months (d18c);
	IF f18_d18c_1>=0 THEN n_f18_d18c_1=f18_d18c_1;
	IF f18_d18c_2>=0 THEN n_f18_d18c_2=f18_d18c_2;
	IF f18_d18c_3>=0 THEN n_f18_d18c_3=f18_d18c_3;
	IF f18_d18c_4>=0 THEN n_f18_d18c_4=f18_d18c_4; /*Note--this should get rounded down to 6 months*/

		*calculate time;
	IF f18_d18c_1~=. THEN f18_d18c_days=SUM(SUM(n_f18_d18c_1), SUM(n_f18_d18c_2*7), SUM(n_f18_d18c_3*30.4375), SUM(n_f18_d18c_4*365.25));
	IF f18_d18c_2~=. THEN f18_d18c_weeks=SUM(SUM(n_f18_d18c_1/7), SUM(n_f18_d18c_2), SUM(n_f18_d18c_3/4.3333), SUM(n_f18_d18c_4/52));
	IF f18_d18c_3~=. THEN f18_d18c_months=SUM(SUM(n_f18_d18c_1/30.4375), SUM(n_f18_d18c_2/4.333), SUM(n_f18_d18c_3), SUM(n_f18_d18c_4/12));
	IF f18_d18c_4~=. THEN f18_d18c_years=SUM(SUM(n_f18_d18c_1/365.25), SUM(n_f18_d18c_2/52), SUM(n_f18_d18c_3/12), SUM(n_f18_d18c_4));

	*Combine time in foster care for those with and not with household with a 6 month ceiling;
	IF f18_d6c_months>=6 THEN f18_foster_past6_months=6;
		ELSE IF f18_d18c_months>=6 THEN f18_foster_past6_months=6;
		ELSE IF f18_d6c_months>0 THEN f18_foster_past6_months=f18_d6c_months;
		ELSE IF f18_d18c_months>0 THEN f18_foster_past6_months=f18_d18c_months;
		ELSE IF b_child=1 THEN f18_foster_past6_months=0;

	/*D. Create individual-level analysis bases (JMR)*/
	*Spouse/partner separations;
	IF b_present=1 AND b_relat in(1,2) THEN validInd_any_spoupart_sep=1;
		ELSE validInd_any_spoupart_sep=0;
	*Child separations and foster care placements;
	IF b_present=1 AND b_relat in(3,4,14) AND b_age in(0:15) THEN DO; validInd_any_child_sep=1; validInd_any_foster=1; END;
		ELSE DO; validInd_any_child_sep=0; validInd_any_foster=0; END;
	*Spouse/partner reunifications;
	IF b_present=0 AND b_relat in(1,2) THEN validInd_any_spoupart_reunif=1;
		ELSE validInd_any_spoupart_reunif=0;
	*Child reunifications;
	IF b_present=0 AND b_relat in(3,4,14) AND b_age in(0:15) THEN validInd_any_child_reunif=1;
		ELSE validInd_any_child_reunif=0;

RUN;


/*Step 2: Calculate intermediate count outcome variables rolled up at family level */
/***Technical term: "intermediate count outcome"
	What makes them "intermediate"? Is it that they are precursors to the finalized outcomes calculated in Part 4? (JMR)***/

*1. Number of spouse/partners separated within last 6 months at 18 month followup
	BASE: Listed as a spouse/partner at baseline and present at baseline
	CALC: Sum of these spouses/partners listed as not with family now (b1a) or separated at any time
			within the last 6 months(d16);

/***Isn't this excluding spouse/partners who were NOT present at baseline, but returned shortly after, 
	and then became separated again in the 6 months prior to the 18-month survey? (Not sure how many families this would apply to, but still...) 
	Is this an intentional rule? If so, why? 
	I have similar questions about Sections 2.2 and 2.3.(JMR)***/

PROC MEANS DATA=fpres.s14_fampres_temp SUM NOPRINT;
	WHERE b_present=1 AND b_relat in(1,2);
	VAR f18_notwith f18_seplast6;
	BY id_fam_vand;
	OUTPUT OUT=outcome1 SUM(f18_notwith)=tot_sep_spoupart_nw SUM(f18_seplast6)=tot_sep_spoupart_last6 N(id_fam_vand)=n_spoupart_bpres;
RUN;

*2. Number of children separated within last 6 months at 18 month followup
	BASE: Listed as a child at baseline (defined as biological child (3), step child (4), or grandchild (14)) age 15 or under and present at baseline
	CALC: Sum of these children listed as not with family now (b1a) or separated at any time
			within the last 6 months (d16);

PROC MEANS DATA=fpres.s14_fampres_temp SUM NOPRINT;
	WHERE b_present=1 AND b_relat in(3,4,14) AND b_age in(0:15);
	VAR f18_notwith f18_seplast6;
	BY id_fam_vand;
	OUTPUT OUT=outcome2 SUM(f18_notwith)=tot_sep_child_nw SUM(f18_seplast6)=tot_sep_child_last6 N(id_fam_vand)=n_child_bpres;
RUN;

*3. Number of children in foster care within last 6 months at 18 month followup
	BASE: Listed as a child at baseline (defined as biological child (3), step child (4), or grandchild (14)) age 15 or younger
	CALC: Sum of these children separated at any time within the last 6 months (d16) AND placed in foster care (d18b)
	NOTE: Assumed that age needed to be 15 or under. Kids 16.5 or older would be at least 18.5 and 
			could not have been placed in foster care within last 6 months because would have aged out;

PROC MEANS DATA=fpres.s14_fampres_temp SUM  NOPRINT;
	WHERE b_relat in(3,4,14) AND b_age in(0:15) AND b_present=1;
	VAR f18_foster_nw f18_foster_last6;
	BY id_fam_vand;
	OUTPUT OUT=outcome3 SUM(f18_foster_nw)=tot_foster_nw SUM(f18_foster_last6)=tot_foster_last6 N(id_fam_vand)=n_tot_child;
RUN;


*4. Number of spouse/partners reunified at 18 month followup
	BASE: Listed as a spouse/partner at baseline and not present at baseline
	CALC: Sum of these spouses/partners listed as with family now (b1a) 
			within the last 6 months(d16);
/***Similar to my previous comment: this excludes spouse/partners who were PRESENT at baseline,
	then were separated shortly after, then were reunified in the 6 months prior to the 18-month survey.
	Why's that? 
	Similar question about Section 2.5. (JMR)***/

PROC MEANS DATA=fpres.s14_fampres_temp SUM  NOPRINT;
	WHERE b_present=0 AND b_relat in(1,2);
	VAR f18_with;
	BY id_fam_vand;
	OUTPUT OUT=outcome4 SUM(f18_with)=tot_reunif_spoupart N(id_fam_vand)=n_spoupart_bsep;
RUN;



*5. Number of children reunified at 18 month followup
	BASE: Listed as a child at baseline (defined as biological child (3), step child (4), or grandchild (14)) age 15 or younger and not present at baseline
	CALC: Sum of these children listed as with family now (b1a)
			within the last 6 months (d16);

PROC MEANS DATA=fpres.s14_fampres_temp SUM NOPRINT;
	WHERE b_present=0 AND b_relat in(3,4,14) AND b_age in(0:15);
	VAR f18_with;
	BY id_fam_vand;
	OUTPUT OUT=outcome5 SUM(f18_with)=tot_reunif_child N(id_fam_vand)=n_child_bsep;
RUN;


*6. Covariate: age of oldest child with family at baseline
	BASE: Listed as a child at baseline (defined as biological child (3), step child (4), or grandchild (14)) 
	CALC: Max of b_age for children present with family at baseline
	QUESTION: Does the current age of the child need to be under 18?;

PROC MEANS DATA=fpres.s14_fampres_temp MAX NOPRINT;
	WHERE b_present=1 AND b_relat in(3,4,14) AND b_age in(0:15);
	VAR b_age;
	BY id_fam_vand;
	OUTPUT OUT=ageoldest MAX(b_age)=age_oldest_childwith;
RUN;
*end section 2;


/*Part 3: Merge total separations/reunifications/foster placements with BASELINE head of household survey data*/
PROC SQL;
	CREATE TABLE s14_fampres_merge AS 
	SELECT H.*, 
		B.tot_sep_spoupart_nw, B.tot_sep_spoupart_last6, B.n_spoupart_bpres,
		C.tot_sep_child_nw, C.tot_sep_child_last6, C.n_child_bpres,
		D.tot_foster_nw, D.tot_foster_last6, D.n_tot_child,
		E.tot_reunif_spoupart, E.n_spoupart_bsep,
		F.tot_reunif_child, F.n_child_bsep, G.age_oldest_childwith
	FROM  fam18m.s02_18mo_vand_140211 (KEEP=id_fam_vand) A
		LEFT JOIN outcome1 B ON A.id_fam_vand=B.id_fam_vand
		LEFT JOIN outcome2 C ON A.id_fam_vand=C.id_fam_vand
		LEFT JOIN outcome3 D ON A.id_fam_vand=D.id_fam_vand
		LEFT JOIN outcome4 E ON A.id_fam_vand=E.id_fam_vand
		LEFT JOIN outcome5 F ON A.id_fam_vand=F.id_fam_vand
		LEFT JOIN ageoldest G ON A.id_fam_vand=G.id_fam_vand
		LEFT JOIN fbase.s01_base_vand_140117 (KEEP= id_fam_vand AgeatRA GENDER RACE_cat RA_Result PBTH_avail CBRR_avail SUB_avail site_id) H
							ON A.id_fam_vand=H.id_fam_vand
		LEFT JOIN fdrop.s16_hfbase_flag_25ineligible_fam I ON A.id_fam_vand=I.id_fam_vand
	HAVING I.fam_ineligible=0 /*drop the 25 families ineligible at baseline entirely*/
	ORDER BY H.id_fam_vand; 
QUIT;


*Part 4: Create family-level outcomes;
DATA fpres.s14_fam_pres_impacts_140506_sb (DROP=CBRR_Avail PBTH_Avail SUB_Avail);
	SET s14_fampres_merge;

	/*NOTE: Do we need to adjust AgeAtRA ahead 18 months or get age at follow-up?*/

	*Create pairwise comparison vars;
	IF CBRR_avail>0 AND PBTH_avail>0 THEN pair_CBRR_PBTH=1; ELSE pair_CBRR_PBTH=0;
	IF CBRR_avail>0 AND SUB_avail>0 THEN pair_CBRR_SUB=1; ELSE pair_CBRR_SUB=0;
	IF SUB_avail>0 AND PBTH_avail>0 THEN pair_SUB_PBTH=1; ELSE pair_SUB_PBTH=0;
	IF CBRR_avail>0 THEN pair_CBRR_UC=1; ELSE pair_CBRR_UC=0;
	IF PBTH_avail>0 THEN pair_PBTH_UC=1; ELSE pair_PBTH_UC=0;
	IF SUB_avail>0 THEN pair_SUB_UC=1; ELSE pair_SUB_UC=0;

	SELECT (RA_Result);
		WHEN ('SUB') DO; ra_SUB=1; ra_PBTH=0; ra_CBRR=0; ra_UC=0; END;
		WHEN ('PBTH') DO; ra_SUB=0; ra_PBTH=1; ra_CBRR=0; ra_UC=0; END;
		WHEN ('CBRR') DO; ra_SUB=0; ra_PBTH=0; ra_CBRR=1; ra_UC=0; END;
		WHEN ('UC') DO; ra_SUB=0; ra_PBTH=0; ra_CBRR=0; ra_UC=1; END;
		OTHERWISE;
	END;

	/*Create impact outcome dummy variables*/
	*1. outcome_any_spouspart_sep: Any spouse or partner separations within past 6 months;
	IF tot_sep_spoupart_nw>0 OR tot_sep_spoupart_last6>0 THEN outcome_any_spoupart_sep=1;
		ELSE IF tot_sep_spoupart_nw=0 AND tot_sep_spoupart_last6=0 THEN outcome_any_spoupart_sep=0;

	*2. outcome_any_child_sep: Any child separations;
	IF tot_sep_child_nw>0 OR tot_sep_child_last6>0 THEN outcome_any_child_sep=1;
		ELSE IF tot_sep_child_nw=0 AND tot_sep_child_last6=0 THEN outcome_any_child_sep=0;

	*3. outcome_any_foster: Any foster care placement within past 6 months
			-only count as missing if missing on both foster_nw and foster_last6;
			/***Why isn't the same rule applied to dummy vars 1 and 2? (JMR)***/
	IF tot_foster_nw>0 OR tot_foster_last6>0 THEN outcome_any_foster=1;
		ELSE IF (tot_foster_nw in(0,.) AND tot_foster_last6=0) OR
				(tot_foster_nw=0 AND tot_foster_last6 in(0,.))
			THEN outcome_any_foster=0;

	*4. outcome_any_spouspart_reunif: Any spouse or partner reunifications;
	IF tot_reunif_spoupart>0  THEN outcome_any_spoupart_reunif=1;
		ELSE IF tot_reunif_spoupart=0 THEN outcome_any_spoupart_reunif=0;

	*5. outcome_any_child_reunif: Any child reunifications;
	IF tot_reunif_child>0 THEN outcome_any_child_reunif=1;
		ELSE IF tot_reunif_child=0 THEN outcome_any_child_reunif=0;


	/*Create analysis bases for each outcome measure*/
	
	*1. Spouse/Partner separations analysis base;
	IF outcome_any_spoupart_sep~=. THEN validFam_any_spoupart_sep=1;
		/*Missing: 2 families with missing follow-up data for B1A*/
		ELSE IF id_fam_vand in(2066,2281) THEN validFam_any_spoupart_sep=1;
		/*NA: did not report a spouse or partner with them at baseline or did not complete family roster at baseline */
		ELSE validFam_any_spoupart_sep=0;
	
	*2. Child separations analysis base;
	IF outcome_any_child_sep~=. THEN validFam_any_child_sep=1;
		/*Missing: five families with missing follow-up data for B1A or whether children separated in past 6 months*/
		ELSE IF id_fam_vand in(1939, 2179, 1318, 2100, 2575) THEN validFam_any_child_sep=1;
		/*NA: did not have any children meeting age/relationship status criteria or did not complete family roster at baseline*/
		ELSE validFam_any_child_sep=0;

	*3. Foster care analysis base;
	IF outcome_any_foster~=. THEN validFam_any_foster=1;
		/*Missing: 4 families with missing follow-up data for B1A*/
		ELSE IF id_fam_vand in(1939) THEN validFam_any_foster=1;
		/*NA: did not have any children meeting age/relationship status criteria or did not complete family roster at baseline*/
		ELSE validFam_any_foster=0;

	*4. Spouse/Partner reunifications analysis base;
	IF outcome_any_spoupart_reunif~=. THEN validFam_any_spoupart_reunif=1;
		/*Missing: 3 families with missing follow-up data for B1A*/
		ELSE IF id_fam_vand in(1461, 2025, 3018) THEN validFam_any_spoupart_reunif=1;
		/*NA: did not report a spouse or partner as not being with them at baseline or did not complete family roster at baseline */
		ELSE validFam_any_spoupart_reunif=0;
	
	*5. Child reunifications analysis base;
	IF outcome_any_child_reunif~=. THEN validFam_any_child_reunif=1;
		/*Missing: 5 families with missing follow-up data for B1A for all children not with household at baseline*/
		ELSE IF id_fam_vand in(1254, 1303, 1461, 1505, 1572) THEN validFam_any_child_reunif=1;
		/*NA: did not have any children separated at baseline or did not have any that met age/relationship status criteria. Alternately, did not complete family roster at baseline*/
		ELSE validFam_any_child_reunif=0;

	*Attach labels;
	LABEL
	id_fam_vand = 'Unique de-identified household ID' 
	AgeatRA = 'Age of respondent as of random assignment date' 
	GENDER = 'Gender of respondent' 
	RACE_cat = 'Respondent race, categorical' 
	RA_Result = 'Random assignment intervention selection' 
	site_id = 'Study site ID' 
	tot_sep_spoupart_nw = 'Total number of spouses or partners with family at baseline and not with family at 18 months (separations)' 
	tot_sep_spoupart_last6 = 'Total number of spouses or partners with family at baseline and at 18 months who were not with the family at some time within the past 6 months (separations)' 
	n_spoupart_bpres = 'Count of total spouse or partners with family at baseline' 
	tot_sep_child_nw = 'Total number of children with family at baseline and not with family at 18 months (separations)' 
	tot_sep_child_last6 = 'Total number of children with family at baseline and at 18 months who were not with the family at some time within the past 6 months (separations)' 
	n_child_bpres = 'Count of children with family at baseline' 
	tot_foster_nw = 'Total number of children not with the family at 18 months who are in foster care' 
	tot_foster_last6 = 'Total number of children with family at 18 months who were in foster care at some time within the past 6 months' 
	n_tot_child = 'Count of children with and not with family at baseline' 
	tot_reunif_spoupart = 'Total number of spouses or partners not with family at baseline and with family at 18 months (reunifications)' 
	n_spoupart_bsep = 'Count of total spouse or partners not with family at baseline' 
	tot_reunif_child = 'Total number of children not with family at baseline and with family at 18 months (reunifications)' 
	n_child_bsep = 'Count of children not with family at baseline' 
	age_oldest_childwith = 'Age of oldest child under 16 at baseline' 
	pair_CBRR_PBTH = 'Respondent had both CBRR and PBTH available at random assignment' 
	pair_CBRR_SUB = 'Respondent had both CBRR and SUB available at random assignment' 
	pair_SUB_PBTH = 'Respondent had both SUB  and PBTH available at random assignment' 
	pair_CBRR_UC = 'Respondent had both CBRR and UC available at random assignment' 
	pair_PBTH_UC = 'Respondent had both PBTH and UC available at random assignment' 
	pair_SUB_UC = 'Respondent had both SUB and UC available at random assignment' 
	ra_SUB = 'Respondent was randomly assigned to SUB' 
	ra_PBTH = 'Respondent was randomly assigned to PBTH' 
	ra_CBRR = 'Respondent was randomly assigned to CBRR' 
	ra_UC = 'Respondent was randomly assigned to UC' 
	outcome_any_spoupart_sep = 'Was any spouse or partner with the family at baseline separated from the family within the past 6 months?' 
	outcome_any_child_sep = 'Were any children with the family at baseline separated from the family within the past 6 months?' 
	outcome_any_foster = 'Were any children living in foster care within the past 6 months?' 
	outcome_any_spoupart_reunif = 'Was any spouse or partner not with the family at baseline with the family at the 18-month follow-up survey?' 
	outcome_any_child_reunif = 'Were any children not with the family at baseline with the family at the 18-month follow-up survey?' 
	validFam_any_spoupart_sep = 'Is the family in the analysis base for the spouse or partner separations analysis?' 
	validFam_any_child_sep = 'Is the family in the analysis base for the child separations analysis?' 
	validFam_any_foster = 'Is the family in the analysis base for the foster care analysis?' 
	validFam_any_spoupart_reunif = 'Is the family in the analysis base for the spouse or partner reunification analysis?' 
	validFam_any_child_reunif = 'Is the family in the analysis base for the child reunification analysis?' 
	;

RUN;

/*Part 5: Merge outcomes data with individual-level data (JMR) */
PROC SORT data=fpres.s14_fam_pres_impacts_140506_sb;
	BY id_fam_vand;
PROC SORT data=fpres.s14_fampres_temp;
	BY id_fam_vand;
DATA fpres.s14_fampres_ind_140617_jmr;
	MERGE fpres.s14_fam_pres_impacts_140506_sb fpres.s14_fampres_temp;
	BY id_fam_vand;
RUN;


/*
*Frequencies indicating bases (note: excludes 20 families from the set of 
  25 families that should have been ineligible at baseline (the other 5 did not complete 
   an 18 month follow-up survey);
PROC FREQ DATA=fpres.s14_fam_pres_impacts_140506_sb;
	TABLES outcome_any_spoupart_sep*valid_any_spoupart_sep /missing norow nocol nopercent;
	TABLES outcome_any_child_sep*valid_any_child_sep /missing norow nocol nopercent;
	TABLES outcome_any_foster*valid_any_foster /missing norow nocol nopercent;
	TABLES outcome_any_spoupart_reunif*valid_any_spoupart_reunif /missing norow nocol nopercent;
	TABLES outcome_any_child_reunif*valid_any_child_reunif /missing norow nocol nopercent;
RUN;
*/


*END PROGRAM;

