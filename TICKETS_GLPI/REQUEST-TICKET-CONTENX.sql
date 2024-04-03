SELECT
    1 as HO1,
    'Hérault Logement' as Direction,
    isNull(CD_SECTEUR,'') as ESO1,
    isNull(LB_SECTEUR,'') as Agence,
    ISNULL(RIGHT('00000' + CAST(PATRIMOINE_GIM.CD_PATRIM1 AS VARCHAR(5)), 5), '') AS HP1,
    isNull(LB_PATRIM1,'') as Groupe,
    CASE WHEN PATRIMOINE_GIM.CD_PATRIM2 = 0 THEN '' ELSE LEFT(PATRIMOINE_GIM.CD_PATRIM, 11) END AS HP2,
    isNull(LB_PATRIM2,'') as Batiment,
    CASE WHEN PATRIMOINE_GIM.CD_PATRIM3 = 0 THEN '' ELSE LEFT(PATRIMOINE_GIM.CD_PATRIM, 17) END AS HP3,
    isNull(LB_PATRIM3,'') as Entrée,
    CASE
        WHEN PATRIMOINE_GIM.CD_PATRIM4 IS NULL OR PATRIMOINE_GIM.CD_PATRIM4 = 0 THEN ''
        WHEN ISNUMERIC(PATRIMOINE_GIM.CD_PATRIM4) = 1 THEN CAST(PATRIMOINE_GIM.CD_PATRIM4 AS VARCHAR(255))
        ELSE ''
    END AS UG,
    CASE
        WHEN PATRIMOINE_GIM.CD_PATRIM4 = 0 OR PATRIMOINE_GIM.CD_PATRIM4 IS NULL THEN ''
        ELSE
            (CASE
                WHEN ISNUMERIC(PATRIMOINE_GIM.CD_PATRIM4) = 1 THEN
                    CONCAT(
                        CASE
                            WHEN TY_CONSTR = 'C' THEN 'Collectif'
                            WHEN TY_CONSTR = 'I' THEN 'Individuel'
                            WHEN TY_CONSTR = 'M' THEN 'Mixte'
                        END,
                        '-',
                        CASE
                            WHEN CD_ETAGE = 'RDC' THEN '0N'
                            WHEN CD_ETAGE = 'RDCB' THEN '0B'
                            WHEN CD_ETAGE = 'RDCH' THEN '0H'
                            ELSE isNull(CD_ETAGE, '')
                        END,
                        '-',
                        CASE
                            WHEN NB_NIVEAUX = 0 THEN 'XX'
                            WHEN NB_NIVEAUX = 1 THEN '1N'
                            WHEN NB_NIVEAUX = 2 THEN '2N'
                            WHEN NB_NIVEAUX = 3 THEN '3N'
                        END,
                        '-',
                        'T', isNull(CD_TYPLOC, ''),
                        '-', isNull(LB_PATRIM1, '')
                    )
                ELSE ''
            END)
    END AS Local,
    PATRIMOINE_GIM.CD_PATRIM as intent_reference,
    CASE
        WHEN CD_QUALIF = 'LOCAL' THEN LB_NATLOC
        ELSE CD_QUALIF
    END AS intent_type,
    CONCAT (ADRPA_NORU, ' ',ADRPA_RUE1) as intent_address_way,
    isNull(ADRPA_RUE2,'') as intent_address_complement,
    isNull(ADRPA_CP,'') as  intent_address_zip,
    isNull(ADRPA_LOC,'') as intent_address_city,
    'FRANCE' as intent_address_country,
    isnull(SURF_HAB,0) as intent_surface,
    isNull(GPS_LATIT,0) as intent_latitude,
    isNull(GPS_LONGIT,0) as intent_longitude,
    isNull (CONVERT(VARCHAR(10), DTD_PAT_G, 120), '') as 'intent_commissioning_date',
    isNull(LB_ADPTHAN,'') as '01-Adaptation_Logement',
    CASE
        WHEN DTD_PAT_R <= '2000-01-01' THEN 'OUI'
        ELSE 'NON'
    END AS '02-RAAT',
    CASE
        WHEN NO_QPV IS NOT NULL THEN 'OUI'
        ELSE 'NON'
    END AS '03-QPV',
    isNull(ON_COPROP,'') as '04-Copropriété',
    isNull (CONVERT(VARCHAR(10), DTD_PAT_R, 120), '') as '05-Date_construction',
    CONCAT(
        'BEGIN:VCARD\r\nVERSION:3\r\n',
        'FN;CHARSET=UTF-8:', NOM_GARD, ' ', PRE_GARD, '\r\n',
        'TEL;TYPE=WORK,VOICE:', TEL_GARD, '\r\n',
        'ADR;TYPE=WORK:', 'ADRESS', ';', 'CODE_POSTAL', ';', 'VILLE',  ';France\r\n',
        'ROLE;CHARSET=UTF-8:Gardien\r\n',
        'EMAIL;CHARSET=UTF-8;TYPE=WORK,INTERNET:', MAIL_GARD, '\r\n',
        'END:VCARD'
    ) as intent_contacts_patrimoine,
    PATRIMOINE_GIM.CD_PATRIM
FROM
    dbo.PATRIMOINE_GIM
LEFT JOIN
    PAT_CONTRA ON PATRIMOINE_GIM.CD_PATRIM = PAT_CONTRA.CD_PATRIM AND PAT_CONTRA.ET_DTF_PC = '' AND  PAT_CONTRA.LB_ETAT_CC = 'En Cours'
WHERE 
    --CD_ETAT NOT IN ('FG', 'LI')
	(CD_ETAT != 'FG' OR (CD_ETAT = 'LI' AND (DTD_PAT_G IS NULL OR DTD_PAT_G > GETDATE() )))
    AND CD_NATLOC NOT IN ('A', 'P', 'PUB', 'T', 'X')
    AND CD_SECTEUR != ''
    AND PATRIMOINE_GIM.CD_SOCIETE = 1
    AND PATRIMOINE_GIM.CD_PATRIM like '01714-00001-00002%' 