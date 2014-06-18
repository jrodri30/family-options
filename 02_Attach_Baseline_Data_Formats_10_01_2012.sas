/*options fmtsearch=(hfsurv) nofmterr;
proc freq data=hfsurv.master_02292012; tables site_id*shelter / list norow nocol nopercent;run;
proc print data=hfsurv.master_02292012; where shelter=22; var site_id shelter;run;
proc sql;
	select site_id label='site', shelter label='shelter', N(shelter) as Count label='Count'
	FROM hfsurv.master_02292012
	GROUP BY shelter, site_id
	ORDER BY shelter;
quit;*/

libname library 'S:\Projects\Homefam\Data\CAPI Baseline Data' ;

proc format library = library ;
   value SHELTER
      1 = 'UMOM'  
      2 = 'CASS Vista Colina'  
      3 = 'A New Leaf Shelter (La Mesita)'  
      4 = 'Kaiser Salvation Army'  
      5 = 'Emergency Shelter Program'  
      6 = 'Abode Services Sunrise Village'  
      7 = 'Abode Services Winter Relief'  
      8 = 'Berkeley Food & Housing Shelter for Women and Children'  
      9 = 'Building Futures with Women & Children: San Leandro'  
      10 = 'Building Futures with Women & Children: Midway'  
      11 = 'Building Futures with Women & Children: Sister Me'  
      12 = 'FESCO'  
      13 = 'East Oakland Community Project'  
      14 = 'Gateway Homeless Services Center'  
      15 = 'Road Home'  
      16 = 'Family Promise of Hawaii - Windward'  
      17 = 'Family Promise of Hawaii - Honolulu'  
      18 = 'H-5 Hawaii'  
      19 = "IHS - Ka'ahi Women & Families Shelter"
      20 = 'Waianae Civic Center'  
      21 = 'Waianae Community Outreach'  
	  /*kansas city and atlanta salvation army had same shelter code (22)...but cross tab w/ site id breaks out correctly
	  Create new alternate code for KC Salvation army on back end*/
      22 = 'Salvation Army (Atlanta)'  
      23 = 'reStart, Inc.'  
      24 = 'City Union Mission'  
      25 = 'New Haven Home Recovery'  
      26 = 'Open Door Shelter'   /*changed to reflect lauren's notes 10/1*/
      27 = 'St. Lukes Lifeworks'  
      28 = 'Life Haven, Inc.'  /*uppercase H 10/1*/
      29 = 'Christian Community Action'  
      30 = 'Home with Hope/Interfaith Housing Associates'  
      31 = 'Samaritan House'  
      32 = 'Family Tree (House of Hope)'  
      33 = 'Colorado Coalition'  
      34 = 'Families in Transition'  /*on backend change all 34 to 38 */
      35 = 'Crossroads Family Shelter' /*on backend change all 35 to 49 */  
      36 = "Margaret's House"  
      37 = 'People Serving People'  
      38 = 'CCYMCA-Alpha Community Services - Families in Transitions'  
      39 = 'Operation Hope - Family Shelter Readiness Program'  
      40 = 'Harrison House'  
      41 = 'Access Housing'  
      42 = 'Salvation Army ES (Louisville)' /*changed to make clearer since multiple SAs 10/1*/  
      43 = 'Volunteers of America (VOA) ES'  
      44 = 'Wayside Christian Mission ES'  
      45 = "Sarah's Hope"  
      46 = 'Christ Lutheran'  
      47 = 'Action for Boston Community Development (ABCD)'  
      48 = "Children's Services of Roxbury"  
      49 = 'Crossroads Family Shelter'  
      50 = 'Heading Home'  
      51 = 'Hildenbrand Family Self-Help Center'  
      52 = 'Little Sisters of the Assumption'  
      53 = 'YMCA of Greater Boston'  
      54 = 'Shelter for the homeless, Inc.'  
      55 = 'Share House'  /*formerly listed as Trinity Hall 10/1*/
      56 = 'Decatur Coop'  
      57 = 'Booth House'  
      58 = 'Norwalk SafeHouse'  
      59 = 'Stamford SafeHouse'  
      60 = 'Crittendon' 
	  61 = 'Interfaith Hospitality Access Network'
	  62 = "St. Mary's"
	  63 = 'Salvation Army (Kansas City)';
;
   value SITEID
      1 = '01 = Alameda County'  
      2 = '02 = Atlanta'  
      3 = '03 = Boston'  
      4 = '04 = Connecticut'  
      5 = '05 = Denver'  
      6 = '06 = Honolulu'  
      7 = '07 = Kansas City'  
      8 = '08 = Minneapolis'  
      9 = '09 = Phoenix'  
      10 = '10 = Salt Lake City'  
	  /*11 is Baltimore and 12 is louisville in RAW, so transformed baseline data to reflect this
	  	Updating labels to match transformation to avoid confusion*/
      11 = '11 = Baltimore'  
      12 = '12 = Louisville' ;
   value A1A
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REF'  
      8 = 'DK' ;
   value A1B
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REF'  
      8 = 'DK' ;
   value A1C
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REF'  
      8 = 'DK' ;
   value A1D
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REF'  
      8 = 'DK' ;
   value A1E
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REF'  
      8 = 'DK' ;
   value A1F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REF'  
      8 = 'DK' ;
   value A1G
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REF'  
      8 = 'DK' ;
   value A1H
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REF'  
      8 = 'DK' ;
   value A1I
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REF'  
      8 = 'DK' ;
   value A1J
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REF'  
      8 = 'DK' ;
   value A1K
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REF'  
      8 = 'DK' ;
   value A1L
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REF'  
      8 = 'DK' ;
   value A1M
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REF'  
      8 = 'DK' ;
   value A1N
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REF'  
      8 = 'DK' ;
   value A1O
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REF'  
      8 = 'DK' ;
   value A1P
      1 = 'YES, please specify:'  
      2 = 'NO'  
      7 = 'REF'  
      8 = 'DK' ;
   value A2F
      1 = 'REPORTED TIME IN YEARS'  
      2 = 'REPORTED TIME IN MONTHS'  
      3 = 'REPORTED TIME BY DAYS'  
      97 = 'REFUSED'  
      98 = 'DON"T KNOW' ;
   value A4F
      1 = 'REPORTED TIME IN YEARS'  
      2 = 'REPORTED TIME IN MONTHS'  
      3 = 'REPORTED TIME BY DAYS'  
      97 = 'REFUSED'  
      98 = 'DON"T KNOW' ;
   value B1A
      1 = 'Big problem'  
      2 = 'Small problem'  
      3 = 'Not a problem at all'  
      7 = 'Refused'  
      8 = 'Don"t know' ;
   value B1B
      1 = 'Big problem'  
      2 = 'Small problem'  
      3 = 'Not a problem at all'  
      7 = 'Refused'  
      8 = 'Don"t know' ;
   value B1C
      1 = 'Big problem'  
      2 = 'Small problem'  
      3 = 'Not a problem at all'  
      7 = 'Refused'  
      8 = 'Don"t know' ;
   value B1D
      1 = 'Big problem'  
      2 = 'Small problem'  
      3 = 'Not a problem at all'  
      7 = 'Refused'  
      8 = 'Don"t know' ;
   value B1E
      1 = 'Big problem'  
      2 = 'Small problem'  
      3 = 'Not a problem at all'  
      7 = 'Refused'  
      8 = 'Don"t know' ;
   value B1F
      1 = 'Big problem'  
      2 = 'Small problem'  
      3 = 'Not a problem at all'  
      7 = 'Refused'  
      8 = 'Don"t know' ;
   value B1G
      1 = 'Big problem'  
      2 = 'Small problem'  
      3 = 'Not a problem at all'  
      7 = 'Refused'  
      8 = 'Don"t know' ;
   value B1H
      1 = 'Big problem'  
      2 = 'Small problem'  
      3 = 'Not a problem at all'  
      7 = 'Refused'  
      8 = 'Don"t know' ;
   value B1I
      1 = 'Big problem'  
      2 = 'Small problem'  
      3 = 'Not a problem at all'  
      7 = 'Refused'  
      8 = 'Don"t know' ;
   value B1J
      1 = 'Big problem'  
      2 = 'Small problem'  
      3 = 'Not a problem at all'  
      7 = 'Refused'  
      8 = 'Don"t know' ;
   value B1K
      1 = 'Big problem'  
      2 = 'Small problem'  
      3 = 'Not a problem at all'  
      7 = 'Refused'  
      8 = 'Don"t know' ;
   value B1L
      1 = 'Big problem'  
      2 = 'Small problem'  
      3 = 'Not a problem at all'  
      7 = 'Refused'  
      8 = 'Don"t know' ;
   value B1M
      1 = 'Big problem'  
      2 = 'Small problem'  
      3 = 'Not a problem at all'  
      7 = 'Refused'  
      8 = 'Don"t know' ;
   value B1N
      1 = 'Big problem'  
      2 = 'Small problem'  
      3 = 'Not a problem at all'  
      7 = 'Refused'  
      8 = 'Don"t know' ;
   value B1O
      1 = 'Big problem'  
      2 = 'Small problem'  
      3 = 'Not a problem at all'  
      7 = 'Refused'  
      8 = 'Don"t know' ;
   value B1P
      1 = 'Big problem'  
      2 = 'Small problem'  
      3 = 'Not a problem at all'  
      7 = 'Refused'  
      8 = 'Don"t know' ;
   value B1Q
      1 = 'Big problem'  
      2 = 'Small problem'  
      3 = 'Not a problem at all'  
      7 = 'Refused'  
      8 = 'Don"t know' ;
   value B1R
      1 = 'Big problem'  
      2 = 'Small problem'  
      3 = 'Not a problem at all'  
      7 = 'Refused'  
      8 = 'Don"t know' ;
   value B1S
      1 = 'Big problem'  
      2 = 'Small problem'  
      3 = 'Not a problem at all'  
      7 = 'Refused'  
      8 = 'Don"t know' ;
   value C1B
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REF'  
      8 = 'DK' ;
   value C2A
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value C4F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value C5F
      1 = 'WITH MY PARENT(S)'  
      2 = 'ON MY OWN'  
      3 = 'OTHER (SPECIFY)'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW'  
      9 = 'Missing' ;
   value C6B
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value C7F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value C8B
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value D1F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value D2F
      1 = 'UNABLE TO WORK BECAUSE OF HOUSING PROBLEMS'  
      2 = 'UNABLE TO WORK FOR HEALTH REASONS'  
      3 = 'HAS JOB BUT TEMPORARILY ABSENT /SEASONAL WORK'  
      4 = 'COULDN"T FIND ANY WORK'  
      5 = 'CHILD CARE PROBLEMS'  
      6 = 'FAMILY RESPONSIBILITIES'  
      7 = 'IN SCHOOL OR OTHER TRAINING'  
      8 = 'WAITING FOR A NEW JOB TO BEGIN'  
      9 = 'RESPONSIBILITIES FOR CARE OF FAMILY MEMBER WITH A DISABILITY'  
      10 = 'RETIRED'  
      11 = 'DISABLED'  
      12 = 'LAID OFF'  
      13 = 'FIRED'  
      14 = 'Pregnant/Having Baby/Maternity Leave'  
      15 = 'Transportation Problems'  
      96 = 'OTHER (SPECIFY)'  
      97 = 'REFUSED'  
      98 = 'DON"T KNOW' ;
   value D3F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value D4F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value D5F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value D7F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value D10F
      1 = 'HOURLY'  
      2 = 'DAILY'  
      3 = 'WEEKLY'  
      4 = 'BI-WEEKLY (EVERY 2 WEEKS)'  
      5 = 'TWICE MONTHLY'  
      6 = 'MONTHLY'  
      7 = 'ANNUALLY'  
      8 = 'PER UNIT'  
      96 = 'OTHER (SPECIFY)'  
      97 = 'REFUSED'  
      98 = 'DON"T KNOW' ;
   value D11F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E1F
      1 = 'Single, never married'  
      2 = 'Married or living in a marriage like situation'  
      3 = 'Widowed'  
      4 = 'Separated/Divorced'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E5F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E6F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E7_1F
      1 = 'HUSBAND OR WIFE'  
      2 = 'LOVER/PARTNER'  
      3 = 'BIOLOGICAL CHILD'  
      4 = 'STEP-CHILD'  
      5 = 'FOSTER CHILD'  
      6 = 'CHILD OF LOVER/PARTNER'  
      7 = 'SON- OR DAUGHTER-IN-LAW'  
      8 = 'MOTHER OR FATHER'  
      9 = 'STEP-PARENT'  
      10 = 'MOTHER- OR FATHER-IN-LAW OR PARTNER"S PARENT'  
      11 = 'GRANDPARENT'  
      12 = 'BROTHER OR SISTER'  
      13 = 'BROTHER- OR SISTER-IN-LAW'  
      14 = 'GRANDCHILD'  
      15 = 'OTHER RELATIVE'  
      97 = 'REFUSED'  
      98 = 'DON"T KNOW' ;
   value E8_1F
      1 = 'Male'  
      2 = 'Female'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E10_1F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E11_1F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E12_1F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E13_1F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E14_1F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E16_1F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E17_1F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E7_2F
      1 = 'HUSBAND OR WIFE'  
      2 = 'LOVER/PARTNER'  
      3 = 'BIOLOGICAL CHILD'  
      4 = 'STEP-CHILD'  
      5 = 'FOSTER CHILD'  
      6 = 'CHILD OF LOVER/PARTNER'  
      7 = 'SON- OR DAUGHTER-IN-LAW'  
      8 = 'MOTHER OR FATHER'  
      9 = 'STEP-PARENT'  
      10 = 'MOTHER- OR FATHER-IN-LAW OR PARTNER"S PARENT'  
      11 = 'GRANDPARENT'  
      12 = 'BROTHER OR SISTER'  
      13 = 'BROTHER- OR SISTER-IN-LAW'  
      14 = 'GRANDCHILD'  
      15 = 'OTHER RELATIVE'  
      97 = 'REFUSED'  
      98 = 'DON"T KNOW' ;
   value E8_2F
      1 = 'Male'  
      2 = 'Female'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E10_2F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E11_2F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E12_2F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E13_2F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E14_2F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E16_2F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E17_2F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E7_3F
      1 = 'HUSBAND OR WIFE'  
      2 = 'LOVER/PARTNER'  
      3 = 'BIOLOGICAL CHILD'  
      4 = 'STEP-CHILD'  
      5 = 'FOSTER CHILD'  
      6 = 'CHILD OF LOVER/PARTNER'  
      7 = 'SON- OR DAUGHTER-IN-LAW'  
      8 = 'MOTHER OR FATHER'  
      9 = 'STEP-PARENT'  
      10 = 'MOTHER- OR FATHER-IN-LAW OR PARTNER"S PARENT'  
      11 = 'GRANDPARENT'  
      12 = 'BROTHER OR SISTER'  
      13 = 'BROTHER- OR SISTER-IN-LAW'  
      14 = 'GRANDCHILD'  
      15 = 'OTHER RELATIVE'  
      97 = 'REFUSED'  
      98 = 'DON"T KNOW' ;
   value E8_3F
      1 = 'Male'  
      2 = 'Female'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E10_3F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E11_3F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E12_3F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E13_3F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E14_3F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E16_3F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E17_3F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E7_4F
      1 = 'HUSBAND OR WIFE'  
      2 = 'LOVER/PARTNER'  
      3 = 'BIOLOGICAL CHILD'  
      4 = 'STEP-CHILD'  
      5 = 'FOSTER CHILD'  
      6 = 'CHILD OF LOVER/PARTNER'  
      7 = 'SON- OR DAUGHTER-IN-LAW'  
      8 = 'MOTHER OR FATHER'  
      9 = 'STEP-PARENT'  
      10 = 'MOTHER- OR FATHER-IN-LAW OR PARTNER"S PARENT'  
      11 = 'GRANDPARENT'  
      12 = 'BROTHER OR SISTER'  
      13 = 'BROTHER- OR SISTER-IN-LAW'  
      14 = 'GRANDCHILD'  
      15 = 'OTHER RELATIVE'  
      97 = 'REFUSED'  
      98 = 'DON"T KNOW' ;
   value E8_4F
      1 = 'Male'  
      2 = 'Female'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E10_4F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E11_4F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E12_4F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E13_4F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E14_4F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E16_4F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E17_4F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E7_5F
      1 = 'HUSBAND OR WIFE'  
      2 = 'LOVER/PARTNER'  
      3 = 'BIOLOGICAL CHILD'  
      4 = 'STEP-CHILD'  
      5 = 'FOSTER CHILD'  
      6 = 'CHILD OF LOVER/PARTNER'  
      7 = 'SON- OR DAUGHTER-IN-LAW'  
      8 = 'MOTHER OR FATHER'  
      9 = 'STEP-PARENT'  
      10 = 'MOTHER- OR FATHER-IN-LAW OR PARTNER"S PARENT'  
      11 = 'GRANDPARENT'  
      12 = 'BROTHER OR SISTER'  
      13 = 'BROTHER- OR SISTER-IN-LAW'  
      14 = 'GRANDCHILD'  
      15 = 'OTHER RELATIVE'  
      97 = 'REFUSED'  
      98 = 'DON"T KNOW' ;
   value E8_5F
      1 = 'Male'  
      2 = 'Female'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E10_5F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E11_5F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E12_5F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E13_5F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E14_5F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E16_5F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E17_5F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E7_6F
      1 = 'HUSBAND OR WIFE'  
      2 = 'LOVER/PARTNER'  
      3 = 'BIOLOGICAL CHILD'  
      4 = 'STEP-CHILD'  
      5 = 'FOSTER CHILD'  
      6 = 'CHILD OF LOVER/PARTNER'  
      7 = 'SON- OR DAUGHTER-IN-LAW'  
      8 = 'MOTHER OR FATHER'  
      9 = 'STEP-PARENT'  
      10 = 'MOTHER- OR FATHER-IN-LAW OR PARTNER"S PARENT'  
      11 = 'GRANDPARENT'  
      12 = 'BROTHER OR SISTER'  
      13 = 'BROTHER- OR SISTER-IN-LAW'  
      14 = 'GRANDCHILD'  
      15 = 'OTHER RELATIVE'  
      97 = 'REFUSED'  
      98 = 'DON"T KNOW' ;
   value E8_6F
      1 = 'Male'  
      2 = 'Female'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E10_6F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E11_6F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E12_6F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E13_6F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E14_6F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E16_6F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E17_6F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E7_7F
      1 = 'HUSBAND OR WIFE'  
      2 = 'LOVER/PARTNER'  
      3 = 'BIOLOGICAL CHILD'  
      4 = 'STEP-CHILD'  
      5 = 'FOSTER CHILD'  
      6 = 'CHILD OF LOVER/PARTNER'  
      7 = 'SON- OR DAUGHTER-IN-LAW'  
      8 = 'MOTHER OR FATHER'  
      9 = 'STEP-PARENT'  
      10 = 'MOTHER- OR FATHER-IN-LAW OR PARTNER"S PARENT'  
      11 = 'GRANDPARENT'  
      12 = 'BROTHER OR SISTER'  
      13 = 'BROTHER- OR SISTER-IN-LAW'  
      14 = 'GRANDCHILD'  
      15 = 'OTHER RELATIVE'  
      97 = 'REFUSED'  
      98 = 'DON"T KNOW' ;
   value E8_7F
      1 = 'Male'  
      2 = 'Female'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E10_7F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E11_7F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E12_7F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E13_7F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E14_7F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E16_7F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E17_7F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E7_8F
      1 = 'HUSBAND OR WIFE'  
      2 = 'LOVER/PARTNER'  
      3 = 'BIOLOGICAL CHILD'  
      4 = 'STEP-CHILD'  
      5 = 'FOSTER CHILD'  
      6 = 'CHILD OF LOVER/PARTNER'  
      7 = 'SON- OR DAUGHTER-IN-LAW'  
      8 = 'MOTHER OR FATHER'  
      9 = 'STEP-PARENT'  
      10 = 'MOTHER- OR FATHER-IN-LAW OR PARTNER"S PARENT'  
      11 = 'GRANDPARENT'  
      12 = 'BROTHER OR SISTER'  
      13 = 'BROTHER- OR SISTER-IN-LAW'  
      14 = 'GRANDCHILD'  
      15 = 'OTHER RELATIVE'  
      97 = 'REFUSED'  
      98 = 'DON"T KNOW' ;
   value E8_8F
      1 = 'Male'  
      2 = 'Female'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E10_8F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E11_8F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E12_8F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E13_8F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E14_8F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E16_8F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E17_8F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E7_9F
      1 = 'HUSBAND OR WIFE'  
      2 = 'LOVER/PARTNER'  
      3 = 'BIOLOGICAL CHILD'  
      4 = 'STEP-CHILD'  
      5 = 'FOSTER CHILD'  
      6 = 'CHILD OF LOVER/PARTNER'  
      7 = 'SON- OR DAUGHTER-IN-LAW'  
      8 = 'MOTHER OR FATHER'  
      9 = 'STEP-PARENT'  
      10 = 'MOTHER- OR FATHER-IN-LAW OR PARTNER"S PARENT'  
      11 = 'GRANDPARENT'  
      12 = 'BROTHER OR SISTER'  
      13 = 'BROTHER- OR SISTER-IN-LAW'  
      14 = 'GRANDCHILD'  
      15 = 'OTHER RELATIVE'  
      97 = 'REFUSED'  
      98 = 'DON"T KNOW' ;
   value E8_9F
      1 = 'Male'  
      2 = 'Female'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E10_9F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E11_9F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E12_9F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E13_9F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E14_9F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E16_9F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E17_9F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E19_1F
      1 = 'Husband or Wife'  
      2 = 'Lover/Partner'  
      3 = 'Biological Child'  
      4 = 'Step-Child'  
      5 = 'Foster Child'  
      6 = 'Child of Lover/Partner'  
      97 = 'Refused'  
      98 = 'Don"t know' ;
   value E20_1F
      1 = 'Male'  
      2 = 'Female'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E22_1F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E23_1F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E27_1F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E19_2F
      1 = 'Husband or Wife'  
      2 = 'Lover/Partner'  
      3 = 'Biological Child'  
      4 = 'Step-Child'  
      5 = 'Foster Child'  
      6 = 'Child of Lover/Partner'  
      97 = 'Refused'  
      98 = 'Don"t know' ;
   value E20_2F
      1 = 'Male'  
      2 = 'Female'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E22_2F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E23_2F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E27_2F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E19_3F
      1 = 'Husband or Wife'  
      2 = 'Lover/Partner'  
      3 = 'Biological Child'  
      4 = 'Step-Child'  
      5 = 'Foster Child'  
      6 = 'Child of Lover/Partner'  
      97 = 'Refused'  
      98 = 'Don"t know' ;
   value E20_3F
      1 = 'Male'  
      2 = 'Female'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E22_3F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E23_3F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E27_3F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E19_4F
      1 = 'Husband or Wife'  
      2 = 'Lover/Partner'  
      3 = 'Biological Child'  
      4 = 'Step-Child'  
      5 = 'Foster Child'  
      6 = 'Child of Lover/Partner'  
      97 = 'Refused'  
      98 = 'Don"t know' ;
   value E20_4F
      1 = 'Male'  
      2 = 'Female'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E22_4F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E23_4F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E27_4F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E19_5F
      1 = 'Husband or Wife'  
      2 = 'Lover/Partner'  
      3 = 'Biological Child'  
      4 = 'Step-Child'  
      5 = 'Foster Child'  
      6 = 'Child of Lover/Partner'  
      97 = 'Refused'  
      98 = 'Don"t know' ;
   value E20_5F
      1 = 'Male'  
      2 = 'Female'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E22_5F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E23_5F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E27_5F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E19_6F
      1 = 'Husband or Wife'  
      2 = 'Lover/Partner'  
      3 = 'Biological Child'  
      4 = 'Step-Child'  
      5 = 'Foster Child'  
      6 = 'Child of Lover/Partner'  
      97 = 'Refused'  
      98 = 'Don"t know' ;
   value E20_6F
      1 = 'Male'  
      2 = 'Female'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E22_6F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E23_6F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E27_6F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E19_7F
      1 = 'Husband or Wife'  
      2 = 'Lover/Partner'  
      3 = 'Biological Child'  
      4 = 'Step-Child'  
      5 = 'Foster Child'  
      6 = 'Child of Lover/Partner'  
      97 = 'Refused'  
      98 = 'Don"t know' ;
   value E20_7F
      1 = 'Male'  
      2 = 'Female'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E22_7F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E23_7F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value E27_7F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value F1A
      1 = 'Yes'  
      2 = 'No'  
      7 = 'Don"t know'  
      8 = 'Refused' ;
   value F1B
      1 = 'Yes'  
      2 = 'No'  
      7 = 'Don"t know'  
      8 = 'Refused' ;
   value F1C
      1 = 'Yes'  
      2 = 'No'  
      7 = 'Don"t know'  
      8 = 'Refused' ;
   value F1D
      1 = 'Yes'  
      2 = 'No'  
      7 = 'Don"t know'  
      8 = 'Refused' ;
   value F1E
      1 = 'Yes'  
      2 = 'No'  
      7 = 'Don"t know'  
      8 = 'Refused' ;
   value F1F
      1 = 'Yes'  
      2 = 'No'  
      7 = 'Don"t know'  
      8 = 'Refused' ;
   value F1G
      1 = 'Yes'  
      2 = 'No'  
      7 = 'Don"t know'  
      8 = 'Refused' ;
   value F1H
      1 = 'Yes'  
      2 = 'No'  
      7 = 'Don"t know'  
      8 = 'Refused' ;
   value F1I
      1 = 'Yes'  
      2 = 'No'  
      7 = 'Don"t know'  
      8 = 'Refused' ;
   value F1J
      1 = 'Yes'  
      2 = 'No'  
      7 = 'Don"t know'  
      8 = 'Refused' ;
   value F1K
      1 = 'Yes'  
      2 = 'No'  
      7 = 'Don"t know'  
      8 = 'Refused' ;
   value F1L
      1 = 'Yes'  
      2 = 'No'  
      7 = 'Don"t know'  
      8 = 'Refused' ;
   value F1M
      1 = 'Yes'  
      2 = 'No'  
      7 = 'Don"t know'  
      8 = 'Refused' ;
   value F1N
      1 = 'Yes'  
      2 = 'No'  
      7 = 'Don"t know'  
      8 = 'Refused' ;
   value F1O
      1 = 'Yes'  
      2 = 'No'  
      7 = 'Don"t know'  
      8 = 'Refused' ;
   value F1P
      1 = 'Yes'  
      2 = 'No'  
      7 = 'Don"t know'  
      8 = 'Refused' ;
   value F2A
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value F3F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value F4F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value F5F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value F6F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value F7F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value G1F
      1 = 'Excellent'  
      2 = 'Very good'  
      3 = 'Good'  
      4 = 'Fair'  
      5 = 'Poor'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value GENDER
      1 = 'Male'  
      2 = 'Female' ;
   value G2F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value G3A
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value G3B
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value G3C
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value G3D
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value G3E
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value G3F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value G3G
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value G3H
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value G3I
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value G3J
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value G3K
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value G3L
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value G3M
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value G3N
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value G3O
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value G3P
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value G3Q
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value H1A
      1 = 'ALL of the time'  
      2 = 'MOST of the time'  
      3 = 'SOME of the time'  
      4 = 'A LITTLE of the time'  
      5 = 'NONE of the time'  
      7 = 'REF'  
      8 = 'DK' ;
   value H1B
      1 = 'ALL of the time'  
      2 = 'MOST of the time'  
      3 = 'SOME of the time'  
      4 = 'A LITTLE of the time'  
      5 = 'NONE of the time'  
      7 = 'REF'  
      8 = 'DK' ;
   value H1C
      1 = 'ALL of the time'  
      2 = 'MOST of the time'  
      3 = 'SOME of the time'  
      4 = 'A LITTLE of the time'  
      5 = 'NONE of the time'  
      7 = 'REF'  
      8 = 'DK' ;
   value H1D
      1 = 'ALL of the time'  
      2 = 'MOST of the time'  
      3 = 'SOME of the time'  
      4 = 'A LITTLE of the time'  
      5 = 'NONE of the time'  
      7 = 'REF'  
      8 = 'DK' ;
   value H1E
      1 = 'ALL of the time'  
      2 = 'MOST of the time'  
      3 = 'SOME of the time'  
      4 = 'A LITTLE of the time'  
      5 = 'NONE of the time'  
      7 = 'REF'  
      8 = 'DK' ;
   value H1F
      1 = 'ALL of the time'  
      2 = 'MOST of the time'  
      3 = 'SOME of the time'  
      4 = 'A LITTLE of the time'  
      5 = 'NONE of the time'  
      7 = 'REF'  
      8 = 'DK' ;
   value H2A
      1 = 'Not at all'  
      2 = 'A little bit'  
      3 = 'Moderately'  
      4 = 'Quite a bit'  
      5 = 'Extremely'  
      7 = 'REF'  
      8 = 'DK' ;
   value H2B
      1 = 'Not at all'  
      2 = 'A little bit'  
      3 = 'Moderately'  
      4 = 'Quite a bit'  
      5 = 'Extremely'  
      7 = 'REF'  
      8 = 'DK' ;
   value H2C
      1 = 'Not at all'  
      2 = 'A little bit'  
      3 = 'Moderately'  
      4 = 'Quite a bit'  
      5 = 'Extremely'  
      7 = 'REF'  
      8 = 'DK' ;
   value H2D
      1 = 'Not at all'  
      2 = 'A little bit'  
      3 = 'Moderately'  
      4 = 'Quite a bit'  
      5 = 'Extremely'  
      7 = 'REF'  
      8 = 'DK' ;
   value H2E
      1 = 'Not at all'  
      2 = 'A little bit'  
      3 = 'Moderately'  
      4 = 'Quite a bit'  
      5 = 'Extremely'  
      7 = 'REF'  
      8 = 'DK' ;
   value H2F
      1 = 'Not at all'  
      2 = 'A little bit'  
      3 = 'Moderately'  
      4 = 'Quite a bit'  
      5 = 'Extremely'  
      7 = 'REF'  
      8 = 'DK' ;
   value H2G
      1 = 'Not at all'  
      2 = 'A little bit'  
      3 = 'Moderately'  
      4 = 'Quite a bit'  
      5 = 'Extremely'  
      7 = 'REF'  
      8 = 'DK' ;
   value H2H
      1 = 'Not at all'  
      2 = 'A little bit'  
      3 = 'Moderately'  
      4 = 'Quite a bit'  
      5 = 'Extremely'  
      7 = 'REF'  
      8 = 'DK' ;
   value H2I
      1 = 'Not at all'  
      2 = 'A little bit'  
      3 = 'Moderately'  
      4 = 'Quite a bit'  
      5 = 'Extremely'  
      7 = 'REF'  
      8 = 'DK' ;
   value H2J
      1 = 'Not at all'  
      2 = 'A little bit'  
      3 = 'Moderately'  
      4 = 'Quite a bit'  
      5 = 'Extremely'  
      7 = 'REF'  
      8 = 'DK' ;
   value H2K
      1 = 'Not at all'  
      2 = 'A little bit'  
      3 = 'Moderately'  
      4 = 'Quite a bit'  
      5 = 'Extremely'  
      7 = 'REF'  
      8 = 'DK' ;
   value H2L
      1 = 'Not at all'  
      2 = 'A little bit'  
      3 = 'Moderately'  
      4 = 'Quite a bit'  
      5 = 'Extremely'  
      7 = 'REF'  
      8 = 'DK' ;
   value H2M
      1 = 'Not at all'  
      2 = 'A little bit'  
      3 = 'Moderately'  
      4 = 'Quite a bit'  
      5 = 'Extremely'  
      7 = 'REF'  
      8 = 'DK' ;
   value H2N
      1 = 'Not at all'  
      2 = 'A little bit'  
      3 = 'Moderately'  
      4 = 'Quite a bit'  
      5 = 'Extremely'  
      7 = 'REF'  
      8 = 'DK' ;
   value H2O
      1 = 'Not at all'  
      2 = 'A little bit'  
      3 = 'Moderately'  
      4 = 'Quite a bit'  
      5 = 'Extremely'  
      7 = 'REF'  
      8 = 'DK' ;
   value H2P
      1 = 'Not at all'  
      2 = 'A little bit'  
      3 = 'Moderately'  
      4 = 'Quite a bit'  
      5 = 'Extremely'  
      7 = 'REF'  
      8 = 'DK' ;
   value H2Q
      1 = 'Not at all'  
      2 = 'A little bit'  
      3 = 'Moderately'  
      4 = 'Quite a bit'  
      5 = 'Extremely'  
      7 = 'REF'  
      8 = 'DK' ;
   value I1F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value I2F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value I3F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value I4F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value I5F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value I6A
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REF'  
      8 = 'DK' ;
   value I6B
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REF'  
      8 = 'DK' ;
   value I6C
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REF'  
      8 = 'DK' ;
   value I6D
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REF'  
      8 = 'DK' ;
   value I6E
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REF'  
      8 = 'DK' ;
   value I6F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REF'  
      8 = 'DK' ;
   value I6G
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REF'  
      8 = 'DK' ;
   value I6H
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REF'  
      8 = 'DK' ;
   value I7F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value J1A
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REF'  
      8 = 'DK' ;
   value J1B
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REF'  
      8 = 'DK' ;
   value J1C
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REF'  
      8 = 'DK' ;
   value J2F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value J3F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value L1F
      1 = 'Hispanic or Latino, or'  
      2 = 'Not Hispanic or Latino?'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;
   value L3F
      1 = 'MALE'  
      2 = 'FEMALE' ;
   value L4M
      1 = 'January'  
      2 = 'February'  
      3 = 'March'  
      4 = 'April'  
      5 = 'May'  
      6 = 'June'  
      7 = 'July'  
      8 = 'August'  
      9 = 'September'  
      10 = 'October'  
      11 = 'November'  
      12 = 'December' ;
   value L4D
      1 = '1'  
      2 = '2'  
      3 = '3'  
      4 = '4'  
      5 = '5'  
      6 = '6'  
      7 = '7'  
      8 = '8'  
      9 = '9'  
      10 = '10'  
      11 = '11'  
      12 = '12'  
      13 = '13'  
      14 = '14'  
      15 = '15'  
      16 = '16'  
      17 = '17'  
      18 = '18'  
      19 = '19'  
      20 = '20'  
      21 = '21'  
      22 = '22'  
      23 = '23'  
      24 = '24'  
      25 = '25'  
      26 = '26'  
      27 = '27'  
      28 = '28'  
      29 = '29'  
      30 = '30'  
      31 = '31' ;
   value L4Y
      1900 = '1900'  
      1901 = '1901'  
      1902 = '1902'  
      1903 = '1903'  
      1904 = '1904'  
      1905 = '1905'  
      1906 = '1906'  
      1907 = '1907'  
      1908 = '1908'  
      1909 = '1909'  
      1910 = '1910'  
      1911 = '1911'  
      1912 = '1912'  
      1913 = '1913'  
      1914 = '1914'  
      1915 = '1915'  
      1916 = '1916'  
      1917 = '1917'  
      1918 = '1918'  
      1919 = '1919'  
      1920 = '1920'  
      1921 = '1921'  
      1922 = '1922'  
      1923 = '1923'  
      1924 = '1924'  
      1925 = '1925'  
      1926 = '1926'  
      1927 = '1927'  
      1928 = '1928'  
      1929 = '1929'  
      1930 = '1930'  
      1931 = '1931'  
      1932 = '1932'  
      1933 = '1933'  
      1934 = '1934'  
      1935 = '1935'  
      1936 = '1936'  
      1937 = '1937'  
      1938 = '1938'  
      1939 = '1939'  
      1940 = '1940'  
      1941 = '1941'  
      1942 = '1942'  
      1943 = '1943'  
      1944 = '1944'  
      1945 = '1945'  
      1946 = '1946'  
      1947 = '1947'  
      1948 = '1948'  
      1949 = '1949'  
      1950 = '1950'  
      1951 = '1951'  
      1952 = '1952'  
      1953 = '1953'  
      1954 = '1954'  
      1955 = '1955'  
      1956 = '1956'  
      1957 = '1957'  
      1958 = '1958'  
      1959 = '1959'  
      1960 = '1960'  
      1961 = '1961'  
      1962 = '1962'  
      1963 = '1963'  
      1964 = '1964'  
      1965 = '1965'  
      1966 = '1966'  
      1967 = '1967'  
      1968 = '1968'  
      1969 = '1969'  
      1970 = '1970'  
      1971 = '1971'  
      1972 = '1972'  
      1973 = '1973'  
      1974 = '1974'  
      1975 = '1975'  
      1976 = '1976'  
      1977 = '1977'  
      1978 = '1978'  
      1979 = '1979'  
      1980 = '1980'  
      1981 = '1981'  
      1982 = '1982'  
      1983 = '1983'  
      1984 = '1984'  
      1985 = '1985'  
      1986 = '1986'  
      1987 = '1987'  
      1988 = '1988'  
      1989 = '1989'  
      1990 = '1990'  
      1991 = '1991'  
      1992 = '1992'  
      1993 = '1993'  
      1994 = '1994'  
      1995 = '1995'  
      1996 = '1996'  
      1997 = '1997'  
      1998 = '1998'  
      1999 = '1999'  
      2000 = '2000' ;
   value L5F
      1 = 'Nursery School to 6th grade or no schooling'  
      2 = '7th to 12th grade - no diploma'  
      3 = 'High School Graduate/have diploma'  
      4 = 'High School Equivalent (GED) General Equivalency Diploma'  
      5 = 'Some College'  
      6 = 'Technical Certificate'  
      7 = 'Associates Degree'  
      8 = 'Bachelors Degree'  
      9 = 'Masters Degree, Doctorate Degree, or other Professional Degr'  
      97 = 'REFUSED'  
      98 = 'DONíT KNOW' ;
   value L6F
      1 = 'YES'  
      2 = 'NO'  
      7 = 'REFUSED'  
      8 = 'DON"T KNOW' ;

/*Add in additional formats created for the master dataset and/or analysis*/

run;

proc datasets library = library ;
modify master_11122012;
   format   SHELTER SHELTER.;
   format    SITEID SITEID.;
   format       A1A A1A.;
   format       A1B A1B.;
   format       A1C A1C.;
   format       A1D A1D.;
   format       A1E A1E.;
   format       A1F A1F.;
   format       A1G A1G.;
   format       A1H A1H.;
   format       A1I A1I.;
   format       A1J A1J.;
   format       A1K A1K.;
   format       A1L A1L.;
   format       A1M A1M.;
   format       A1N A1N.;
   format       A1O A1O.;
   format       A1P A1P.;
   format        A2 A2F.;
   format        A4 A4F.;
   format       B1A B1A.;
   format       B1B B1B.;
   format       B1C B1C.;
   format       B1D B1D.;
   format       B1E B1E.;
   format       B1F B1F.;
   format       B1G B1G.;
   format       B1H B1H.;
   format       B1I B1I.;
   format       B1J B1J.;
   format       B1K B1K.;
   format       B1L B1L.;
   format       B1M B1M.;
   format       B1N B1N.;
   format       B1O B1O.;
   format       B1P B1P.;
   format       B1Q B1Q.;
   format       B1R B1R.;
   format       B1S B1S.;
   format       C1B C1B.;
   format       C2A C2A.;
   format        C4 C4F.;
   format        C5 C5F.;
   format       C6B C6B.;
   format        C7 C7F.;
   format       C8B C8B.;
   format        D1 D1F.;
   format        D2 D2F.;
   format        D3 D3F.;
   format        D4 D4F.;
   format        D5 D5F.;
   format        D7 D7F.;
   format       D10 D10F.;
   format       D11 D11F.;
   format        E1 E1F.;
   format        E5 E5F.;
   format        E6 E6F.;
   format      E7_1 E7_1F.;
   format      E8_1 E8_1F.;
   format     E10_1 E10_1F.;
   format     E11_1 E11_1F.;
   format     E12_1 E12_1F.;
   format     E13_1 E13_1F.;
   format     E14_1 E14_1F.;
   format     E16_1 E16_1F.;
   format     E17_1 E17_1F.;
   format      E7_2 E7_2F.;
   format      E8_2 E8_2F.;
   format     E10_2 E10_2F.;
   format     E11_2 E11_2F.;
   format     E12_2 E12_2F.;
   format     E13_2 E13_2F.;
   format     E14_2 E14_2F.;
   format     E16_2 E16_2F.;
   format     E17_2 E17_2F.;
   format      E7_3 E7_3F.;
   format      E8_3 E8_3F.;
   format     E10_3 E10_3F.;
   format     E11_3 E11_3F.;
   format     E12_3 E12_3F.;
   format     E13_3 E13_3F.;
   format     E14_3 E14_3F.;
   format     E16_3 E16_3F.;
   format     E17_3 E17_3F.;
   format      E7_4 E7_4F.;
   format      E8_4 E8_4F.;
   format     E10_4 E10_4F.;
   format     E11_4 E11_4F.;
   format     E12_4 E12_4F.;
   format     E13_4 E13_4F.;
   format     E14_4 E14_4F.;
   format     E16_4 E16_4F.;
   format     E17_4 E17_4F.;
   format      E7_5 E7_5F.;
   format      E8_5 E8_5F.;
   format     E10_5 E10_5F.;
   format     E11_5 E11_5F.;
   format     E12_5 E12_5F.;
   format     E13_5 E13_5F.;
   format     E14_5 E14_5F.;
   format     E16_5 E16_5F.;
   format     E17_5 E17_5F.;
   format      E7_6 E7_6F.;
   format      E8_6 E8_6F.;
   format     E10_6 E10_6F.;
   format     E11_6 E11_6F.;
   format     E12_6 E12_6F.;
   format     E13_6 E13_6F.;
   format     E14_6 E14_6F.;
   format     E16_6 E16_6F.;
   format     E17_6 E17_6F.;
   format      E7_7 E7_7F.;
   format      E8_7 E8_7F.;
   format     E10_7 E10_7F.;
   format     E11_7 E11_7F.;
   format     E12_7 E12_7F.;
   format     E13_7 E13_7F.;
   format     E14_7 E14_7F.;
   format     E16_7 E16_7F.;
   format     E17_7 E17_7F.;
   format      E7_8 E7_8F.;
   format      E8_8 E8_8F.;
   format     E10_8 E10_8F.;
   format     E11_8 E11_8F.;
   format     E12_8 E12_8F.;
   format     E13_8 E13_8F.;
   format     E14_8 E14_8F.;
   format     E16_8 E16_8F.;
   format     E17_8 E17_8F.;
   format      E7_9 E7_9F.;
   format      E8_9 E8_9F.;
   format     E10_9 E10_9F.;
   format     E11_9 E11_9F.;
   format     E12_9 E12_9F.;
   format     E13_9 E13_9F.;
   format     E14_9 E14_9F.;
   format     E16_9 E16_9F.;
   format     E17_9 E17_9F.;
   format     E19_1 E19_1F.;
   format     E20_1 E20_1F.;
   format     E22_1 E22_1F.;
   format     E23_1 E23_1F.;
   format     E27_1 E27_1F.;
   format     E19_2 E19_2F.;
   format     E20_2 E20_2F.;
   format     E22_2 E22_2F.;
   format     E23_2 E23_2F.;
   format     E27_2 E27_2F.;
   format     E19_3 E19_3F.;
   format     E20_3 E20_3F.;
   format     E22_3 E22_3F.;
   format     E23_3 E23_3F.;
   format     E27_3 E27_3F.;
   format     E19_4 E19_4F.;
   format     E20_4 E20_4F.;
   format     E22_4 E22_4F.;
   format     E23_4 E23_4F.;
   format     E27_4 E27_4F.;
   format     E19_5 E19_5F.;
   format     E20_5 E20_5F.;
   format     E22_5 E22_5F.;
   format     E23_5 E23_5F.;
   format     E27_5 E27_5F.;
   format     E19_6 E19_6F.;
   format     E20_6 E20_6F.;
   format     E22_6 E22_6F.;
   format     E23_6 E23_6F.;
   format     E27_6 E27_6F.;
   format     E19_7 E19_7F.;
   format     E20_7 E20_7F.;
   format     E22_7 E22_7F.;
   format     E23_7 E23_7F.;
   format     E27_7 E27_7F.;
   format       F1A F1A.;
   format       F1B F1B.;
   format       F1C F1C.;
   format       F1D F1D.;
   format       F1E F1E.;
   format       F1F F1F.;
   format       F1G F1G.;
   format       F1H F1H.;
   format       F1I F1I.;
   format       F1J F1J.;
   format       F1K F1K.;
   format       F1L F1L.;
   format       F1M F1M.;
   format       F1N F1N.;
   format       F1O F1O.;
   format       F1P F1P.;
   format       F2A F2A.;
   format        F3 F3F.;
   format        F4 F4F.;
   format        F5 F5F.;
   format        F6 F6F.;
   format        F7 F7F.;
   format        G1 G1F.;
   format    GENDER GENDER.;
   format        G2 G2F.;
   format       G3A G3A.;
   format       G3B G3B.;
   format       G3C G3C.;
   format       G3D G3D.;
   format       G3E G3E.;
   format       G3F G3F.;
   format       G3G G3G.;
   format       G3H G3H.;
   format       G3I G3I.;
   format       G3J G3J.;
   format       G3K G3K.;
   format       G3L G3L.;
   format       G3M G3M.;
   format       G3N G3N.;
   format       G3O G3O.;
   format       G3P G3P.;
   format       G3Q G3Q.;
   format       H1A H1A.;
   format       H1B H1B.;
   format       H1C H1C.;
   format       H1D H1D.;
   format       H1E H1E.;
   format       H1F H1F.;
   format       H2A H2A.;
   format       H2B H2B.;
   format       H2C H2C.;
   format       H2D H2D.;
   format       H2E H2E.;
   format       H2F H2F.;
   format       H2G H2G.;
   format       H2H H2H.;
   format       H2I H2I.;
   format       H2J H2J.;
   format       H2K H2K.;
   format       H2L H2L.;
   format       H2M H2M.;
   format       H2N H2N.;
   format       H2O H2O.;
   format       H2P H2P.;
   format       H2Q H2Q.;
   format        I1 I1F.;
   format        I2 I2F.;
   format        I3 I3F.;
   format        I4 I4F.;
   format        I5 I5F.;
   format       I6A I6A.;
   format       I6B I6B.;
   format       I6C I6C.;
   format       I6D I6D.;
   format       I6E I6E.;
   format       I6F I6F.;
   format       I6G I6G.;
   format       I6H I6H.;
   format        I7 I7F.;
   format       J1A J1A.;
   format       J1B J1B.;
   format       J1C J1C.;
   format        J2 J2F.;
   format        J3 J3F.;
   format        L1 L1F.;
   format        L3 L3F.;
   format       L4M L4M.;
   format       L4D L4D.;
   format       L4Y L4Y.;
   format        L5 L5F.;
   format        L6 L6F.;
quit;
