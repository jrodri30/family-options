/**************************************************************//*

Program:
Title: Explore missing data for focal children
Programmer: Scott Brown
Date Created: 05/22/2014
Last Update: 05/22/2014

Input files: 	fam18m.s02_18mo_fc_whome
				fam18m.s02_18mo_fc_base
Output files: 

Purpose:
-use screener questions and other data to explore missing data rates




*//**************************************************************/

*set file directory name;
LIBNAME fam18m "E:\Family Options\Data\02_18MonthData";
%LET expdir="E:\Family Options\Data\02_18MonthData";

OPTIONS FMTSEARCH=(fam18m) NOFMTERR;
