**************************************************************************
** Demographic research 2022 **
** "Do tenants suffer from status syndrome. Homeownership, norms and suicide in Belgium" **
** Authors: Joan Damiens and Christine Schnor **
** Do-file comes with a codebook, but no dataset nor sample, due to sensitive data **

****************************************************************************
****************************************************************************

** 1/ Construction of the database **********
** 2/ Descriptive results *******************
** 3/ Multivariate analyses *****************
** 4/ Appendix ******************************


******1/ Construction of the database**********

****** a) death certificates
** To measure suicide death, we will rely on the death certificates
** and specifically on the causes of death that it includes
** We will use the ICD-10 to locate suicides (X60-X84)
** suicide is the suicide indicator (0 if not suicide, 1 if suicide)
use deces.dta, clear
capture drop suicide
gen suicide=0
replace suicide=1 if CD_COD_IMDT >="X60" & CD_COD_IMDT< "X85" //immediate cod
replace suicide =1 if CD_COD_EXT >="X60" & CD_COD_EXT< "X85" //external cod
replace suicide =1 if CD_COD_INT1 >="X60" & CD_COD_INT1< "X85" //1st intermediate cod
replace suicide =1 if CD_COD_INT2 >="X60" & CD_COD_INT2< "X85" //2nd intermediate cod
replace suicide =1 if CD_UCOD >="X60" & CD_UCOD< "X85" //initial/underlying cod
replace suicide =1 if CD_COD_ASS1 >="X60" & CD_COD_ASS1< "X85" //1st associate cod
replace suicide =1 if CD_COD_ASS2 >="X60" & CD_COD_ASS2< "X85" //2nd associate cod
replace suicide =1 if CD_COD_ASS3 >="X60" & CD_COD_ASS3< "X85" //3rd associate cod

** I generate a variable DEATHY to get the year of death from the date of death (DT_DTH)
gen DEATHY==year(DT_DTH)


keep codern suicide DEATHY sde02
save decesshort.dta

****** b) Census and national register
** Census will provide socioeconomic and housing-related information about each individual.
** National register will provide demographic information about each individual. 
** Due to the sensitivity of the data source, only previously recoded variables will be presented; 
** See codebook for more information about the databases.
**Note : codern is the unique individual identifier

use Census2001.dta // 2001 Census (data collected in November 2001)
merge 1:1 codern using NR2002.dta // National Register in 2001

save base.dta

drop _merge
merge 1:1 codern using decesshort.dta // I merge information about suicide, using the identifier (codern)


******2/ descriptive results **********

** I want to focus on  the 25 to 69 year-old population only
** I create a filter for this population
gen adult2=0
replace adult2=1 if age_2001>24 & age_2001<70


** Table A-1 :  Observations and proportion of homeowners according to marital situation and parenthood
** StatOcci2001 : Housing tenure (Owner, Tenant)
** couple : couple status (married, cohabiting, single)
** parent = parental status (lives with children, does not live with children)
tab couple StatOcc2001 if adult2==1 & sexe2001==1, miss
tab couple StatOcc2001 if adult2==1 & sexe2001==2, miss
tab parent StatOcc2001 if adult2==1 & sexe2001==1, miss
tab parent StatOcc2001 if adult2==1 & sexe2001==2, miss

** Figure A-1  Percentage of owners per age in Belgium, population aged 2069, 2001.
tab age01 StatOcc2001 if age>19 & age<70 & sexe2001==1, miss
tab age01 StatOcc2001 if age>19 & age<70 & sexe2001==2, miss

***** suicide indicators ***
** I create an indicator to measure suicides in 2002 (survival or death from another cause, vs. suicide)
gen sde02=0
replace sde02=1 if suicide==1 & DEATHY==2002

** I create another indiciator to measure suicides and other deaths in 2002 (survival vs. other cause of death vs. suicide)
gen sdeoth02=0
replace sdeoth02=1 if DEATHY==2002 & suicide==1
replace sdeoth02=2 if DEATHY==2002 & suicide==0
lab def sdeoth02 0"no" 1"suicide" 2"other"
lab val sdeoth02 sdeoth02

** Figure 1  Suicide rates (per 1,000) per age, male and female population aged 2069, 2002. 
tab age01 sde02 if sexe2001==1, miss
tab age01 sde02 if sexe2001==2, miss

** Table A-3  Number of suicides and total number of 25 to 69 year-old men and women according to their household composition
tab couple sdeoth02 if adult2==1 sexe==1, miss
tab couple sdeoth02 if adult2==1 sexe==2, miss
tab parent sdeoth02 if adult2==1 sexe==1, miss
tab parent sdeoth02 if adult2==1 sexe==2, miss

*ownership
tab  age01 StatOcc2001 if sexe2001==1
tab  age01 StatOcc2001 if sexe2001==2


******3/ multivariate analysis **********


** MULTINOMIAL LOGIT MODELS  
*Model 1 (Table 1)
mlogit sdeoth02 i.StatOcc2001 age_2001 agesq if sexe2001==1 & adult2==1
mlogit sdeoth02 i.StatOcc2001 age_2001 agesq if sexe2001==2 & adult2==1

*Model 2 (Table 1)
mlogit sdeoth02 i.StatOcc2001 i.SDB2001 i.Chauff2001 densité2001 age_2001 agesq i.typemenage2001 i.neciv01 i.region2001 i.area2001 i.nation2001 i.Q2 i.éducation2001 i.job2001  if sexe2001==1 & adult2==1 
mlogit sdeoth02 i.StatOcc2001 i.SDB2001 i.Chauff2001 densité2001 age_2001 agesq i.typemenage2001 i.neciv01 i.region2001 i.area2001 i.nation2001 i.Q2 i.éducation2001 i.job2001 if sexe2001==2 & adult

*Model 3 (Table A-4)
mlogit sdeoth02 i.StatOcc2001 i.SDB2001 i.Chauff2001 densité2001 age_2001 agesq i.typemenage2001 i.neciv01 i.region2001 i.area2001 i.nation2001 i.Q2 i.éducation2001 i.job2001  if sexe2001==1 & adult2==1 
mlogit sdeoth02 i.StatOcc2001 i.SDB2001 i.Chauff2001 densité2001 age_2001 agesq i.typemenage2001 i.neciv01 i.region2001 i.area2001 i.nation2001 i.Q2 i.éducation2001 i.job2001 if sexe2001==2 & adult2==1

**interaction by age (Figure 2 for suicide & Figure A-6 [a + b] for other causes of death)
mlogit sdeoth02 i.StatOcc2001##c.age_2001##c.age_2001 i.SDB2001 i.Chauff2001 densité2001 i.hhtype2001 i.neciv01 i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==1 & adult2==1
margins StatOcc2001, at(age_2001=(20(1)69)) //a
mlogit sdeoth02 i.StatOcc2001##c.age_2001##c.age_2001 i.SDB2001 i.Chauff2001 densité2001 i.hhtype2001 i.neciv01 i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==2 & adult2==1
margins StatOcc2001, at(age_2001=(20(1)69)) //b

** interaction by marital status (Figure 3 for suicide & Figure A-6 [c to h] for other causes of death)
mlogit sdeoth02 i.StatOcc2001##c.age_2001##c.age_2001 i.SDB2001 i.Chauff2001 densité2001 i.parent i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==1 & adult2==1 & couple==1
margins StatOcc2001, at(age_2001=(20(1)69)) //a
mlogit sdeoth02 i.StatOcc2001##c.age_2001##c.age_2001 i.SDB2001 i.Chauff2001 densité2001 i.parent i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==2 & adult2==1 & couple==1
margins StatOcc2001, at(age_2001=(20(1)69)) //b

mlogit sdeoth02 i.StatOcc2001##c.age_2001##c.age_2001 i.SDB2001 i.Chauff2001 densité2001 i.parent i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==1 & adult2==1 & couple==2
margins StatOcc2001, at(age_2001=(20(1)69)) //c 
mlogit sdeoth02 i.StatOcc2001##c.age_2001##c.age_2001 i.SDB2001 i.Chauff2001 densité2001 i.parent i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==2 & adult2==1 & couple==2
margins StatOcc2001, at(age_2001=(20(1)69)) //d

mlogit sdeoth02 i.StatOcc2001##c.age_2001##c.age_2001 i.SDB2001 i.Chauff2001 densité2001 i.parent i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==1 & adult2==1 & couple==0
margins StatOcc2001, at(age_2001=(20(1)69)) //e
mlogit sdeoth02 i.StatOcc2001##c.age_2001##c.age_2001 i.SDB2001 i.Chauff2001 densité2001 i.parent i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==2 & adult2==1 & couple==0
margins StatOcc2001, at(age_2001=(20(1)69)) //f


** by parental status (presence of children in the hh) (Figure 4 for suicide & Figure A-6 [i to l] for other causes of death)
mlogit sdeoth02 i.StatOcc2001##c.age_2001##c.age_2001 i.SDB2001 i.Chauff2001 densité2001 i.parent i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==1 & adult2==1 & parent==0
margins StatOcc2001, at(age_2001=(20(1)69)) //a
mlogit sdeoth02 i.StatOcc2001##c.age_2001##c.age_2001 i.SDB2001 i.Chauff2001 densité2001 i.parent i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==2 & adult2==1 & parent==0
margins StatOcc2001, at(age_2001=(20(1)69))//b

mlogit sdeoth02 i.StatOcc2001##c.age_2001##c.age_2001 i.SDB2001 i.Chauff2001 densité2001 i.parent i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==1 & adult2==1 & parent==1
margins StatOcc2001, at(age_2001=(20(1)69)) //c
mlogit sdeoth02 i.StatOcc2001##c.age_2001##c.age_2001 i.SDB2001 i.Chauff2001 densité2001 i.parent i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==2 & adult2==1 & parent==1
margins StatOcc2001, at(age_2001=(20(1)69)) //d




******4/ Appendix **********

**** a) interactions between housing tenure and other characteristics : region, nationality, education, occupational category.

** Figure A-2  Predicted probabilities of suicide for owners and tenants according to the region of residence
** I recode the region indicator, to group Wallonia and Brussels together
** interaction effects with covariates
capture drop region02
gen region02=1 if region2001==1
replace region02=2 if inlist(region2001, 2, 3)
lab def region02 1"Flanders" 2"Wal-Bsl"
lab val region02 region02

** I estimate the predicted probabilities of suicide according to housing tenure and the region (Flanders vs. Wallonia/Brussels)
mlogit sdeoth02 i.StatOcc2001##i.region02 i.SDB2001 i.Chauff2001 densité2001 age_2001 agesq i.typemenage2001 i.neciv01 i.area2001 i.nation2001 i.éducation2001 i.job2001  if sexe2001==1 & adult2==1, rrr
margins i.StatOcc2001#i.region02 //a
mlogit sdeoth02 i.StatOcc2001##i.region02 i.SDB2001 i.Chauff2001 densité2001 age_2001 agesq i.typemenage2001 i.neciv01 i.area2001 i.nation2001 i.éducation2001 i.job2001  if sexe2001==2 & adult2==1, rrr
margins i.StatOcc2001#i.region02 //b


** Figure A-3 - Predicted probabilities of suicide in 2002 for owners and tenants according to the nationality (Belgian, other European, non-european)
mlogit sdeoth02 i.StatOcc2001##i.nation2001 i.SDB2001 i.Chauff2001 densité2001 age_2001 agesq i.typemenage2001 i.neciv01 i.area2001 i.region2001 i.éducation2001 i.job2001  if sexe2001==1 & adult2==1, rrr
margins i.StatOcc2001#i.nation2001 //a
mlogit sdeoth02 i.StatOcc2001##i.nation2001 i.SDB2001 i.Chauff2001 densité2001 age_2001 agesq i.typemenage2001 i.neciv01 i.area2001 i.region2001 i.éducation2001 i.job2001  if sexe2001==2 & adult2==1, rrr
margins i.StatOcc2001#i.nation2001 //b


** Figure A-4 - Predicted probabilities of suicide in 2002 for owners and tenants according to the educational level (primary, lower secondary, higher secondary, higher education)
mlogit sdeoth02 i.StatOcc2001##i.éducation2001 i.SDB2001 i.Chauff2001 densité2001 age_2001 agesq i.typemenage2001 i.neciv01 i.area2001 i.region2001 i.nation2001 i.job2001  if sexe2001==1 & adult2==1, rrr
margins i.StatOcc2001#i.éducation2001 //a
mlogit sdeoth02 i.StatOcc2001##i.éducation2001 i.SDB2001 i.Chauff2001 densité2001 age_2001 agesq i.typemenage2001 i.neciv01 i.area2001 i.region2001 i.nation2001 i.job2001  if sexe2001==2 & adult2==1, rrr
margins i.StatOcc2001#i.éducation2001 //b

** Figure A-5 - Predicted probabilities of suicide in 2002 for owners and tenants according to the occupational status (Unemployed, inactive, permanent contract worker, temporary contract worker, liberal worker)
mlogit sdeoth02 i.StatOcc2001##i.job2001 i.SDB2001 i.Chauff2001 densité2001 age_2001 agesq i.typemenage2001 i.neciv01 i.area2001 i.region2001 i.nation2001 i.éducation2001  if sexe2001==1 & adult2==1, rrr
margins i.StatOcc2001#i.job2001 //a
mlogit sdeoth02 i.StatOcc2001##i.job2001 i.SDB2001 i.Chauff2001 densité2001 age_2001 agesq i.typemenage2001 i.neciv01 i.area2001 i.region2001 i.nation2001 i.éducation2001 if sexe2001==2 & adult2==1, rrr
margins i.StatOcc2001#i.job2001 //b

save, replace

**** b)Table A-2  Analysis of variance of suicide rates in 2002 according to subjective health level reported in the 2001 census.
mean  sde02, over(Q2)
oneway sde02 Q2, tabulate

**** c) Methodological appendix.

** i. Robustiness check with 2002-2003

use Census2001.dta, clear// 2001 Census (data collected in November 2001)
merge 1:1 codern using NR2002.dta // National Register in 2001
append using NR2003.dta

drop year==2002 if DEATHY!=2002
drop year==2003 if DEATHY==2002

drop _merge
merge 1:1 codern using decesshort.dta // I merge information about suicide, using the identifier (codern)

save base0203.dta

***** suicide indicators ***
** I create an indicator to measure suicides in 2002 and 2003 (survival or death from another cause, vs. suicide)
gen sde0203=0
replace sde0203=1 if suicide==1 & inlist(DEATHY, 2002, 2003)

** I create another indiciator to measure suicides and other deaths in 2002 and 2003 (survival vs. other cause of death vs. suicide)
gen sdeoth0203=0
replace sdeoth0203=1 if inlist(DEATHY, 2002, 2003) & suicide==1
replace sdeoth0203=2 if inlist(DEATHY, 2002, 2003) & suicide==0
lab def sdeoth0203 0"no" 1"suicide" 2"other"
lab val sdeoth0203 sdeoth0203

** Figure A-M1. Logistic regression on the risk of suicide in 2002 and 2003, predicted probabilities
** interaction by age
logistic sdeoth0203 i.StatOcc2001##c.age_2001##c.age_2001 i.SDB2001 i.Chauff2001 densité2001 i.typemenage2001 i.neciv01 i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==1 & adult2==1
margins StatOcc2001, at(age_2001=(20(1)69)) //a
logistic sdeoth0203 i.StatOcc2001##c.age_2001##c.age_2001 i.SDB2001 i.Chauff2001 densité2001 i.typemenage2001 i.neciv01 i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==2 & adult2==1
margins StatOcc2001, at(age_2001=(20(1)69)) //b

** by marital status
logistic sdeoth0203 i.StatOcc2001##c.age_2001##c.age_2001 i.SDB2001 i.Chauff2001 densité2001 i.parent i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==1 & adult2==1 & couple==1
margins StatOcc2001, at(age_2001=(20(1)69)) //c
logistic sdeoth0203 i.StatOcc2001##c.age_2001##c.age_2001 i.SDB2001 i.Chauff2001 densité2001 i.parent i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==2 & adult2==1 & couple==1
margins StatOcc2001, at(age_2001=(20(1)69)) //d

logistic sdeoth0203 i.StatOcc2001##c.age_2001##c.age_2001 i.SDB2001 i.Chauff2001 densité2001 i.parent i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==1 & adult2==1 & couple==2
margins StatOcc2001, at(age_2001=(20(1)69)) //e
logistic sdeoth0203 i.StatOcc2001##c.age_2001##c.age_2001 i.SDB2001 i.Chauff2001 densité2001 i.parent i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==2 & adult2==1 & couple==2
margins StatOcc2001, at(age_2001=(20(1)69)) //f

logistic sdeoth0203 i.StatOcc2001##c.age_2001##c.age_2001 i.SDB2001 i.Chauff2001 densité2001 i.parent i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==1 & adult2==1 & couple==0
margins StatOcc2001, at(age_2001=(20(1)69)) //g
logistic sdeoth0203 i.StatOcc2001##c.age_2001##c.age_2001 i.SDB2001 i.Chauff2001 densité2001 i.parent i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==2 & adult2==1 & couple==0
margins StatOcc2001, at(age_2001=(20(1)69)) //h

** by parental status (presence of children in the hh)
logistic sdeoth0203 i.StatOcc2001##c.age_2001##c.age_2001 i.SDB2001 i.Chauff2001 densité2001 i.parent i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==1 & adult2==1 & parent==1
margins StatOcc2001, at(age_2001=(20(1)69)) //i
logistic sdeoth0203 i.StatOcc2001##c.age_2001##c.age_2001 i.SDB2001 i.Chauff2001 densité2001 i.parent i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==2 & adult2==1 & parent==1
margins StatOcc2001, at(age_2001=(20(1)69)) //j

logistic sdeoth0203 i.StatOcc2001##c.age_2001##c.age_2001 i.SDB2001 i.Chauff2001 densité2001 i.parent i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==1 & adult2==1 & parent==0
margins StatOcc2001, at(age_2001=(20(1)69)) //k
logistic sdeoth0203 i.StatOcc2001##c.age_2001##c.age_2001 i.SDB2001 i.Chauff2001 densité2001 i.parent i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==2 & adult2==1 & parent==0
margins StatOcc2001, at(age_2001=(20(1)69)) //l

save, replace

** ii. Robustiness check with age as a 5-year categorical variable
use base.dta, clear

** I generate a variable to create 5-year age groups (agecat2001)
capture drop agecat2001
gen agecat2001=.
replace agecat2001=20 if age_2001>=20 & age_2001<=24
replace agecat2001=25 if age_2001>=25 & age_2001<=29
replace agecat2001=30 if age_2001>=30 & age_2001<=34
replace agecat2001=35 if age_2001>=35 & age_2001<=39
replace agecat2001=40 if age_2001>=40 & age_2001<=44
replace agecat2001=45 if age_2001>=45 & age_2001<=49
replace agecat2001=50 if age_2001>=50 & age_2001<=54
replace agecat2001=55 if age_2001>=55 & age_2001<=59
replace agecat2001=60 if age_2001>=60 & age_2001<=64
replace agecat2001=65 if age_2001>=65 & age_2001<=69

** Figure A-M2. Logistic regression on the risk of suicide in 2002, with age as categorical variable, predicted probabilities.
** interaction by age 
logistic sdeoth02 i.StatOcc2001##i.agecat2001 i.SDB2001 i.Chauff2001 densité2001 i.typemenage2001 i.neciv01 i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==1 & adult2==1
margins StatOcc2001, at(agecat2001=(25 30 35 40 45 50 55 60 65)) //a
logistic sdeoth02 i.StatOcc2001##i.agecat2001 i.SDB2001 i.Chauff2001 densité2001 i.typemenage2001 i.neciv01 i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==2 & adult2==1
margins StatOcc2001, at(agecat2001=(25 30 35 40 45 50 55 60 65)) //b

 * Interaction by couple status
logistic sdeoth02 i.StatOcc2001##i.agecat2001 i.SDB2001 i.Chauff2001 densité2001 i.parent i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==1 & couple==1 & adult2==1
margins StatOcc2001, at(agecat2001=(25 30 35 40 45 50 55 60 65)) //c
logistic suicide0203 i.StatOcc2001##i.agecat2001 i.SDB2001 i.Chauff2001 densité2001 i.parent i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==2 & couple==1 & adult2==1
margins StatOcc2001, at(agecat2001=(25 30 35 40 45 50 55 60 65)) //d

logistic sdeoth02 i.StatOcc2001##i.agecat2001 i.SDB2001 i.Chauff2001 densité2001 i.parent i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==1 & couple==2 & adult2==1
margins StatOcc2001, at(agecat2001=(25 30 35 40 45 50 55 60 65)) //e
logistic sdeoth02 i.StatOcc2001##i.agecat2001 i.SDB2001 i.Chauff2001 densité2001 i.parent i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==2 & couple==2 & adult2==1
margins StatOcc2001, at(agecat2001=(25 30 35 40 45 50 55 60 65)) //f

logistic sdeoth02 i.StatOcc2001##i.agecat2001 i.SDB2001 i.Chauff2001 densité2001 i.parent i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==1 & couple==0 & adult2==1
margins StatOcc2001, at(agecat2001=(25 30 35 40 45 50 55 60 65)) //g
logistic suicide0203 i.StatOcc2001##i.agecat2001 i.SDB2001 i.Chauff2001 densité2001 i.parent i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==2 & couple==0 & adult2==1
margins StatOcc2001, at(agecat2001=(25 30 35 40 45 50 55 60 65)) //h
 

** Interaction by parental status (children living at home or not)
 logistic suicide0203 i.StatOcc2001##i.agecat2001 i.SDB2001 i.Chauff2001 densité2001 i.couple i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==1 & parent==0 & adult2==1
margins StatOcc2001, at(agecat2001=(25 30 35 40 45 50 55 60 65)) //i
logistic suicide0203 i.StatOcc2001##i.agecat2001 i.SDB2001 i.Chauff2001 densité2001 i.couple i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==2 & parent==0 & adult2==1
margins StatOcc2001, at(agecat2001=(25 30 35 40 45 50 55 60 65)) //j

logistic sdeoth02 i.StatOcc2001##i.agecat2001 i.SDB2001 i.Chauff2001 densité2001 i.couple i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==1 & parent==1 & adult2==1
margins StatOcc2001, at(agecat2001=(25 30 35 40 45 50 55 60 65)) //k
logistic suicide0203 i.StatOcc2001##i.agecat2001 i.SDB2001 i.Chauff2001 densité2001 i.couple i.region2001 i.area2001 i.nation2001 i.éducation2001 i.job2001 if sexe2001==2 & parent==1 & adult2==1
margins StatOcc2001, at(agecat2001=(25 30 35 40 45 50 55 60 65)) //l


save, replace


