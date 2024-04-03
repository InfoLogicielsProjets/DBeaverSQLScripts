SELECT Nom_Table, No_Ordre, Nom_Champ, Desc_Champ, Type_Champ, Longueur, Nb_Chiffre, Nb_Decimal, Cle_primaire
FROM ACGINFO1.dbo.CATALOG_GIM
WHERE Nom_Champ  like '%DTD%';


select CD_TYCTRAT from dbo.PAT_CONTRA

select
	isNull(FORMAT(DTD_PAT_R, 'dd/MM/yyyy'), '') as "Date_construction DTD_PAT_R",
	FORMAT(DTD_PAT_G, 'dd/MM/yyyy') AS "intent_commissioning_date DTD_PAT_G",
	
from dbo.PATRIMOINE_GIM


