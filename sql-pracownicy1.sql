-- 1.Tworzy tabelę pracownik(imie, nazwisko, wyplata, data urodzenia, stanowisko). W tabeli mogą być dodatkowe kolumny, które uznasz za niezbędne.
CREATE TABLE pracownik (
id BIGINT PRIMARY KEY AUTO_INCREMENT,
imie VARCHAR(30) NOT NULL,
nazwisko VARCHAR(30) NOT NULL,
wyplata DECIMAL(8,2) NOT NULL,
data_urodzenia DATE NOT NULL,
stanowisko VARCHAR(50) NOT NULL
);

-- 2. Wstawia do tabeli co najmniej 6 pracowników
INSERT INTO pracownik(imie, nazwisko, wyplata, data_urodzenia, stanowisko)
VALUES ('Andrzej', 'Malolepszy', 25000.00, '1981-02-05', 'szef'),
('Wladyslaw', 'Trochegorszy', 19500.00, '1985-04-19', 'prezes'),
('Halina', 'Dosctaka', 19500.00, '1989-12-12', 'dyrektor'),
('Lucyna', 'Szczupla', 8250.00, '1986-06-02', 'kierownik'),
('Mateusz', 'Ambitny', 3200.00, '1986-06-02', 'kierowca'), 
('Lucjan', 'Sprytny', 3250.00, '1995-11-17', 'kierowca');

-- 3.Pobiera wszystkich pracowników i wyświetla ich w kolejności alfabetycznej po nazwisku
SELECT * FROM pracownik ORDER BY nazwisko;

-- 4.Pobiera pracowników na wybranym stanowisku
SELECT * FROM pracownik WHERE stanowisko = 'kierowca'; 

-- 5. Pobiera pracowników, którzy mają co najmniej 30 lat
SELECT * FROM pracownik
WHERE ABS(DATEDIFF(data_urodzenia, CURDATE()) / 365) >= 30;

-- 6.Zwiększa wypłatę pracowników na wybranym stanowisku o 10%
UPDATE pracownik SET wyplata = wyplata * 1.1 WHERE stanowisko = 'prezes';

-- 7.Pobiera najmłodszego pracowników (uwzględnij przypadek, że może być kilku urodzonych tego samego dnia)
SELECT * FROM pracownik WHERE data_urodzenia = (SELECT MAX(data_urodzenia) FROM pracownik);

-- 8.Usuwa tabelę pracownik
DROP TABLE pracownik;

-- 9.Tworzy tabelę stanowisko (nazwa stanowiska, opis, wypłata na danym stanowisku)
CREATE TABLE stanowisko (
id BIGINT PRIMARY KEY AUTO_INCREMENT,
nazwa_stanowiska VARCHAR(50) NOT NULL,
opis_stanowiska VARCHAR(200) NOT NULL,
wyplata DECIMAL(8,2) NOT NULL
);

-- 10. Tworzy tabelę adres (ulica+numer domu/mieszkania, kod pocztowy, miejscowość)
CREATE TABLE adres (
id BIGINT PRIMARY KEY AUTO_INCREMENT,
ulica_numer VARCHAR(50) NOT NULL,
kod_pocztowy VARCHAR(6) NOT NULL,
miejscowosc VARCHAR(40) NOT NULL
);

-- 11. Tworzy tabelę pracownik (imię, nazwisko) + relacje do tabeli stanowisko i adres
CREATE TABLE pracownik (
id BIGINT PRIMARY KEY AUTO_INCREMENT,
imie VARCHAR(20) NOT NULL,
nazwisko VARCHAR(20) NOT NULL
);

-- 12.Dodaje dane testowe (w taki sposób, aby powstały pomiędzy nimi sensowne powiązania)
INSERT INTO pracownik(imie, nazwisko)
VALUES ('Andrzej', 'Malolepszy'),
('Halina', 'Dosctaka'),
('Mateusz', 'Lakomy');

INSERT INTO adres(ulica_numer, kod_pocztowy, miejscowosc)
VALUES ('Dlugosza 7', '41-219', 'Sosnowiec'),
('Ćwiartki 3/4', '45-573', 'Wrocław'),
('Krasickiego', '45-573', 'Wrocław');

INSERT INTO stanowisko(nazwa_stanowiska, opis_stanowiska, wyplata)
VALUES ('prezes', 'rządzi i dzieli', 8500.00),
('kierownik', 'posluchaj prezesa, zarządz kierowcami', 5200.00),
('kierowca', 'przywiez, zawiez, nie zabłądz', 3200.00);

ALTER TABLE pracownik
ADD stanowisko_id BIGINT, 
ADD FOREIGN KEY (stanowisko_id) REFERENCES stanowisko(id);
 
UPDATE pracownik SET stanowisko_id = 2 WHERE id = 1;
UPDATE pracownik SET stanowisko_id = 1 WHERE id IN (2, 3);

ALTER TABLE adres
ADD pracownik_id BIGINT UNIQUE,
ADD FOREIGN KEY (pracownik_id) REFERENCES pracownik(id);

UPDATE adres SET pracownik_id = 1 WHERE id = 1;
UPDATE adres SET pracownik_id = 2 WHERE id = 2;
UPDATE adres SET pracownik_id = 3 WHERE id = 3;

-- 13.Pobiera pełne informacje o pracowniku (imię, nazwisko, adres, stanowisko)
SELECT pracownik.imie,
pracownik.nazwisko,
adres.ulica_numer,
adres.kod_pocztowy,
adres.miejscowosc,
stanowisko.nazwa_stanowiska
FROM pracownik
JOIN adres
	ON pracownik.id = adres.pracownik_id
JOIN stanowisko
	ON pracownik.stanowisko_id = stanowisko.id;
    
-- 14. Oblicza sumę wypłat dla wszystkich pracowników w firmie
SELECT sum(wyplata)
FROM pracownik
JOIN stanowisko
	ON pracownik.stanowisko_id = stanowisko.id;
    
-- 15. Pobiera pracowników mieszkających w lokalizacji z kodem pocztowym 90210 (albo innym, który będzie miał sens dla Twoich danych testowych)
SELECT *
FROM pracownik 
JOIN adres
	ON pracownik.id = adres.pracownik_id
WHERE kod_pocztowy = '45-573'; 
