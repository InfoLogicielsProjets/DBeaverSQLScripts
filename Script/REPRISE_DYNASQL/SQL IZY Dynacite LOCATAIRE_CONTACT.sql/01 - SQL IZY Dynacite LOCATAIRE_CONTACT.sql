--DELETE  dbo.[IZY_LOCATAIRE_CONTACT_COORDONNEES]
CREATE TABLE IZY.[IZY_LOCATAIRE_CONTACT_COORDONNEES] (
    ID_DOSCLIE INT,
    CTRACT1_ID VARCHAR(50),
    CTRACT1_MAIL VARCHAR(100),
    CTRACT1_PORT VARCHAR(20),
    CTRACT1_FIXE VARCHAR(20),
    CTRACT2_ID VARCHAR(50),
    CTRACT2_MAIL VARCHAR(100),
    CTRACT2_PORT VARCHAR(20),
    CTRACT2_FIXE VARCHAR(20),
    CTRACT3_ID VARCHAR(50),
    CTRACT3_MAIL VARCHAR(100),
    CTRACT3_PORT VARCHAR(20),
    CTRACT3_FIXE VARCHAR(20),
    CTRACT4_ID VARCHAR(50),
    CTRACT4_MAIL VARCHAR(100),
    CTRACT4_PORT VARCHAR(20),
    CTRACT4_FIXE VARCHAR(20),
    DT_ALIM DATETIME
)
INSERT INTO IZY.[IZY_LOCATAIRE_CONTACT_COORDONNEES]
SELECT
    ID_DOSCLIE,
    CTRACT1_ID,
    CTRACT1_MAIL,
    CTRACT1_PORT,
    CTRACT1_FIXE,
    CTRACT2_ID,
    CASE WHEN CTRACT2_MAIL = CTRACT1_MAIL THEN '' ELSE CTRACT2_MAIL END AS CTRACT2_MAIL,
    CASE WHEN CTRACT2_PORT = CTRACT1_PORT THEN '' ELSE CTRACT2_PORT END AS CTRACT2_PORT,
    CASE WHEN CTRACT2_FIXE = CTRACT1_FIXE THEN '' ELSE CTRACT2_FIXE END AS CTRACT2_FIXE,
    CTRACT3_ID,
    CASE WHEN CTRACT3_MAIL = CTRACT1_MAIL OR CTRACT3_MAIL = CTRACT2_MAIL THEN '' ELSE CTRACT3_MAIL END AS CTRACT3_MAIL,
    CASE WHEN CTRACT3_PORT = CTRACT1_PORT OR CTRACT3_PORT = CTRACT2_PORT THEN '' ELSE CTRACT3_PORT END AS CTRACT3_PORT,
    CASE WHEN CTRACT3_FIXE = CTRACT1_FIXE OR CTRACT3_FIXE = CTRACT2_FIXE THEN '' ELSE CTRACT3_FIXE END AS CTRACT3_FIXE,
    CTRACT4_ID,
    CASE WHEN CTRACT4_MAIL = CTRACT1_MAIL OR CTRACT4_MAIL = CTRACT2_MAIL OR CTRACT4_MAIL = CTRACT3_MAIL THEN '' ELSE CTRACT4_MAIL END AS CTRACT4_MAIL,
    CASE WHEN CTRACT4_PORT = CTRACT1_PORT OR CTRACT4_PORT = CTRACT2_PORT OR CTRACT4_PORT = CTRACT3_PORT THEN '' ELSE CTRACT4_PORT END AS CTRACT4_PORT,
    CASE WHEN CTRACT4_FIXE = CTRACT1_FIXE OR CTRACT4_FIXE = CTRACT2_FIXE OR CTRACT4_FIXE = CTRACT3_FIXE THEN '' ELSE CTRACT4_FIXE END AS CTRACT4_FIXE,
    GETDATE() AS DT_ALIM
FROM (
    SELECT
        ID_DOSCLIE,
        ISNULL(MAX(CASE WHEN NO_ROW = 1 THEN ID_CLIENT ELSE '' END),'') AS CTRACT1_ID,
        ISNULL(MAX(CASE WHEN NO_ROW = 1 THEN RTRIM(MEL_PERSO) ELSE '' END),'') AS CTRACT1_MAIL,
        ISNULL(MAX(CASE WHEN NO_ROW = 1 THEN TEL_PORPER ELSE '' END),'') AS CTRACT1_PORT,
        ISNULL(MAX(CASE WHEN NO_ROW = 1 THEN TEL_FIXPER ELSE '' END),'') AS CTRACT1_FIXE,
        ISNULL(MAX(CASE WHEN NO_ROW = 2 THEN ID_CLIENT ELSE '' END),'') AS CTRACT2_ID,
        ISNULL(MAX(CASE WHEN NO_ROW = 2 THEN RTRIM(MEL_PERSO) ELSE '' END),'') AS CTRACT2_MAIL,
        ISNULL(MAX(CASE WHEN NO_ROW = 2 THEN TEL_PORPER ELSE '' END),'') AS CTRACT2_PORT,
        ISNULL(MAX(CASE WHEN NO_ROW = 2 THEN TEL_FIXPER ELSE '' END),'') AS CTRACT2_FIXE,
        ISNULL(MAX(CASE WHEN NO_ROW = 3 THEN ID_CLIENT ELSE '' END),'') AS CTRACT3_ID,
        ISNULL(MAX(CASE WHEN NO_ROW = 3 THEN RTRIM(MEL_PERSO) ELSE '' END),'') AS CTRACT3_MAIL,
        ISNULL(MAX(CASE WHEN NO_ROW = 3 THEN TEL_PORPER ELSE '' END),'') AS CTRACT3_PORT,
        ISNULL(MAX(CASE WHEN NO_ROW = 3 THEN TEL_FIXPER ELSE '' END),'') AS CTRACT3_FIXE,
        ISNULL(MAX(CASE WHEN NO_ROW = 4 THEN ID_CLIENT ELSE '' END),'') AS CTRACT4_ID,
        ISNULL(MAX(CASE WHEN NO_ROW = 4 THEN RTRIM(MEL_PERSO) ELSE '' END),'') AS CTRACT4_MAIL,
        ISNULL(MAX(CASE WHEN NO_ROW = 4 THEN TEL_PORPER ELSE '' END),'') AS CTRACT4_PORT,
        ISNULL(MAX(CASE WHEN NO_ROW = 4 THEN TEL_FIXPER ELSE '' END),'') AS CTRACT4_FIXE
    FROM (
        SELECT
            ID_DOSCLIE,
            NO_ORD_CL,
            CD_DEGPAR,
            ID_CLIENT,
            MEL_PERSO,
            TEL_PORPER,
            TEL_FIXPER,
            ROW_NUMBER() OVER(PARTITION BY ID_DOSCLIE ORDER BY NO_ORD_CL ASC, CD_DEGPAR ASC) AS NO_ROW
        FROM dbo.CLIENT
        WHERE CD_SOCIETE = 1
            AND CD_PHYMOR = 'P'
            AND ON_CTRACT = 'O'
            AND ID_DOSCLIE IN (SELECT DISTINCT ID_DOSCLIE FROM IZY.Cible_locataires)
    ) SR
    GROUP BY ID_DOSCLIE
) REQ
ORDER BY 1;
