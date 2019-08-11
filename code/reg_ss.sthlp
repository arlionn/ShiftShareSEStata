{smcl}
{* *! version 1.00  2aug2019}{...}
{viewerjumpto "Syntax" "reg_ss##syntax"}{...}
{viewerjumpto "Description" "reg_ss##description"}{...}
{viewerjumpto "Options" "reg_ss##options"}{...}
{viewerjumpto "Examples" "reg_ss##examples"}{...}
{viewerjumpto "Author" "reg_ss##author"}{...}
{viewerjumpto "Referejce" "reg_ss##reference"}{...}
{title:Title}

{p2colset 5 18 24 2}{...}
{p2col :{hi: reg_ss} {hline 2}}Computes confidence intervals, standard errors, and p-values in a linear regression in which the regressor of interest has a shift-share structure. Several different inference methods can be computed.
{p2colreset}{...}

{marker syntax}{title:Syntax}

{p 8 15 2}
{cmd:reg_ss}
{depvar} 
{cmd:,} {opt shiftshare_var(varlist)} 
		{opt share_varlist(varlist)}  {opt alpha}
		[control_varlist(varlist) weight_var(varlist) akmtype beta0 path_cluster cluster_var(varlist)]

{marker Options}{...}
{synoptset 29 tabbed}{...}
{synopthdr : Options}
{synoptline}
{syntab:Model}
{p2coldent:* {opt shiftshare_var(varlist)}} Shift-share covariate. {p_end}
{p2coldent:* {opt share_varlist(varlist)}} List of variables containing the sector shares. Each variable indicates the shares corresponding to a sector for all regions. 
Varlist must contain as many variables as there are sectors in the analysis. {p_end}
{p2coldent:* {opt alpha}} Determines confidence level of reported confidence intervals, which will have coverate 1-alpha. Its default value  is 0.05. {p_end}

{synoptline}
{syntab:Other}
{synopt :{opt control_varlist(varlist)}} List of control variables to be included. {p_end}
{synopt :{opt weight_var(varlist)}} Weights to be used in the fitting process. If specified, weighted least squares are used; otherwise, ordinary least squares are used. {p_end}
{synopt :{opt akmtype}} Specifies which inference methods to use. It must take value 0 or 1. If it equals 1, "reg_ss" applies the AKM inference procedure described in 
Adão, Kolesár, and Morales (2019). If it equals 0, "reg_ss" applies the AKM0 inference procedure described in Adão, Kolesár, and Morales (2019). If it equals 0, the 
reported standard error corresponds to the normalized standard error, given by the length of the corresponding confidence interval divided by 2*z(1-alpha/2). The default akmtype value 
is 1. {p_end}
{synopt :{opt beta0 }} Null that is tested when "akmtype" equals 0 (only affects reported p-values). {p_end}
{synopt :{opt path_cluster}} The path to the .dta file which stores the cluster information corresponding to each sector. Provide this if you want to compute 
AKM or AKM0 confidence intervals and p-values accounting for sectoral clusters. {p_end}
{synopt :{opt cluster_var}} The variable name of the cluster variable in the .dta file storing the cluster information corresponding to each sector. The order of 
the sectors in this .dta file should be the same as the order of the sectors in the "varlist" containing the sector shares (the "share_varlist").{p_end}

{marker examples}{...}
{title:Examples}
You may download the needed data at https://github.com/zhangxiang0822/BartikSEStata/tree/master/data

We use a subset of data from Autor, Dorn, and Hanson (2013, ADH) to illustrate the confidence intervals implemented in this package. Variables in ADH dataset are listed below.
- d_sh_empl: Change in the share of working-age population
- d_sh_empl_mfg: Change in the share of working-age population employed in manufacturing.
- d_sh_empl_nmfg: Change in the share of working-age population employed in non-manufacturing.
- d_tradeusch_pw: Change in sectoral U.S. imports from China normalized by U.S. total employment in the corresponding sector, aggregated to regional level. This is the variable of interest in ADH.
- d_tradeotch_pw_lag: Change in sectoral imports from China by rest of the world, aggregated to regional level.
- emp_share1 - emp_share770: The local employment share for the first to the 770th sector.
- weight: Regression weights corresponding to start of period CZ share of national populations.
- state: State FIPS code.
- czone: CZ number.
- t2: Indicator for 2000-2007.
- l_shind_manuf_cbp: Employment share of manufacturing.
- l_sh_popedu_c: percent population college-educated.
- l_sh_popfborn: percent population foreign-born.
- l_sh_empl_f: percent employment among women.
- l_sh_routine33: percent employment in routine occupations.
- l_task_outsource: Offshorability index of occupations in CZ.

Example 1: AKM, no cluster
{phang2}{cmd:. 	use "data/ADH_derived.dta", clear }{p_end}
{phang2}{cmd:. 	local control_varlist t2 l_shind_manuf_cbp reg_encen reg_escen reg_midatl reg_mount reg_pacif reg_satl reg_wncen reg_wscen l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource }{p_end}
{phang2}{cmd:.	reg_ss d_sh_empl_mfg, endogenous_var(d_tradeusch_pw) shiftshare_iv(d_tradeotch_pw_lag) control_varlist(`control_varlist') share_varlist(emp_share1-emp_share770) weight_var(weight) alpha(0.05) akmtype(1) firststage(1)}{p_end}

Example 2: AKM0, no cluster
Be sure to put "sector_derived.dta" to your local path
{phang2}{cmd:. 	use "data/ADH_derived.dta", clear }{p_end}
{phang2}{cmd:. 	local control_varlist t2 l_shind_manuf_cbp reg_encen reg_escen reg_midatl reg_mount reg_pacif reg_satl reg_wncen reg_wscen l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource }{p_end}
{phang2}{cmd:. 	local local_path "data/sector_derived.dta"}{p_end}
{phang2}{cmd:.	reg_ss d_sh_empl_mfg, endogenous_var(d_tradeusch_pw) shiftshare_iv(d_tradeotch_pw_lag) control_varlist(`control_varlist') share_varlist(emp_share*) weight_var(weight) akmtype(0)}

Example 3: AKM, with cluster
{phang2}{cmd:. 	use "data/ADH_derived.dta", clear }{p_end}
{phang2}{cmd:. 	local control_varlist t2 l_shind_manuf_cbp reg_encen reg_escen reg_midatl reg_mount reg_pacif reg_satl reg_wncen reg_wscen l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource }{p_end}
{phang2}{cmd:. 	local local_path "data/sector_derived.dta"}{p_end}
{phang2}{cmd:.	reg_ss d_sh_empl, shiftshare_var(d_tradeotch_pw_lag) control_varlist(`control_varlist') share_varlist(emp_share1-emp_share770) weight_var(weight) alpha(0.05) akmtype(1) path_cluster("data/sector_derived.dta") cluster_var(sec_3d) }

Example 4: AKM0, with cluster
Be sure to put "sector_derived.dta" to your local path
{phang2}{cmd:. 	use "data/ADH_derived.dta", clear }{p_end}
{phang2}{cmd:. 	local control_varlist t2 l_shind_manuf_cbp reg_encen reg_escen reg_midatl reg_mount reg_pacif reg_satl reg_wncen reg_wscen l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource }{p_end}
{phang2}{cmd:. 	local local_path "data/sector_derived.dta"}{p_end}
{phang2}{cmd:.	reg_ss d_sh_empl, shiftshare_var(d_tradeotch_pw_lag) control_varlist(`control_varlist') share_varlist(emp_share1-emp_share770) weight_var(weight) alpha(0.05) akmtype(0) path_cluster("data/sector_derived.dta") cluster_var(sec_3d) }

For more examples, please see "https://github.com/zhangxiang0822/BartikSEStata/blob/master/code/ADHapplication.do".

{marker author}{...}
{title:Bug Reporting}
{pstd}  Please, submit bugs, comments, and suggestions to the Github repository at "https://github.com/zhangxiang0822/BartikSEStata". You are free to open an issue.

			 
{marker author}{...}
{title:Author}
{pstd}Xiang Zhang{p_end}
{pstd}xiangzhang@princeton.edu{p_end}

{marker reference}{...}
{title:Reference}
{pstd} Adão, Rodrigo, Michal Kolesár, and Eduardo Morales (2019) “Shift-share Designs: Theory and Inference”. Quarterly Journal of Economics, forthcoming. {p_end}

{pstd} David, H., David Dorn, and Gordon H. Hanson (2013) "The China Syndrome: Local Llabor Market Effects of Import Ccompetition in the United States." American Economic Review, 103, no. 6,  (2013): 2121-2168.
 {p_end}

{pstd} You may find a MATLAB version of this code at "https://github.com/kolesarm/BartikSEMatlab". {p_end} 
{pstd} You may find a R version of this code at "https://github.com/kolesarm/BartikSE". {p_end} 