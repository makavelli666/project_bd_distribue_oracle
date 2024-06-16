


DECLARE 
    foundPrice FLOAT;
    updatedNbStock NUMBER;
BEGIN
    /* On insère les taux */
    INSERT INTO TVA (taux, valeur) VALUES ('taux normal', 20.00);
    INSERT INTO TVA (taux, valeur) VALUES ('taux inter', 10.00);
    INSERT INTO TVA (taux, valeur) VALUES ('taux reduit', 5.50);
    INSERT INTO TVA (taux, valeur) VALUES ('taux particulier', 2.10);

    /* voir les tables TVA sur les deux sites et la vue qui les combine */
    SELECT * FROM TVA1;
    SELECT * FROM TVA2;

    SELECT * FROM TVA;

    /* test du trigger update */
    DBMS_OUTPUT.PUT_LINE('UPDATE SUR TVA ...');

    UPDATE TVA SET valeur = 10.5 WHERE taux = 'taux normal';

    /* voir les tables TVA sur les deux sites et la vue qui les combine */
    SELECT * FROM TVA1;
    SELECT * FROM TVA2;

    SELECT * FROM TVA;

    /* on insère deux produits */
    INSERT INTO PRODUIT (np, nomp, prixht, taux, nbstock) VALUES (102, 'Ecran BenQ', 160.00, 'taux inter', 28);
    INSERT INTO PRODUIT (np, nomp, prixht, taux, nbstock) VALUES (103, 'Ecran Samsung', 255.00, 'taux inter', 0);
    INSERT INTO PRODUIT (np, nomp, prixht, taux, nbstock) VALUES (80, 'PC portable ACER', 1023.00, 'taux normal', 2);
    INSERT INTO PRODUIT (np, nomp, prixht, taux, nbstock) VALUES (85, 'Chaise Bureau', 15.00, 'taux reduit', 1002);
    INSERT INTO PRODUIT (np, nomp, prixht, taux, nbstock) VALUES (83, 'Mouchoires', 8.50, 'taux inter', 80);

    /* Ce produit va pas s'insérer à cause du taux qui n'existe pas (on gère les clés étrangères dans les triggers) */
    INSERT INTO PRODUIT (np, nomp, prixht, taux, nbstock) VALUES (95, 'Produit F', 8.50, 'taux non existant', 899);

    /* voir les tables PRODUIT sur les deux sites et la vue qui les combine */
    SELECT * FROM PRODUIT1;
    SELECT * FROM PRODUIT2;

    SELECT * FROM PRODUIT;

    /* test du trigger update */
    DBMS_OUTPUT.PUT_LINE('UPDATE SUR PRODUIT ...');

    UPDATE PRODUIT SET nbstock = 0 WHERE np = 85;

    /* voir les tables PRODUIT sur les deux sites et la vue qui les combine */
    SELECT * FROM PRODUIT1;
    SELECT * FROM PRODUIT2;

    SELECT * FROM PRODUIT;


    /* Une personne pour passer l'achat */
    INSERT INTO PERSONNE (nom, prenom, adresse) VALUES ('John', 'Doe', '16 avenue alain savary, 21000 DIJON');

    /* voir la table PERSONNE */
    SELECT * FROM PERSONNE;

    /* Achat qui doit passer */
    INSERT INTO ACHAT (na, nom, prenom, np, nb) VALUES (859, 'John', 'Doe', 102, 2);

    /* Achat qui va pas s'insérer à cause de la quantité du stock du produit */
    INSERT INTO ACHAT (na, nom, prenom, np, nb) VALUES (860, 'John', 'Doe', 103, 5);

    /* voir les tables ACHAT sur les deux sites et la vue qui les combine */
    SELECT * FROM ACHAT1;
    SELECT * FROM ACHAT2;

    SELECT * FROM ACHAT;

    /* Vérifier le prix calculer après l'insértion d'achat */

    SELECT prix INTO foundPrice FROM ACHAT WHERE na = 859;
    SELECT nbstock INTO updatedNbStock FROM PRODUIT WHERE np = 102;

    DBMS_OUTPUT.PUT_LINE('Prix calcule = ' || foundPrice);
    DBMS_OUTPUT.PUT_LINE('Quantite mis à jour = ' || updatedNbStock);

    /* test du trigger update */
    DBMS_OUTPUT.PUT_LINE('UPDATE SUR ACHAT ...');

    UPDATE ACHAT SET np = 80 WHERE na = 859;

    /* voir les tables ACHAT sur les deux sites et la vue qui les combine */
    SELECT * FROM ACHAT1;
    SELECT * FROM ACHAT2;

    SELECT * FROM ACHAT;

END;