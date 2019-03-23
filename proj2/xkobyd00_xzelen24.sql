--DATE,TIME,PK
--TEST IF THERE IS SOME TABLE
--pull datas into table
--creating connections and number them
--hotovo Zamestnanec, 
/*
drop table multikino;
drop table Zamestnanec;
/**/

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
    EXECUTE immediate 'DROP TABLE Vstupenka CASCADE CONSTRAINTS';
    EXCEPTION WHEN others THEN NULL;
END;
/
BEGIN 
    EXECUTE immediate 'DROP TABLE Multikino CASCADE CONSTRAINTS';
    EXCEPTION WHEN others THEN NULL;
END;
/




create table Zamestnanec 
(
rodne_cislo char(11),
meno varchar2(120),
priezvisko varchar2(120),
Adresa varchar2(80),
cisloUctu char(24),
hodinovaMzda number(4,3),
pozicia varchar2(50),
Zam varchar2(50),
Constraint PK_zamestnanec PRIMARY KEY (rodne_cislo),
Constraint pozicia_enum CHECK ( pozicia IN('pokladnik','veduci','majitel','vyhodeny'))
);


create table multikino
(
nameCin varchar2(50) not null,
town varchar2(180) NOT NULL, 
street varchar2(180),
zamestn char(11),
constraint PK_multikino PRIMARY KEY (nameCin),
constraint FK_zamestMultikina FOREIGN KEY 
    (zamestn) REFERENCES Zamestnanec
);




create table zanerFilmu
(nazov varchar2(20) NOT NULL, 
popis varchar2(300),
film number,
Constraint PK_zanerFilmu PRIMARY KEY (nazov)
);

create table Film
(
FilmID INT GENERATED AS IDENTITY PRIMARY KEY,
rok number(4,0),
klucslova varchar2(200),
reziser varchar2(70),
trvanie number(3,1),
krajinaPovodu varchar2(50),
vekoveObmedzenie number(2,0),
nazovFilmu varchar2(20) NOT NULL, 
zaner varchar2(20),
CONSTRAINT FK_Film_zaner FOREIGn KEY
    (zaner) REFERENCES zanerFilmu
);


create table Projekcia 
(projekciaID INT GENERATED AS IDENTITY PRIMARY KEY,
titulky char(1),
jazyk varchar2(80),
datum date,d3 char(1)
);--,casZacatia time - mal by stacit date?

create table PremietaciaSala
(PremietaciaSalaID INT GENERATED AS IDENTITY PRIMARY KEY,
kapacita number(4,0),
projektor varchar2(50)
);

create table Rezervacia
(RezervaciaID INT GENERATED AS IDENTITY PRIMARY KEY,
cas Date,
cena Number(4,3));

create table Sedadlo
(SedadloID INT GENERATED AS IDENTITY PRIMARY KEY,
sedadlo number(4,0),
poradie number(4,0),
obsadenost char(1)
);

create table Klient
(KlientID INT GENERATED AS IDENTITY PRIMARY KEY,
Heslo varchar(50),
vek number(3,0),
status varchar(10)
);

create table Vstupenka
(VstupenkaID INT GENERATED AS IDENTITY PRIMARY KEY,
casPredaja date,
cena number(4,3),
statusZakaznika varchar(10)
);


--chybajuce väzby co treba urobit alter po tabulkach
/**
multikino prevadzkuje

*/
alter table Zamestnanec 
ADD constraint FK_nameOfCinema
    Foreign key (Zam) 
    REFERENCES Multikino
    on delete cascade;

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