--Authors: Simon Kobyda, Michal Zelenak
-- VUT FIT 2019 IDS

--TO DO


--pull datas into table

BEGIN 
    EXECUTE immediate 'DROP TABLE Zamestnanec CASCADE CONSTRAINTS';
    EXCEPTION WHEN others THEN NULL;
END;
/
BEGIN 
    EXECUTE immediate 'DROP TABLE ZanerFilmu CASCADE CONSTRAINTS';
    EXCEPTION WHEN others THEN NULL;
END;
/
BEGIN 
    EXECUTE immediate 'DROP TABLE Film CASCADE CONSTRAINTS';
    EXCEPTION WHEN others THEN NULL;
END;
/
BEGIN 
    EXECUTE immediate 'DROP TABLE Projekcia CASCADE CONSTRAINTS';
    EXCEPTION WHEN others THEN NULL;
END;
/
BEGIN 
    EXECUTE immediate 'DROP TABLE PremietaciaSala CASCADE CONSTRAINTS';
    EXCEPTION WHEN others THEN NULL;
END;
/
BEGIN 
    EXECUTE immediate 'DROP TABLE Rezervacia CASCADE CONSTRAINTS';
    EXCEPTION WHEN others THEN NULL;
END;
/
BEGIN 
    EXECUTE immediate 'DROP TABLE Sedadlo CASCADE CONSTRAINTS';
    EXCEPTION WHEN others THEN NULL;
END;
/
BEGIN 
    EXECUTE immediate 'DROP TABLE Klient CASCADE CONSTRAINTS';
    EXCEPTION WHEN others THEN NULL;
END;
/
BEGIN 
    EXECUTE immediate 'DROP TABLE tableZanerFilm CASCADE CONSTRAINTS';
    EXCEPTION WHEN others THEN NULL;
END;
/
BEGIN 
    EXECUTE immediate 'DROP TABLE Vstupenka CASCADE CONSTRAINTS';
    EXCEPTION WHEN others THEN NULL;
END;
/
BEGIN 
    EXECUTE immediate 'DROP TABLE Multikino CASCADE CONSTRAINTS';
    EXCEPTION WHEN others THEN NULL;
END;
/

CREATE TABLE multikino
(
nameCin VARCHAR2(50) PRIMARY KEY NOT NULL,
mesto VARCHAR2(180) NOT NULL, 
ulica VARCHAR2(180)
);

CREATE TABLE zamestnanec 
(
rodneCislo CHAR(11) PRIMARY KEY NOT NULL,
meno VARCHAR2(120) NOT NULL,
priezvisko VARCHAR2(120) NOT NULL,
adresa VARCHAR2(80) NOT NULL,
cisloUctu CHAR(24),
hodinovaMzda NUMBER(4,3),
pozicia VARCHAR2(50) NOT NULL,
multikinoPraca VARCHAR2(50) NOT NULL,
CONSTRAINT poziciaEnum CHECK ( pozicia IN('pokladnik','veduci','majitel','vyhodeny')),
CONSTRAINT FKZamesMultikina FOREIGN KEY
    (multikinoPraca) REFERENCES multikino
    ON DELETE CASCADE
);

CREATE TABLE zanerFilmu
(nazov VARCHAR2(20) NOT NULL, 
popis VARCHAR2(300),
--film NUMBER,
CONSTRAINT PKzanerFilmu PRIMARY KEY (nazov) 
);


CREATE TABLE film
(filmID INT GENERATED AS IDENTITY PRIMARY KEY NOT NULL,
nazovFilmu VARCHAR2(20) NOT NULL,
rok NUMBER(4,0),
klucSlova VARCHAR(100),--HERE 
reziser VARCHAR2(70),
trvanie NUMBER(3,1),
krajinaPovodu VARCHAR2(50),
vekoveObmedzenie NUMBER(2,0) NOT NULL
);

CREATE TABLE tableZanerFilm
(nazovZanru VARCHAR2(20),
filmIdentifikator NUMBER,
CONSTRAINT FKFilmZaner FOREIGN KEY
    (nazovZanru) REFERENCES zanerFilmu,
CONSTRAINT FKFilmID FOREIGN KEY
    (filmIdentifikator) REFERENCES film
);

CREATE TABLE premietaciaSala
(premietaciaSalaID INT GENERATED AS IDENTITY PRIMARY KEY,
kapacita NUMBER(4,0),
projektor VARCHAR2(50) NOT NULL,
kino VARCHAR2(50) NOT NULL,
CONSTRAINT FKKino FOREIGN KEY
(kino) REFERENCES multikino
ON DELETE CASCADE
);

CREATE TABLE projekcia 
(projekciaID INT GENERATED AS IDENTITY PRIMARY KEY,
titulky CHAR(2),
jazyk VARCHAR2(80),
datum TIMESTAMP NOT NULL,
d3 CHAR(1) NOT NULL,
projekciaFilm NUMBER,
projekciaSala NUMBER,
CONSTRAINT FKProjekciaFilm FOREIGN KEY
(projekciaFilm) REFERENCES film
    ON DELETE CASCADE,
CONSTRAINT FKSalaFilm FOREIGN KEY
(projekciaSala) REFERENCES premietaciaSala
    ON DELETE CASCADE
);

CREATE TABLE sedadlo
(sedadloID INT GENERATED AS IDENTITY PRIMARY KEY,
rad NUMBER(4,0) NOT NULL,
poradie NUMBER(4,0) NOT NULL,
obsadenost CHAR(1) NOT NULL,
sedadloSala NUMBER NOT NULL,
CONSTRAINT FKSedadloSala FOREIGN KEY
(sedadloSala) REFERENCES premietaciaSala
ON DELETE CASCADE
);

CREATE TABLE klient
(klientID VARCHAR2(50) PRIMARY KEY NOT NULL,
heslo VARCHAR2(50) NOT NULL,
vek NUMBER(3,0) NOT NULL,
status VARCHAR2(10) NOT NULL,
CONSTRAINT statusEnum CHECK ( status IN('die?a','študent','dôchodca','dospelý','invalid'))
);



CREATE TABLE rezervacia
(rezervaciaID INT GENERATED AS IDENTITY PRIMARY KEY NOT NULL,
cas DATE NOT NULL,
cena NUMBER(4,2) NOT NULL,
rezervProjekcia NUMBER,
rezervSedadlo NUMBER,
rezervKlient VARCHAR2(50),
CONSTRAINT FKRezervaciaProjekcia FOREIGN KEY
    (rezervProjekcia) REFERENCES projekcia
    ON DELETE CASCADE,
CONSTRAINT FKRezervaciaSedadlo FOREIGN KEY
    (rezervSedadlo) REFERENCES sedadlo
    ON DELETE CASCADE,
CONSTRAINT FKRezervaciaKlient FOREIGN KEY
    (rezervKlient) REFERENCES klient
    ON DELETE CASCADE
);

CREATE TABLE vstupenka
(vstupenkaID INT GENERATED AS IDENTITY PRIMARY KEY,
casPredaja TIMESTAMP NOT NULL,
cena NUMBER(4,3) NOT NULL,
statusZakaznika VARCHAR2(10) NOT NULL,
vstupenkaSedadlo NUMBER,
vstupenkaProjekcia NUMBER NOT NULL,
CONSTRAINT FKVstupenkaSedadlo FOREIGN KEY
    (vstupenkaSedadlo) REFERENCES sedadlo
    ON DELETE CASCADE,
CONSTRAINT FKVstupenkaProjekcia FOREIGN KEY
    (vstupenkaProjekcia) REFERENCES projekcia
    ON DELETE CASCADE
);

    --vstupenky po zmazani projekcie ostanu kvôli vráteniu pe?azí    
         

----------------------------INSERTION OF THE DATA STARTS HERE-----

-----------------------------------INSERTION ENDS HERE------------
--Ur?enie spravcu databazy 
GRANT ALL ON zamestnanec TO xkobyd00;
GRANT ALL ON multikino TO xkobyd00;
GRANT ALL ON rezervacia TO xkobyd00;
GRANT ALL ON zanerFilmu TO xkobyd00;
GRANT ALL ON film TO xkobyd00;
GRANT ALL ON sedadlo TO xkobyd00;
GRANT ALL ON vstupenka TO xkobyd00;
GRANT ALL ON premietaciaSala TO xkobyd00;
GRANT ALL ON projekcia TO xkobyd00;
GRANT ALL ON klient TO xkobyd00;

COMMIT;
 
/*
--drop table trzbyFilmu;
drop table Vstupenka;
drop table Klient;
drop table Sedadlo;
drop table Rezervacia;
drop table PremietaciaSala;
drop table Projekcia;

drop table Film;
drop table zanerFilmu;
drop table multikino;
drop table Zamestnanec;
*/