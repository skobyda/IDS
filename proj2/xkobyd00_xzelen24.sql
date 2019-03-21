-- TODO
-- Authors: Simon Kobyda(xkobyd00), Michal Zelenak(xzelen24)
-- IDS VUT FIT


--DATE,TIME,PK
--insert data into table
--creating connections and number them

--TEST IF THERE IS SOME TABLE and if do this 	°	
					/*drop table multikino;*/

--create table trzbyFilmu(datum Date, hodnota integer);  # BartÌk vravel ûe nemusÌme vytv·raù ûe sa to bude daù vyfiltrovaù z tej databazy
--create table trzbymultikina                            # Rovnako ako trzbyFilmu



--Start of the Script

--Creating tables
create table multikino(town varchar2(180), street varchar2(180), nameCin varchar2(50));
create table zanerFilmu(nazov varchar2(20), popis varchar2(300));
create table Film(rok number(4,0), klucslova varchar2(200), reziser varchar2(70), trvanie number(3,1), krajinaPovodu varchar2(50), vekoveObmedzenie number(2,0));
create table Zamestnanec (meno varchar2(120), priezvisko varchar2(120), Adresa varchar2(80), cisloUctu varchar2(24),hodinovaMzda number(4,3),pozicia varchar2(50));
create table Projekcia (titulky char(1),jazyk varchar2(80),datum date,d3 char(1));--,casZacatia time - mal by stacit date?
create table PremietaciaSala(kapacita number(4,0), projektor varchar2(50));
create table Rezervacia(cas Date,cena Number(4,3));
create table Sedadlo(sedadlo number(4,0),poradie number(4,0),obsadenost char(1));
create table Klient(Heslo varchar(50),vek number(3,0),status varchar(10));
create table Vstupenka(casPredaja date,cena number(4,3), statusZakaznika varchar(10));



--Destroying  Tables

drop table Vstupenka;
drop table Klient;
drop table Sedadlo;
drop table Rezervacia;
drop table PremietaciaSala;
drop table Projekcia;
drop table Zamestnanec;
drop table Film;
drop table zanerFilmu;
drop table multikino;