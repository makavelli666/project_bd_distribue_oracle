INSERT INTO TVA (taux, valeur) VALUES ('taux normal', 20.00);
INSERT INTO TVA (taux, valeur) VALUES ('taux inter', 10.00);
INSERT INTO TVA (taux, valeur) VALUES ('taux reduit', 5.50);
INSERT INTO TVA (taux, valeur) VALUES ('taux particulier', 2.10);

INSERT INTO PRODUIT (np, nomp, prixht, taux, nbstock) VALUES (80, 'Produit D', 20.00, 'taux normal', 2);
INSERT INTO PRODUIT (np, nomp, prixht, taux, nbstock) VALUES (85, 'Produit E', 15.00, 'taux reduit', 1002);
INSERT INTO PRODUIT (np, nomp, prixht, taux, nbstock) VALUES (83, 'Produit F', 8.50, 'taux inter', 80);
INSERT INTO PRODUIT (np, nomp, prixht, taux, nbstock) VALUES (95, 'Produit F', 8.50, 'taux non existant', 899);


INSERT INTO PERSONNE (nom, prenom, adresse) VALUES ('ER-RAMI', 'Majd', '18 rue de la Paix, 75001 Paris');
INSERT INTO PERSONNE (nom, prenom, adresse) VALUES ('Ismael', 'Herve', '28 avenue alain savary, 21000 DIJON');
INSERT INTO PERSONNE (nom, prenom, adresse) VALUES ('Sylla', 'Paul', '01 rue des Lilas, 44000 Nantes');


INSERT INTO ACHAT (na, nom, prenom, np, nb) VALUES (1, 'Ismael', 'Herve', 83, 5);
