-- Supprimer le schéma s'il existe et recréer le schéma
DROP SCHEMA IF EXISTS colleges CASCADE;
CREATE SCHEMA colleges;
SET SCHEMA 'colleges';

-- Création des tables

CREATE TABLE _etablissement (
    uai VARCHAR(10) NOT NULL,
    nom_etablissement VARCHAR(115) NOT NULL,
    secteur VARCHAR(10) NOT NULL,
    code_postal VARCHAR(10) NOT NULL,
    latitude FLOAT NOT NULL,
    longitude FLOAT NOT NULL,
    CONSTRAINT _etablissement_pk PRIMARY KEY (uai)
);

CREATE TABLE _commune (
    code_insee_de_la_commune VARCHAR(10) NOT NULL,
    nom_de_la_commune VARCHAR(40) NOT NULL,
    CONSTRAINT _commune_pk PRIMARY KEY (code_insee_de_la_commune)
);

CREATE TABLE _departement (
    code_du_departement VARCHAR(5) NOT NULL,
    nom_departement VARCHAR(30) NOT NULL UNIQUE,
    CONSTRAINT _departement_pk PRIMARY KEY (code_du_departement)
);

CREATE TABLE _region (
    code_region VARCHAR(5) NOT NULL,
    libelle_region VARCHAR(30) NOT NULL UNIQUE,
    CONSTRAINT _region_pk PRIMARY KEY (code_region)
);

CREATE TABLE _quartierPrioritaire (
    code_quartier_prioritaire VARCHAR(10) NOT NULL,
    libelle_quartier_prioritaire VARCHAR(90) NOT NULL,
    CONSTRAINT _quartierPrioritaire_pk PRIMARY KEY (code_quartier_prioritaire)
);

CREATE TABLE _type (
    code_nature VARCHAR(5) NOT NULL,
    libelle_nature VARCHAR(35) NOT NULL,
    CONSTRAINT _type_pk PRIMARY KEY (code_nature, libelle_nature)
);

CREATE TABLE _academie (
    code_academie NUMERIC(5) NOT NULL,
    lib_academie VARCHAR(20) NOT NULL UNIQUE,
    CONSTRAINT _academie_pk PRIMARY KEY (code_academie)
);

CREATE TABLE _annee (
    annee_scolaire VARCHAR(10) NOT NULL,
    CONSTRAINT _annee_pk PRIMARY KEY (annee_scolaire)
);

CREATE TABLE _classe (
    id_classe VARCHAR(10) NOT NULL,
    CONSTRAINT _classe_pk PRIMARY KEY (id_classe)
);

CREATE TABLE _caracteristiquesToutEtablissement (
    effectif NUMERIC(5) NOT NULL,
    ips FLOAT NOT NULL,
    ecart_type_de_l_ips FLOAT NOT NULL,
    ep VARCHAR(10) NOT NULL,
    uai VARCHAR(10) NOT NULL,
    annee_scolaire VARCHAR(10),
    CONSTRAINT _caracteristiquesToutEtablissement_pk PRIMARY KEY (annee_scolaire, uai)
);

CREATE TABLE _caracteristiquesCollege (
    nbre_eleves_hors_segpa_hors_ulis NUMERIC(5) NOT NULL,
    nbre_eleves_segpa NUMERIC(5) NOT NULL,
    nbre_eleves_ulis NUMERIC(5) NOT NULL,
    uai VARCHAR(10) NOT NULL,
    annee_scolaire VARCHAR(10) NOT NULL,
    CONSTRAINT _caracteristiquesCollege_pk PRIMARY KEY (annee_scolaire, uai)
);

CREATE TABLE _caracteristiquesSelonClasse (
    nbre_eleves_hors_segpa_hors_ulis_selon_niveau NUMERIC(5) NOT NULL,
    nbre_eleves_segpa_selon_niveau NUMERIC(5) NOT NULL,
    nbre_eleves_ulis_selon_niveau NUMERIC(5) NOT NULL,
    effectif_filles NUMERIC(5) NOT NULL,
    effectif_garcons NUMERIC(5) NOT NULL,
    uai VARCHAR(10) NOT NULL,
    annee_scolaire VARCHAR(10) NOT NULL,
    id_classe  VARCHAR(10) NOT NULL,
    CONSTRAINT _caracteristiquesSelonClasse_pk PRIMARY KEY (annee_scolaire, uai, id_classe)
);

-- Ajout des contraintes de clé étrangère

ALTER TABLE _etablissement
    ADD CONSTRAINT _etablissement_fk_1 FOREIGN KEY (uai) REFERENCES _academie (code_academie),
    ADD CONSTRAINT _etablissement_fk_2 FOREIGN KEY (uai) REFERENCES _quartierPrioritaire (code_quartier_prioritaire),
    ADD CONSTRAINT _etablissement_fk_3 FOREIGN KEY (uai) REFERENCES _commune (code_insee_de_la_commune),
    ADD CONSTRAINT _etablissement_fk_4 FOREIGN KEY (uai) REFERENCES _type (code_nature);

ALTER TABLE _commune
    ADD CONSTRAINT _commune_fk_1 FOREIGN KEY (code_insee_de_la_commune) REFERENCES _departement (code_du_departement);

ALTER TABLE _departement
    ADD CONSTRAINT _departement_fk_1 FOREIGN KEY (code_du_departement) REFERENCES _region (code_region);

ALTER TABLE _caracteristiquesToutEtablissement
    ADD CONSTRAINT _caracteristiquesToutEtablissement_fk_1 FOREIGN KEY (uai) REFERENCES _etablissement (uai),
    ADD CONSTRAINT _caracteristiquesToutEtablissement_fk_2 FOREIGN KEY (annee_scolaire) REFERENCES _annee (annee_scolaire);

ALTER TABLE _caracteristiquesCollege
    ADD CONSTRAINT _caracteristiquesCollege_fk_1 FOREIGN KEY (uai) REFERENCES _etablissement (uai),
    ADD CONSTRAINT _caracteristiquesCollege_fk_2 FOREIGN KEY (annee_scolaire) REFERENCES _annee (annee_scolaire);

ALTER TABLE _caracteristiquesSelonClasse
    ADD CONSTRAINT _caracteristiquesSelonClasse_fk_1 FOREIGN KEY (uai) REFERENCES _etablissement (uai),
    ADD CONSTRAINT _caracteristiquesSelonClasse_fk_2 FOREIGN KEY (annee_scolaire) REFERENCES _annee (annee_scolaire),
    ADD CONSTRAINT _caracteristiquesSelonClasse_fk_3 FOREIGN KEY (id_classe) REFERENCES _classe (id_classe);
