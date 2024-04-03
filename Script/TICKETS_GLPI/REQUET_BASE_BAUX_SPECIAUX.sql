SELECT
    ISNULL(pg.LB_SECTEUR, '') as 'Agence',
	ISNULL(pg.CD_PATRIM, '') as 'Référence patrimoine',
    ISNULL(pg.LB_PATRIM1, '') as 'nom du groupe',
    CONCAT(pg.ADRPA_NORU, ' ', pg.ADRPA_RUE1) as 'address_way',
    ISNULL(pg.ADRPA_RUE2, '') as 'address_complement',
    ISNULL(pg.ADRPA_CP, '') as 'address_zip',
    ISNULL(pg.ADRPA_LOC, '') as 'address_city',
    isNull(CONVERT(VARCHAR(10), pg.DTD_PAT_G, 120), '') as 'Date de mise en service',
    ISNULL(pg.ON_ZUS, '') as 'ON_ZUS',
    ISNULL(pg.ON_ZRR, '') as 'ON_ZRR',
    ISNULL(pg.LB_NATLOC, '') as 'nature local',
    ISNULL(pg.SURF_HAB, 0) as 'surface',
    CONCAT(c.NOM_CLIENT, ' ', c.PRE_CLIENT) as 'nom-prénom client',
    ISNULL(pc.NO_DOSFACT,'') as 'n° DF',
    isNull(CONVERT(VARCHAR(10), pc.DTD_CTRAT, 120), '') as 'Date Début Contrat',
    ISNULL(pc.CD_TYCTRAT, '') as 'Type de contrat (tous hors logement ou garage ou parking)',
    ISNULL(pc.LB_TYCTRAT, '') as 'Libelle Type de contrat (tous hors logement ou garage ou parking)',
    CONCAT(c.NOM_CLIENT, ' ', c.PRE_CLIENT) as 'libellé activité des commerces',
    isNull(CONVERT(VARCHAR(10), vgccp.[Date Début Facturation], 120), '') as 'Date Début Facturation',
    ISNULL(vgccp.[Terme Facturation], '') as 'Terme Facturation',
    ISNULL(pc.LB_PERIOD, 'Mensuel') as 'Libelle Périodicité de facturation',
    ISNULL(pc.MT_SOLD_DG, 0) as 'Loyer Initial',
    ISNULL(fap.MT_LOYFA, 0) as 'Montant Loyer facturé',
    ISNULL(pg.MT_LOYER, 0) as 'Montant rubriques loyer',
    ISNULL(df.MT_SOLDLOY,0) as 'solde client créditeur ou débiteur',
	ISNULL(pc.NO_CTRACLI, '') as 'N° du contrat client'
	--ISNULL(vgccp.[Etat Date Début Contrat], '') as 'Etat Date Début Contrat'
FROM 
	PATRIMOINE_GIM pg
	LEFT JOIN PAT_CONTRA pc ON pc.CD_PATRIM = pg.CD_PATRIM AND pc.ET_DTF_PC = '' AND  pc.LB_ETAT_CC = 'En Cours'
	LEFT JOIN V_GIM_CTRAT_CLIENT_PATRIM vgccp ON vgccp.[Réf Patrim Concaténée] = pg.CD_PATRIM AND vgccp.[Code Etat Contrat] = 'E' AND vgccp.[No Ordre Client] = '1' AND vgccp.[No Ordre Pat-Contrat] = 1 AND vgccp.[Etat Date Début Contrat] = '' AND vgccp.[Etat Date Fin Contrat]  = 0
	LEFT JOIN DOSS_FACT df ON df.NO_DOSFACT  = pc.NO_DOSFACT
	LEFT JOIN CLIENT c ON c.ID_DOSCLIE = pc.ID_DOSCLIE AND c.CD_DEGPAR = '*PRINCIPAL'
	LEFT JOIN
	FAP_AGR_PC fap ON
	    RIGHT('00000' + CONVERT(VARCHAR(5), fap.CD_PATRIM1), 5) + '-' +
	    RIGHT('00000' + CONVERT(VARCHAR(5), fap.CD_PATRIM2), 5) + '-' +
	    RIGHT('00000' + CONVERT(VARCHAR(5), fap.CD_PATRIM3), 5) + '-' +
	    RIGHT('00000' + CONVERT(VARCHAR(5), fap.CD_PATRIM4), 5) = pc.CD_PATRIM
WHERE
	pg.CD_NATLOC IN ('F','C','ANT', 'BUR', 'PUB', 'S', 'VOL')
	AND pg.DTF_PAT_G = '1900-01-01 00:00:00.000'
	AND pc.CD_TYCTRAT <> '*NORMAL'
	AND (vgccp.[Etat Date Début Contrat] IS NULL OR vgccp.[Etat Date Début Contrat] NOT IN ('98', '99'))
	--AND vgccp.[Etat Date Début Contrat] NOT IN ('98', '99')
	--AND vgccp.[Etat Date Début Contrat] <> '98'
	--AND pc.NO_CTRACLI IN ( 85110  )
	

