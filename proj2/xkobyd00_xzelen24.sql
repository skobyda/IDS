--Authors: Simon Kobyda, Michal Zelenak
-- VUT FIT 2019 IDS

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
BEGIN
    EXECUTE immediate 'DROP SEQUENCE film_seq';
    EXCEPTION WHEN others THEN NULL;
END;
/
BEGIN
    EXECUTE immediate 'DROP SEQUENCE premietaciaSala_seq';
    EXCEPTION WHEN others THEN NULL;
END;
/
BEGIN
    EXECUTE immediate 'DROP SEQUENCE projekcia_seq';
    EXCEPTION WHEN others THEN NULL;
END;
/
BEGIN
    EXECUTE immediate 'DROP SEQUENCE sedadlo_seq';
    EXCEPTION WHEN others THEN NULL;
END;
/
BEGIN
    EXECUTE immediate 'DROP SEQUENCE rezervacia_seq';
    EXCEPTION WHEN others THEN NULL;
END;
/
BEGIN
    EXECUTE immediate 'DROP SEQUENCE vstupenka_seq';
    EXCEPTION WHEN others THEN NULL;
END;
/

CREATE SEQUENCE film_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE premietaciaSala_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE projekcia_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE sedadlo_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE rezervacia_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE vstupenka_seq START WITH 1 INCREMENT BY 1;
--premietaciaSalaID

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
hodinovaMzda NUMBER(4,2),
pozicia VARCHAR2(50) NOT NULL,
multikinoPraca VARCHAR2(50) NOT NULL,
CONSTRAINT poziciaEnum CHECK ( pozicia IN('pokladnik','veduci','majitel','vyhodeny')),
CONSTRAINT FKZamesMultikina FOREIGN KEY
    (multikinoPraca) REFERENCES multikino
    ON DELETE CASCADE,
CONSTRAINT CHECK_hodinovaMzda CHECK (hodinovaMzda>=0)    
);

CREATE TABLE zanerFilmu
(nazov VARCHAR2(20) NOT NULL,
popis VARCHAR2(300),
--film NUMBER,
CONSTRAINT PKzanerFilmu PRIMARY KEY (nazov)
);


CREATE TABLE film
(filmID INTEGER PRIMARY KEY NOT NULL,
nazovFilmu VARCHAR2(200) NOT NULL,
rok NUMBER(4,0),
klucSlova VARCHAR(300),--HERE
reziser VARCHAR2(70),
trvanie NUMBER(3,0),
krajinaPovodu VARCHAR2(50),
vekoveObmedzenie NUMBER(2,0) NOT NULL,
CONSTRAINT CHECK_rokDown CHECK (rok>=1850),
CONSTRAINT CHECK_rokUp CHECK (rok<3000),
CONSTRAINT CHECK_trvanie CHECK (trvanie>=0),
CONSTRAINT CHECK_vekObmedzUp CHECK (vekoveObmedzenie>=4),
CONSTRAINT CHECK_vekObmedzDown CHECK (vekoveObmedzenie<=60)
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
(premietaciaSalaID INTEGER PRIMARY KEY,
kapacita NUMBER(4,0),
projektor VARCHAR2(50) NOT NULL,
kino VARCHAR2(50) NOT NULL,
CONSTRAINT FKKino FOREIGN KEY
(kino) REFERENCES multikino
ON DELETE CASCADE,
CONSTRAINT CHECK_kapacita CHECK (kapacita>0)
);

CREATE TABLE projekcia
(projekciaID INTEGER PRIMARY KEY,
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
    ON DELETE CASCADE,
CONSTRAINT d3Check CHECK ( d3 IN('y','n'))
);

CREATE TABLE sedadlo
(sedadloID INTEGER PRIMARY KEY,
rad NUMBER(4,0) NOT NULL,
poradie NUMBER(4,0) NOT NULL,
obsadenost CHAR(1) NOT NULL,
sedadloSala NUMBER NOT NULL,
CONSTRAINT FKSedadloSala FOREIGN KEY
(sedadloSala) REFERENCES premietaciaSala
ON DELETE CASCADE,
CONSTRAINT CHECK_poradie CHECK (poradie>0),
CONSTRAINT CHECK_rad CHECK (rad>0),
CONSTRAINT obsadenostCheck CHECK ( obsadenost IN('y','n'))
);

CREATE TABLE klient
(klientID VARCHAR2(50) PRIMARY KEY NOT NULL,
heslo VARCHAR2(50) NOT NULL,
vek NUMBER(3,0) NOT NULL,
status VARCHAR2(10) NOT NULL,
CONSTRAINT statusEnum CHECK ( status IN('dieta','student','dochodca','dospely','invalid')),
CONSTRAINT CHECK_vek CHECK (vek>0)
);



CREATE TABLE rezervacia
(rezervaciaID INTEGER PRIMARY KEY NOT NULL,
cas TIMESTAMP NOT NULL,
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
    ON DELETE CASCADE,
CONSTRAINT CHECK_cena CHECK (cena>=0)
);

CREATE TABLE vstupenka
(vstupenkaID INTEGER PRIMARY KEY,
casPredaja TIMESTAMP NOT NULL,
cena NUMBER(4,2) NOT NULL,
statusZakaznika VARCHAR2(10) NOT NULL,
vstupenkaSedadlo NUMBER,
vstupenkaProjekcia NUMBER NOT NULL,
CONSTRAINT FKVstupenkaSedadlo FOREIGN KEY
    (vstupenkaSedadlo) REFERENCES sedadlo
    ON DELETE CASCADE,
CONSTRAINT FKVstupenkaProjekcia FOREIGN KEY
    (vstupenkaProjekcia) REFERENCES projekcia
    ON DELETE CASCADE,
CONSTRAINT CHECK_cenaVstupenka CHECK (cena>=0),
CONSTRAINT CHECK_status CHECK ( statusZakaznika IN('dieta','student','dochodca','dospely','invalid'))
);

    --vstupenky po zmazani projekcie ostanu kvoli vrateniu penazi







----------------------------INSERTION OF THE DATA STARTS HERE-----
INSERT INTO multikino (nameCin, mesto, ulica)
VALUES ('LuxCinematic', 'Brno', 'Metodejova');

INSERT INTO multikino (nameCin, mesto, ulica)
VALUES ('CineMax', 'Trencin', 'Stefanika');

INSERT INTO zamestnanec  (rodneCislo, meno, priezvisko, adresa, cisloUctu, hodinovaMzda, pozicia, multikinoPraca)
VALUES ('980604/6825', 'Andrej', 'Kristofan', 'Matice Slovenskej 1225/2 Brno', 'SK8975000000000012345671', 4.50, 'pokladnik', 'LuxCinematic');

INSERT INTO zamestnanec  (rodneCislo, meno, priezvisko, adresa, cisloUctu, hodinovaMzda, pozicia, multikinoPraca)
VALUES ('970904/3825', 'Michaela', 'Novakova', 'Svatoplukova 1226/2 Brno', 'CZ8375000000000012345336', 4.80, 'veduci', 'LuxCinematic');

INSERT INTO zamestnanec  (rodneCislo, meno, priezvisko, adresa, cisloUctu, hodinovaMzda, pozicia, multikinoPraca)
VALUES ('980614/6325', 'Milan', 'Orzsagh', 'Ludovita Stura 1425/1 Trencin', 'SK8215000000000012345671', 3.50, 'pokladnik', 'CineMax');

INSERT INTO zamestnanec  (rodneCislo, meno, priezvisko, adresa, cisloUctu, hodinovaMzda, pozicia, multikinoPraca)
VALUES ('970104/1825', 'Gabriela', 'Janosikova', 'Svatoplukova 1526/3 Svinna', 'SK8123000000000012345336', 3.95, 'veduci', 'CineMax');


INSERT INTO zanerFilmu  (nazov, popis)
VALUES ('thriller', 'Zaner, ktory ma u divaka vyvola silne napatie a emocie. Pozostava z rychleho sledu udalosti a castej akcie');

INSERT INTO zanerFilmu  (nazov, popis)
VALUES ('horror', 'Horror je zaner, ktorÈho cieæom je u div·ka vyvolaù pocit strachu a desu.');


INSERT INTO film (filmID,nazovFilmu, rok, klucSlova, reziser, trvanie, krajinaPovodu, vekoveObmedzenie)
VALUES (film_seq.nextval,'Mission: Impossible', 2018, 'action, hollywood, tom cruise', 'Christopher McQuarrie', 14, 'USA', 16);

INSERT INTO film (filmID,nazovFilmu, rok, klucSlova, reziser, trvanie, krajinaPovodu, vekoveObmedzenie)
VALUES (film_seq.nextval,'Us', 2019, 'horror, hollywood, tom  Yahya Abdul-Mateen II', 'Jordan Peele', 95, 'USA', 18);


INSERT INTO premietaciaSala (premietaciaSalaID,kapacita, projektor, kino)
VALUES (premietaciaSala_seq.nextval,272, 'Benq W11000H', 'LuxCinematic');

INSERT INTO premietaciaSala (premietaciaSalaID,kapacita, projektor, kino)
VALUES (premietaciaSala_seq.nextval,272, 'Benq W11000H', 'LuxCinematic');

INSERT INTO premietaciaSala (premietaciaSalaID,kapacita, projektor, kino)
VALUES (premietaciaSala_seq.nextval,272, 'Benq Q22000H', 'CineMax');

INSERT INTO premietaciaSala (premietaciaSalaID,kapacita, projektor, kino)
VALUES (premietaciaSala_seq.nextval,272, 'Benq Q22000H', 'CineMax');

INSERT INTO tableZanerFilm (nazovZanru,filmIdentifikator)
VALUES ('horror','2');

INSERT INTO tableZanerFilm (nazovZanru,filmIdentifikator)
VALUES ('thriller','1');


INSERT INTO tableZanerFilm (nazovZanru,filmIdentifikator)
VALUES ('thriller','1');

INSERT INTO projekcia (projekciaID,titulky, jazyk, datum, d3, projekciaFilm, projekciaSala)
VALUES (projekcia_seq.nextval,'CZ', 'anglicky', to_timestamp('2019-11-24:20:45:00', 'YYYY-MM-DD:HH24:MI:SS'), 'y', 1, 1);--1 by projekciaFilm is first inserted film,next value 1{last one| is last inserted "Sala"

INSERT INTO projekcia (projekciaID,titulky, jazyk, datum, d3, projekciaFilm, projekciaSala)
VALUES (projekcia_seq.nextval,'EN', 'slovensky', to_timestamp('2019-11-24:22:45:00', 'YYYY-MM-DD:HH24:MI:SS'), 'y', 2, 1);--1 by projekciaFilm is first inserted film,next value 1{last one| is last inserted "Sala"

INSERT INTO projekcia (projekciaID,titulky, jazyk, datum, d3, projekciaFilm, projekciaSala)
VALUES (projekcia_seq.nextval,'EN', 'anglicky', to_timestamp('2019-12-24:22:45:00', 'YYYY-MM-DD:HH24:MI:SS'), 'y', 1, 2);--1 by projekciaFilm is first inserted film,next value 1{last one| is last inserted "Sala"

INSERT INTO projekcia (projekciaID,titulky, jazyk, datum, d3, projekciaFilm, projekciaSala)
VALUES (projekcia_seq.nextval,'CZ', 'slovensky', to_timestamp('2019-11-24:20:45:00', 'YYYY-MM-DD:HH24:MI:SS'), 'y', 2, 2);--1 by projekciaFilm is first inserted film,next value 1{last one| is last inserted "Sala"


INSERT INTO sedadlo (sedadloID,rad, poradie, obsadenost, sedadloSala)
VALUES (sedadlo_seq.nextval,5, 22, 'n', 1);

INSERT INTO sedadlo (sedadloID,rad, poradie, obsadenost, sedadloSala)
VALUES (sedadlo_seq.nextval,5, 23, 'n', 1);

INSERT INTO sedadlo (sedadloID,rad, poradie, obsadenost, sedadloSala)
VALUES (sedadlo_seq.nextval,5, 24, 'n', 1);


INSERT INTO sedadlo (sedadloID,rad, poradie, obsadenost, sedadloSala)
VALUES (sedadlo_seq.nextval,5, 22, 'n', 2);

INSERT INTO sedadlo (sedadloID,rad, poradie, obsadenost, sedadloSala)
VALUES (sedadlo_seq.nextval,5, 23, 'n', 2);

INSERT INTO sedadlo (sedadloID,rad, poradie, obsadenost, sedadloSala)
VALUES (sedadlo_seq.nextval,5, 24, 'n', 2);

INSERT INTO klient (klientID, heslo, vek, status)
VALUES ('login123', 'fakepassword', 35, 'invalid');

INSERT INTO klient (klientID, heslo, vek, status)
VALUES ('Peter24', 'fakestPasword', 15, 'student');

INSERT INTO klient (klientID, heslo, vek, status)
VALUES ('Dracula69', 'beutifulPasword', 95, 'dochodca');

INSERT INTO rezervacia (rezervaciaID,cas, cena, rezervProjekcia, rezervSedadlo, rezervKlient)
VALUES (rezervacia_seq.nextval,to_timestamp('2019-11-21:09:22:43', 'YYYY-MM-DD:HH24:MI:SS'), 77.99, 1, 1, 'login123');

INSERT INTO rezervacia (rezervaciaID,cas, cena, rezervProjekcia, rezervSedadlo, rezervKlient)
VALUES (rezervacia_seq.nextval,to_timestamp('2019-11-21:19:22:43', 'YYYY-MM-DD:HH24:MI:SS'), 87.99, 2, 2, 'Peter24');

INSERT INTO rezervacia (rezervaciaID,cas, cena, rezervProjekcia, rezervSedadlo, rezervKlient)
VALUES (rezervacia_seq.nextval,to_timestamp('2019-11-21:09:22:43', 'YYYY-MM-DD:HH24:MI:SS'), 77.99, 3, 1, 'Dracula69');

INSERT INTO rezervacia (rezervaciaID,cas, cena, rezervProjekcia, rezervSedadlo, rezervKlient)
VALUES (rezervacia_seq.nextval,to_timestamp('2019-11-21:19:22:43', 'YYYY-MM-DD:HH24:MI:SS'), 87.99, 3, 2, 'Peter24');
--INSERT INTO vstupenka (vstupenkaID,casPredaja, cena, statusZakaznika, vstupenkaSedadlo, vstupenkaProjekcia)
--VALUES (vstupenka_seq.nextval,to_timestamp('2019-11-24:20:32:05', 'YYYY-MM-DD:HH24:MI:SS'), 77.99, 'invalid', 1, 1);

INSERT INTO vstupenka (vstupenkaID,casPredaja, cena, statusZakaznika, vstupenkaSedadlo, vstupenkaProjekcia)
VALUES (vstupenka_seq.nextval,to_timestamp('2019-11-24:20:32:05', 'YYYY-MM-DD:HH24:MI:SS'), 77.99, 'invalid', 1, 1);

INSERT INTO vstupenka (vstupenkaID,casPredaja, cena, statusZakaznika, vstupenkaSedadlo, vstupenkaProjekcia)
VALUES (vstupenka_seq.nextval,to_timestamp('2019-11-24:20:35:15', 'YYYY-MM-DD:HH24:MI:SS'), 79.99, 'student', 2, 1);

INSERT INTO vstupenka (vstupenkaID,casPredaja, cena, statusZakaznika, vstupenkaSedadlo, vstupenkaProjekcia)
VALUES (vstupenka_seq.nextval,to_timestamp('2019-11-24:20:37:34', 'YYYY-MM-DD:HH24:MI:SS'), 69.99, 'invalid', 4, 3);
INSERT INTO vstupenka (vstupenkaID,casPredaja, cena, statusZakaznika, vstupenkaSedadlo, vstupenkaProjekcia)
VALUES (vstupenka_seq.nextval,to_timestamp('2019-11-24:20:39:34', 'YYYY-MM-DD:HH24:MI:SS'), 99.99, 'student', 5, 4);
-----------------------------------INSERTION ENDS HERE------------
--Urcenie spravcu databazy
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

--should or should not be this commented? will be sequence used then?
/*
DROP SEQUENCE film_seq;
DROP SEQUENCE premietaciaSala_seq;
DROP SEQUENCE projekcia_seq;
DROP SEQUENCE sedadlo_seq;
DROP SEQUENCE rezervacia_seq;
DROP SEQUENCE vstupenka_seq;
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


