Select
	ID_PATRIM,
	CD_SOCIETE,
	NIV_PAT,
	PATRIMOINE_GIM.CD_QUALIF,
	PATRIMOINE_GIM.CD_PATRIM1,
	PATRIMOINE_GIM.CD_PATRIM2,
	PATRIMOINE_GIM.CD_PATRIM3,
	PATRIMOINE_GIM.CD_PATRIM4,
	PATRIMOINE_GIM.CD_PATRIM,  
	isNull(LB_PATRIM1,'') as LB_PATRIM1,
	isNull(LB_PATRIM2,'') as LB_PATRIM2,
	isNull(LB_PATRIM3,'') as LB_PATRIM3,
	isNull(ADRPA_NORU,'') as ADRPA_NORU,
	isNull(ADRPA_CDRU,'') as ADRPA_CDRU,
	isNull(ADRPA_RUE1,'') as ADRPA_RUE1,
	isNull(ADRPA_RUE2,'') as ADRPA_RUE2,
	isNull(ADRPA_LOC,'') as ADRPA_LOC,
	isNull(ADRPA_CP,'') as ADRPA_CP,
	isNull(ADRPA_BD,'') as ADRPA_BD,
	isNull(LB_SECTEUR,'') as LB_LOCALI1,
	isNull(ADRPA_BD,'') as LB_LOCALI2,
	isNull(PATRIMOINE_GIM.NO_INSEE,'') as NO_INSEE,
	isNull(GPS_LONGIT,0) as GPS_LONGIT,
	isNull(GPS_LATIT,0) as GPS_LATIT,
	isNull(LB_ENERGIE,'') as LB_ENERGIE,
 	isNull(LB_ENEREAU,'') as LB_ENEREAU,
	isNull(LB_SECTEUR,'') as LB_SECTEUR,
	isNull(LB_SECTEUR,'') as ANTENNE,
	isNull(ID_GARD,0) as CSGP,
	isNull(LB_NATLOC,'') as LB_NATLOC,
	isNull(CD_ETAGE,'') as CD_ETAGE,
	case
		when TY_CONSTR = 'C' then 'Collectif'
		when TY_CONSTR = 'I' then 'Individuel'
		when TY_CONSTR = 'M' then 'Mixte'
	end as TY_CONSTR,
	isNull(FORMAT(DTD_PAT_R, 'dd/MM/yyyy'), '')  as DTD_PAT_R,
	isNull(ON_ASC,'') as ON_ASC,
	isNull(CD_TYPLOC,'') as CD_TYPLOC,
	isnull(SURF_HAB,0) as SURF_HAB,
	isnull(NO_LOTCOPRO,'') as NO_LOTCOPRO,
	isNull(ON_COPROP,'') as ON_COPROP,
	'' as ON_CAVE,
	'' as DEST_VENTE,
	FORMAT(DT_ALIM, 'dd/MM/yyyy') AS DT_ALIM,
	isNull(NO_QPV,'') as NO_QPV,
	isNull(LB_QPV,'') as LB_QPV,
	-- Nouveaux columns
	isNull(ID_RLLBS,'') as ID_RPLS,
	isNull(ID_INVARIANT,'') as ID_INVFISC,
	FORMAT(DTD_PAT_G, 'dd/MM/yyyy') AS DTD_PAT_G,
	TY_CHAUFF
FROM ACGINFO1.dbo.PATRIMOINE_GIM
where
	CD_ETAT not in ('FG', 'LI')
	and CD_NATLOC not in ('A', 'P', 'PUB', 'T', 'X');
	