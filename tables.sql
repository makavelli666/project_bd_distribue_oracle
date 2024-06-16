/* la table TVA */

CREATE TABLE TVA1 (
  taux VARCHAR(20) PRIMARY KEY,
  valeur FLOAT(24) NOT NULL
);

CREATE TABLE TVA2 (
  taux VARCHAR(20) PRIMARY KEY,
  valeur FLOAT(24) NOT NULL
);

/* la table PRODUIT */

CREATE TABLE PRODUIT1 (
  np INT PRIMARY KEY,
  nomp VARCHAR(50) NOT NULL,
  prixht FLOAT(24) NOT NULL,
  taux VARCHAR(20) NOT NULL,
  nbstock INT NOT NULL
);

CREATE TABLE PRODUIT2 (
  np INT PRIMARY KEY,
  nomp VARCHAR(50) NOT NULL,
  prixht FLOAT(24) NOT NULL,
  taux VARCHAR(20) NOT NULL,
  nbstock INT NOT NULL
);
  
/* la table PERSONNE */

CREATE TABLE PERSONNE (
  nom VARCHAR(50) NOT NULL,
  prenom VARCHAR(50) NOT NULL,
  adresse VARCHAR(100),
  PRIMARY KEY (nom, prenom)
);

/* LA table ACHAT*/


CREATE TABLE ACHAT1 (
  na INT NOT NULL,
  nom VARCHAR(50) NOT NULL,
  np INT NOT NULL,
  prix FLOAT,
  PRIMARY KEY (na)
);

CREATE TABLE ACHAT2 (
  na INT NOT NULL,
  prenom VARCHAR(50) NOT NULL,
  nb INT NOT NULL,
  PRIMARY KEY (na)
);

----------------------------------------------------------------------------------
/* liens */

CREATE SYNONYM TVA2 for TVA2@herve_link;
CREATE SYNONYM PRODUIT2 for PRODUIT2@herve_link;
CREATE SYNONYM ACHAT2 for ACHAT2@herve_link;