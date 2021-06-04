--prikazati ime i prezime profesora engleskog jezika koji predaju bar jednom polazniku nekog od 
--kurseva engleskog jezika i rangirati ih prema broju polaznika i prikazati taj broj
create or replace view Rang_broj_polaznika (Ime, Prezime, Broj_polaznika) as
select imez Ime, prezz Prezime, count(*) Broj_polaznika
from profesor, zaposleni, kurs, pohadja
where 
    profesor.jmbgz in (select jmbgz from poznaje where sifjez = 'ENG')
    and profesor.jmbgz = zaposleni.jmbgz
    and kurs.jmbgz = profesor.jmbgz and kurs.sifjez = 'ENG'
    and kurs.idk = pohadja.idk
group by imez, prezz, profesor.jmbgz
having count(pohadja.jmbgz) > 0
order by Broj_polaznika desc;

--profesor koji je imao najveci broj casova u 2020. godini
select imez, prezz, count(*) Broj_casova
from zaposleni natural join profesor natural join cas natural join kurs
where datcas between '01-JAN-2020' and '31-DEC-2020'
group by imez, prezz, jmbgz
having count(*) >= all(select count(*) 
                    from cas natural join kurs 
                    where datcas between '01-JAN-2020' and '31-DEC-2020'
                    group by kurs.jmbgz)
