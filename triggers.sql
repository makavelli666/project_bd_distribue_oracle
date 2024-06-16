

CREATE OR REPLACE TRIGGER TVA_INSERT_TRIGGER
INSTEAD OF INSERT ON TVA
FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
    IF(:new.valeur >= 10.0) then
        INSERT INTO TVA1 values (:new.taux, :new.valeur);
    ELSE
        INSERT INTO TVA2 values (:new.taux, :new.valeur);
    END IF;

    COMMIT;
END;



CREATE OR REPLACE TRIGGER PRODUIT_INSERT_TRIGGER
INSTEAD OF INSERT ON PRODUIT
FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;

    found_here NUMBER;
    found_in_syn NUMBER;
BEGIN
    SELECT COUNT(*) INTO found_here FROM TVA1 WHERE taux = :new.taux;
    SELECT COUNT(*) INTO found_in_syn FROM TVA2 WHERE taux = :new.taux;

    IF(found_here >= 1) then
        INSERT INTO PRODUIT1 VALUES (
            :new.np, :new.nomp, :new.prixht, :new.taux, :new.nbstock
        );
    ELSIF(found_in_syn >= 1) THEN
        INSERT INTO PRODUIT2 VALUES (
            :new.np, :new.nomp, :new.prixht, :new.taux, :new.nbstock
        );
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Ce taux n''existe pas.');
    END IF;

    COMMIT;
END;





CREATE OR REPLACE TRIGGER ACHAT_INSERT_TRIGGER
INSTEAD OF INSERT ON ACHAT
FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;

    prixTrouve NUMBER;
    tauxTrouve VARCHAR2(20);
    valeurTaxTrouve FLOAT;
    taxExists NUMBER;
    stockProduit NUMBER;

    prixTotal FLOAT;

    found_in_personne NUMBER;
    produitTrouve NUMBER;
BEGIN
    SELECT COUNT(*) INTO found_in_personne FROM PERSONNE WHERE nom = :new.nom AND prenom = :new.prenom;

    IF found_in_personne >= 1 THEN
        SELECT COUNT(*) INTO produitTrouve FROM PRODUIT WHERE np = :new.np;
        SELECT prixht, taux, nbstock INTO prixTrouve, tauxTrouve, stockProduit FROM PRODUIT WHERE np = :new.np;

        IF produitTrouve >= 1 AND stockProduit >= :new.nb THEN
            SELECT COUNT(*) INTO taxExists FROM TVA WHERE taux = tauxTrouve;
            SELECT valeur INTO valeurTaxTrouve FROM TVA WHERE taux = tauxTrouve;

            IF taxExists >= 1 THEN
                prixTotal := :new.nb * prixTrouve * (1.0 + valeurTaxTrouve/100.0);

                UPDATE produit SET nbStock = stockProduit - :new.nb WHERE np = :new.np;

                INSERT INTO ACHAT1 VALUES (
                    :new.na, :new.nom, :new.np, prixTotal
                );
                INSERT INTO ACHAT2 VALUES (
                    :new.na, :new.prenom, :new.nb
                );
            ELSE
                RAISE_APPLICATION_ERROR(-20001, 'Ce taux n''existe pas.');
            END IF;
        ELSE
            RAISE_APPLICATION_ERROR(-20001, 'Ce produit n''existe pas, ou le stock est epuise.');
        END IF;
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Cette combinaison nom, prenom n''existe pas.');
    END IF;

    COMMIT;
END;


show errors trigger achat_insert_trigger;


/* UPDATE TRIGGERS */

CREATE OR REPLACE TRIGGER TVA_UPDATE_TRIGGER
INSTEAD OF UPDATE ON TVA
FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;

    oldFound NUMBER;
    newFound NUMBER;
BEGIN
    SELECT COUNT(*) INTO oldFound FROM TVA WHERE taux = :old.taux;
    SELECT COUNT(*) INTO newFound FROM TVA WHERE taux = :new.taux;

    IF(oldFound >= 1 AND newFound = 0) THEN
        DELETE FROM TVA WHERE taux = :old.taux;
        INSERT INTO TVA values (:new.taux, :new.valeur);
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Ce taux n''existe pas ou la clé primaire est prise.');
    END IF;

    COMMIT;
END;

CREATE OR REPLACE TRIGGER PRODUIT_UPDATE_TRIGGER
INSTEAD OF UPDATE ON PRODUIT
FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;

    oldfound NUMBER;
    newFound NUMBER;
    taux_found NUMBER;
BEGIN
    SELECT COUNT(*) INTO oldFound FROM PRODUIT WHERE np = :old.np;
    SELECT COUNT(*) INTO newFound FROM PRODUIT WHERE np = :new.np;
    SELECT COUNT(*) INTO taux_found FROM TVA WHERE taux = :new.taux;

    IF(oldFound >= 1 AND newFound = 0 AND taux_found >= 1) THEN
        DELETE FROM PRODUIT WHERE np = :old.np;
        INSERT INTO PRODUIT VALUES (
            :new.np, :new.nomp, :new.prixht, :new.taux, :new.nbstock
        );
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Ce produit ou taux n''existe pas.');
    END IF;
    COMMIT;
END;

CREATE OR REPLACE TRIGGER ACHAT_UPDATE_TRIGGER
INSTEAD OF UPDATE ON ACHAT
FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;

    prixTrouve NUMBER;
    tauxTrouve VARCHAR2(20);
    valeurTaxTrouve FLOAT;
    taxExists NUMBER;
    stockProduit NUMBER;

    prixTotal FLOAT;

    found_in_personne NUMBER;
    produitTrouve NUMBER;
BEGIN
    SELECT COUNT(*) INTO found_in_personne FROM PERSONNE WHERE nom = :new.nom AND prenom = :new.prenom;

    IF found_in_personne >= 1 THEN
        SELECT COUNT(*) INTO produitTrouve FROM PRODUIT WHERE np = :new.np;
        SELECT prixht, taux, nbstock INTO prixTrouve, tauxTrouve, stockProduit FROM PRODUIT WHERE np = :new.np;

        IF produitTrouve >= 1 AND stockProduit >= :new.nb THEN
            SELECT COUNT(*) INTO taxExists FROM TVA WHERE taux = tauxTrouve;
            SELECT valeur INTO valeurTaxTrouve FROM TVA WHERE taux = tauxTrouve;

            IF taxExists >= 1 THEN
                prixTotal := :new.nb * prixTrouve * (1.0 + valeurTaxTrouve/100.0);
                
                UPDATE produit SET nbStock = stockProduit + :new.nb WHERE np = :old.np;
                UPDATE produit SET nbStock = stockProduit - :new.nb WHERE np = :new.np;

                UPDATE ACHAT1
                SET na = :new.na,
                    nom = :new.nom,
                    np = :new.np,
                    prix = prixTotal
                WHERE na = :old.na;

                UPDATE ACHAT2
                SET na = :new.na,
                    prenom = :new.prenom,
                    nb = :new.np
                WHERE na = :old.na;
                
            ELSE
                RAISE_APPLICATION_ERROR(-20001, 'Ce taux n''existe pas.');
            END IF;
        ELSE
            RAISE_APPLICATION_ERROR(-20001, 'Ce produit n''existe pas, ou le stock est epuise.');
        END IF;
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Cette combinaison nom, prenom n''existe pas.');
    END IF;

    COMMIT;
END;

/* DELETE TRIGGERS */

CREATE OR REPLACE TRIGGER TVA_DELETE_TRIGGER
INSTEAD OF DELETE ON TVA
FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;

    BEGIN
    IF(:old.valeur >= 10.0) then
        DELETE FROM TVA1 WHERE taux = :old.taux;
    ELSE
        DELETE FROM TVA2 WHERE taux = :old.taux;
    END IF;
    COMMIT;
END;

CREATE OR REPLACE TRIGGER PRODUIT_DELETE_TRIGGER
INSTEAD OF DELETE ON PRODUIT
FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;

    found_here NUMBER;
    found_in_syn NUMBER;
BEGIN
    SELECT COUNT(*) INTO found_here FROM PRODUIT1 WHERE np = :old.np;
    SELECT COUNT(*) INTO found_in_syn FROM PRODUIT2 WHERE np = :old.np;

    IF(found_here >= 1) then
        DELETE FROM PRODUIT1 WHERE np = :old.np;
    ELSIF(found_in_syn >= 1) THEN
        DELETE FROM PRODUIT2 WHERE np = :old.np;
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Ce produit n''existe pas.');
    END IF;

    COMMIT;
END;

CREATE OR REPLACE TRIGGER ACHAT_DELETE_TRIGGER
INSTEAD OF DELETE ON ACHAT
FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;

    found NUMBER;
BEGIN
    SELECT COUNT(*) INTO found FROM PRODUIT1 WHERE na = :old.na;

    IF(found >= 1) then
        UPDATE produit SET nbStock = stockProduit + :old.nb WHERE np = :old.np;

        DELETE FROM ACHAT1 WHERE na = :old.na;
        DELETE FROM ACHAT2 WHERE na = :old.na;
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Cet achat n''existe pas.');
    END IF;

    COMMIT;
END;


