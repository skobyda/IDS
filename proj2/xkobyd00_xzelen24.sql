--Authors: Simon Kobyda, Michal Zelenak
-- VUT FIT 2019 IDS

--TO DO
--TIME,

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
rodne_cislo char(11) primary key not null,
meno varchar2(120) not null,
priezvisko varchar2(120) not null,
Adresa varchar2(80) not null,
cisloUctu char(24),
hodinovaMzda number(4,3),
pozicia varchar2(50) not null,
Constraint pozicia_enum CHECK ( pozicia IN('pokladnik','veduci','majitel','vyhodeny'))
);


create table multikino
(
nameCin varchar2(50) Primary key not null,
mesto varchar2(180) NOT NULL, 
ulica varchar2(180),
zamestnanci char(11) Not null,
MultikinoSala number not null,
constraint FK_zamestMultikina FOREIGN KEY 
    (zamestnanci) REFERENCES Zamestnanec
    on delete cascade
);



create table zanerFilmu
(nazov varchar2(20) NOT NULL, 
popis varchar2(300),
--film number,
Constraint PK_zanerFilmu PRIMARY KEY (nazov) 
);



create table Film
(FilmID INT GENERATED AS IDENTITY PRIMARY KEY not null,
nazovFilmu varchar2(20) NOT NULL,
rok number(4,0),
klucslova varchar2(200),
reziser varchar2(70),
trvanie number(3,1),
krajinaPovodu varchar2(50),
vekoveObmedzenie number(2,0) not null,
FilmZaner varchar2(20),
FilmProjekcia number
/*CONSTRAINT FK_Film_zaner FOREIGn KEY
    (FilmZaner) REFERENCES zanerFilmu*/
);

create table zanerFilmu_Film
(
nazovZanru varchar2(20) not null,
FilmID number,
CONSTRAINT FK_Film_zaner FOREIGn KEY
    (nazovZanru) REFERENCES zanerFilmu,
CONSTRAINT FK_Film_ID FOREIGn KEY
    (FilmID) REFERENCES Film
);

/*
alter table zanerFilmu
ADD constraint FK_zanerFilmuFilm
    Foreign key (film)
    REFERENCES Film;*/

create table Projekcia 
(projekciaID INT GENERATED AS IDENTITY PRIMARY KEY,
titulky char(1),
jazyk varchar2(80),
datum date,
d3 char(1) not null,
ProjekciaRezervacia number,
ProjekciaVstupenka number not null
);
--,casZacatia time - mal by stacit date?

create table PremietaciaSala
(PremietaciaSalaID INT GENERATED AS IDENTITY PRIMARY KEY,
kapacita number(4,0),
projektor varchar2(50) not null,
SalaProjekcia number,
SalaSedadlo number not null,
constraint FK_SalaProjekcia Foreign key
    (SalaProjekcia) references Projekcia
    on delete cascade
);

create table Rezervacia
(RezervaciaID INT GENERATED AS IDENTITY PRIMARY KEY not null,
cas Date not null,
cena Number(4,3) not null
);

create table Sedadlo
(SedadloID INT GENERATED AS IDENTITY PRIMARY KEY,
rad number(4,0) not null,
poradie number(4,0) not null,
obsadenost char(1) not null,
SedadloRezervacia number,
SedadloVstupenka number,
constraint FK_SedadloRezervacia Foreign key
    (SedadloRezervacia) references Rezervacia
    on delete cascade
);

create table Klient
(KlientID varchar2(50) Primary Key not null,
Heslo varchar2(50) not null,
vek number(3,0) not null,
status varchar2(10) not null,
KlientRezervacia number,
Constraint status_enum CHECK ( status IN('dieùa','ötudent','dÙchodca','dospel˝','invalid')),
constraint FK_Klient_Rezervacia Foreign key
    (KlientRezervacia) references Rezervacia
    on delete cascade
);

create table Vstupenka
(VstupenkaID INT GENERATED AS IDENTITY PRIMARY KEY,
casPredaja date not null,
cena number(4,3) not null,
statusZakaznika varchar2(10) not null
);


--chybajuce v‰zby co treba urobit alter po tabulkach


    
alter table Film
ADD constraint FK_Projekcia_Film
    Foreign key (FilmProjekcia)
    REFERENCES Film
    on delete cascade;

alter table Multikino
ADD constraint FK_Multikino_Sala
    Foreign key (MultikinoSala)
    REFERENCES PremietaciaSala
    on delete cascade;

alter table Projekcia
ADD constraint FK_Projekcia_Rezervacia
    Foreign key (ProjekciaRezervacia)
    REFERENCES Projekcia
    on delete cascade;

alter table Projekcia
ADD constraint FK_Projekcia_Vstupenka
    Foreign key (ProjekciaVstupenka)
    REFERENCES Vstupenka; 
    --vstupenky po zmazani projekcie ostanu kvÙli vr·teniu peÚazÌ    
         
alter table PremietaciaSala
ADD constraint FK_Sala_Sedadlo
    Foreign key (SalaSedadlo)
    references Sedadlo
    on delete cascade;

alter table Sedadlo
ADD constraint FK_Vstupenka_Sedadlo
    Foreign key (SedadloVstupenka)
    references Vstupenka;


----------------------------INSERTION OF THE DATA STARTS HERE-----

-----------------------------------INSERTION ENDS HERE------------
--UrËenie spravcu databazy 
GRANT ALL ON Zamestnanec TO xkobyd00;
GRANT ALL ON Multikino TO xkobyd00;
GRANT ALL ON Rezervacia TO xkobyd00;
GRANT ALL ON ZanerFilmu TO xkobyd00;
GRANT ALL ON Film TO xkobyd00;
GRANT ALL ON Sedadlo TO xkobyd00;
GRANT ALL ON Vstupenka TO xkobyd00;
GRANT ALL ON PremietaciaSala TO xkobyd00;
GRANT ALL ON Projekcia TO xkobyd00;
GRANT ALL ON Klient TO xkobyd00;

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