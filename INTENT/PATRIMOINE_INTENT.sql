	Select 
'3' as HO1,
	'Proximité' as Direction,
	isNull(CD_SECTEUR,'') as ESO1,
	isNull(LB_SECTEUR,'') as Agence,
	isNull (CD_PATRIM1,'') as HP1,
	isNull(LB_PATRIM1,'') as Groupe,
	isNull (CD_PATRIM2,'') as HP2,
	isNull(LB_PATRIM2,'') as Batiment,
	isNull (CD_PATRIM3,'') as HP3,
	isNull(LB_PATRIM3,'') as Entrée,
	isNull (CD_PATRIM4,'') as UG,
	isNull(CD_PATRIM,'') as Local,
	PATRIMOINE_GIM.CD_PATRIM as intent_reference,
	PATRIMOINE_GIM.CD_QUALIF as intent_type,
	CONCAT (ADRPA_NORU, ' ',ADRPA_RUE1) as intent_adress_way,
	isNull(ADRPA_RUE2,'') as intent_address_complement,
	isNull(ADRPA_CP,'') as intent_zip,
	isNull(ADRPA_LOC,'') as intent_city,
	'FRANCE' as intent_adress_country,
	isnull(SURF_HAB,0) as intent_surface,
	isNull(GPS_LATIT,0) as intent_latitude,
	isNull(GPS_LONGIT,0) as intent_longitude,
	FORMAT(DTD_PAT_G, 'dd/MM/yyyy') AS intent_commissioning_dat,
	isNull(ON_ADPTHAN,'N') as Logement_adapte,
	isNull(LB_ADPTHAN,'') as Adaptation_HSS,
	case
		when TY_CHAUFF = 'N' then 'Non chauffé'
		when TY_CHAUFF = 'I' then 'Individuel'
		when TY_CHAUFF = 'M' then 'Mixte'
		when TY_CHAUFF = ' ' then ' '
	end as Chauffage,
	isNull(LB_ENERGIE,'') as Energie,
 	isNull(LB_ENEREAU,'') as Energie_eau_Chaude,
	isNull(ID_GARD,0) as Code_GS,
	isNull(CD_ETAGE,0) as Etage,
	isNull(NIV_ETAGE,0) as NIV_ETAGE,
	isNull(LB_NATLOC,'') as Nature_Logement,
	case
		when TY_CONSTR = 'C' then 'Collectif'
		when TY_CONSTR = 'I' then 'Individuel'
		when TY_CONSTR = 'M' then 'Mixte'
	end as Type_construction,
	isNull(FORMAT(DTD_PAT_R, 'dd/MM/yyyy'), '') as Date_construction,
	isNull(ON_ASC,'') as Ascenseur,
	isNull(CD_TYPLOC,'') as Type_logement,
	isNull(ON_COPROP,'') as Copropriété,
	isNull(NO_QPV,' ') as QPV,
	isNull(LB_QPV,'') as Nom_QPV,
	CONCAT ('BEGIN:VCARD\n\nVERSION:3\r\nFN;CHARSET=UTF-8:', NOM_GARD, ' ',PRE_GARD, '\r\nTEL;TYPE=WORK,VOICE:0677305238\r\nTEL;TYPE=HOME,VOICE:0467847563\r\nADR;TYPE=WORK:165 Avenue de Bretagne;59000;LILLE;France\r\nROLE;CHARSET=UTF-8:Gardien\r\nEMAIL;CHARSET=UTF-8;TYPE=WORK,INTERNET:m.marest@herault-logement.fr\r\nEND:VCARD\r\nBEGIN:VCARD\n\nVERSION:3\r\nFN;CHARSET=UTF-8:Marie FRANCE\r\nN;CHARSET=UTF-8:FRANCE ;Marie\r\nTEL;TYPE=WORK,VOICE:0709243902\r\nTEL;TYPE=HOME,VOICE:0385874498\r\nADR;TYPE=WORK:165 Avenue du Bretagne;59000;LILLE;France\r\nROLE;CHARSET=UTF-8:Locataire 2\r\nEMAIL;CHARSET=UTF-8;TYPE=WORK,INTERNET:mfrance@internet.fr\r\nEND:VCARD') as intent_contactGS
	FROM ACGINFO1.dbo.PATRIMOINE_GIM
 where	CD_ETAT not in ('FG', 'LI')
 and CD_NATLOC not in ('A', 'P', 'PUB', 'T', 'X');