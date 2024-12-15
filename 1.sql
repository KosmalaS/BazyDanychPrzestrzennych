CREATE SCHEMA ksiegowosc;
CREATE TABLE ksiegowosc.Pracownicy(
	id_pracownika SERIAL PRIMARY KEY,
	imie VARCHAR(20) NOT NULL,
	nazwisko VARCHAR(50) NOT NULL,
	adres VARCHAR(100),
	telefon VARCHAR(12)
);

CREATE TABLE ksiegowosc.Godziny(
	id_godziny SERIAL PRIMARY KEY,
	data_ DATE NOT NULL,
	liczba_godzin INT CHECK (liczba_godzin > 0),
	id_pracownika INT,
	FOREIGN KEY(id_pracownika) REFERENCES ksiegowosc.Pracownicy(id_pracownika)
);

CREATE TABLE ksiegowosc.Pensja(
	id_pensji SERIAL PRIMARY KEY,
	stanowisko VARCHAR(100) NOT NULL,
	kwota DECIMAL(10, 2) CHECK (kwota > 0)
);

CREATE TABLE ksiegowosc.Premia(
	id_premii SERIAL PRIMARY KEY,
	rodzaj VARCHAR(40),
	kwota DECIMAL(10, 2) CHECK (kwota >= 0)
);

CREATE TABLE ksiegowosc.Wynagrodzenie(
	id_wynagrodzenia SERIAL PRIMARY KEY,
	data_ DATE NOT NULL,
	id_pracownika INT,
	FOREIGN KEY(id_pracownika) REFERENCES ksiegowosc.Pracownicy(id_pracownika),
	id_godziny INT,
	FOREIGN KEY(id_godziny) REFERENCES ksiegowosc.Godziny(id_godziny),
	id_pensji INT,
	FOREIGN KEY(id_pensji) REFERENCES ksiegowosc.Pensja(id_pensji),
	id_premii INT,
	FOREIGN KEY(id_premii) REFERENCES ksiegowosc.Premia(id_premii)
);

COMMENT ON TABLE ksiegowosc.pracownicy IS 'Tabela przechowuje informacje o pracownikach, w tym dane kontaktowe';
COMMENT ON TABLE ksiegowosc.godziny IS 'Tabela przechowuje informacje o przepracowanych godzinach przez pracowników';
COMMENT ON TABLE ksiegowosc.pensja IS 'Tabela przechowuje informacje o stanowiskach i pensjach';
COMMENT ON TABLE ksiegowosc.premia IS 'Tabela przechowuje informacje o premiach';
COMMENT ON TABLE ksiegowosc.wynagrodzenie IS 'Tabela przechowuje informacje o wynagrodzeniach pracowników';

SELECT conname FROM pg_constraint WHERE conrelid = 'ksiegowosc.Premia'::regclass;

ALTER TABLE ksiegowosc.premia

DROP CONSTRAINT premia_kwota_check;

ALTER TABLE ksiegowosc.Premia ALTER COLUMN rodzaj DROP NOT NULL;

ALTER TABLE ksiegowosc.Premia

ADD CONSTRAINT premia_kwota_check CHECK (kwota >= 0.00);


INSERT INTO ksiegowosc.Pracownicy (imie, nazwisko, adres, telefon) VALUES
('Jan', 'Kowalski', 'Kraków, ul. Kwiatowa 5', '123456789'),
('Anna', 'Nowak', 'Kraków, ul. Zielona 10', '987654321'),
('Piotr', 'Wiśniewski', 'Kraków, ul. Piaskowa 12', '555666777'),
('Maria', 'Wójcik', 'Kraków, ul. Słoneczna 8', '888999000'),
('Jacek', 'Kowalczyk', 'Kraków, ul. Leśna 2', '777888999'),
('Ewa', 'Zielińska', 'Kraków, ul. Krótka 3', '666777888'),
('Tomasz', 'Kamiński', 'Kraków, ul. Jasna 1', '555444333'),
('Katarzyna', 'Lewandowska', 'Kraków, ul. Spokojna 15', '444333222'),
('Michał', 'Zając', 'Kraków, ul. Długa 7', '222333444'),
('Agnieszka', 'Szymańska', 'Kraków, ul. Miodowa 11', '111222333');

INSERT INTO ksiegowosc.Godziny (data_, liczba_godzin, id_pracownika) VALUES
('2024-10-01', 160, 1),
('2024-10-01', 170, 2),
('2024-10-01', 160, 3),
('2024-10-01', 165, 4),
('2024-10-01', 160, 5),
('2024-10-02', 180, 6),
('2024-10-02', 160, 7),
('2024-10-02', 165, 8),
('2024-10-02', 160, 9),
('2024-10-02', 167, 10);

INSERT INTO ksiegowosc.Pensja (stanowisko, kwota) VALUES
('Księgowy', 5000.00),
('Asystent', 1800.00),
('Menadżer', 7000.00),
('Specjalista', 4500.00),
('Dyrektor', 10000.00),
('Menadżer', 6000.00),
('Asystent', 2800.00),
('Specjalista', 3500.00),
('Handlowiec', 4800.00),
('Specjalista', 5200.00);

INSERT INTO ksiegowosc.Premia (rodzaj, kwota) VALUES
('Roczna', 1000.00),
(NULL, 0.00),
('Kwartalna', 500.00),
('Specjalna', 800.00),
(NULL, 0.00),
('Okazjonalna', 200.00),
('Uznaniowa', 700.00),
('Zadaniowa', 400.00),
('Frekwencyjna', 300.00),
(NULL, 0.00);

INSERT INTO ksiegowosc.Wynagrodzenie (data_, id_pracownika, id_godziny, id_pensji, id_premii) VALUES
('2024-10-01', 1, 1, 1, 1),
('2024-10-01', 2, 2, 2, 2),
('2024-10-01', 3, 3, 3, 3),
('2024-10-01', 4, 4, 4, 4),
('2024-10-01', 5, 5, 5, 5),
('2024-10-01', 6, 6, 6, 6),
('2024-10-01', 7, 7, 7, 7),
('2024-10-01', 8, 8, 8, 8),
('2024-10-01', 9, 9, 9, 9),
('2024-10-01', 10, 10, 10, 10);


--a
SELECT id_pracownika, nazwisko FROM ksiegowosc.Pracownicy;

--b
SELECT w.id_pracownika
FROM ksiegowosc.Wynagrodzenie AS w
JOIN ksiegowosc.Pensja p ON p.id_pensji=w.id_pensji
WHERE p.kwota > 2000;

--c
SELECT w.id_pracownika
FROM ksiegowosc.Wynagrodzenie AS w
JOIN ksiegowosc.Pensja AS pen ON pen.id_pensji=w.id_pensji
JOIN ksiegowosc.Premia AS pre ON pre.id_premii=w.id_premii
WHERE pre.Kwota=0 AND pen.kwota>2000;

--d
SELECT p.imie, p.nazwisko 
FROM ksiegowosc.Pracownicy AS p
WHERE p.imie LIKE 'J%'

--e
SELECT p.imie, p.nazwisko
FROM ksiegowosc.Pracownicy as p
WHERE p.nazwisko LIKE '%n%' AND p.imie LIKE '%a'

--f
SELECT pr.imie, pr.nazwisko, g.liczba_godzin-160 AS liczba_nadgodzin
FROM ksiegowosc.Pracownicy AS pr
JOIN ksiegowosc.Wynagrodzenie AS w ON pr.id_pracownika=w.id_pracownika
JOIN ksiegowosc.Godziny AS g on g.id_pracownika=w.id_pracownika
WHERE g.liczba_godzin > 160

--g
SELECT pr.imie, pr.nazwisko
FROM ksiegowosc.Pracownicy AS pr
JOIN ksiegowosc.Wynagrodzenie AS w ON w.id_pracownika=pr.id_pracownika
JOIN ksiegowosc.Pensja AS pen ON pen.id_pensji=w.id_pensji
WHERE pen.kwota > 1500 AND pen.kwota<3000;

--h
SELECT pr.imie, pr.nazwisko
FROM ksiegowosc.Pracownicy AS pr
JOIN ksiegowosc.Wynagrodzenie AS w ON w.id_pracownika=pr.id_pracownika
JOIN ksiegowosc.Premia AS pre ON pre.id_premii=w.id_premii
JOIN ksiegowosc.godziny AS g ON w.id_godziny=g.id_godziny
WHERE g.liczba_godzin>160 AND pre.kwota=0;

--i
SELECT pr.imie, pr.nazwisko, pen.kwota
FROM ksiegowosc.Pracownicy AS pr
JOIN ksiegowosc.Wynagrodzenie AS w ON w.id_pracownika=pr.id_pracownika
JOIN ksiegowosc.Pensja AS pen ON pen.id_pensji=w.id_pensji
ORDER BY pen.kwota DESC;

--j
SELECT pr.imie, pr.nazwisko, pen.kwota, pre.kwota
FROM ksiegowosc.Pracownicy AS pr
JOIN ksiegowosc.Wynagrodzenie AS w ON w.id_pracownika=pr.id_pracownika
JOIN ksiegowosc.Pensja AS pen ON pen.id_pensji=w.id_pensji
JOIN ksiegowosc.Premia AS pre ON pre.id_premii=w.id_premii
ORDER BY pen.kwota DESC, pre.kwota DESC;

--k
SELECT p.stanowisko, COUNT(p.stanowisko)
FROM ksiegowosc.Pensja AS p
JOIN ksiegowosc.Wynagrodzenie AS w ON w.id_pensji=p.id_pensji
GROUP BY p.stanowisko;

--l
SELECT p.stanowisko, ROUND(AVG(p.kwota), 0), ROUND(MIN(p.kwota)), ROUND(MAX(p.kwota))
FROM ksiegowosc.Pensja AS p
JOIN ksiegowosc.Wynagrodzenie AS w ON w.id_pensji=p.id_pensji
WHERE p.stanowisko='Specjalista'
GROUP BY p.stanowisko;

--m
SELECT SUM(p.kwota)
FROM ksiegowosc.Pensja AS p;

--n
SELECT p.stanowisko, SUM(p.kwota)
FROM ksiegowosc.Pensja AS p
JOIN ksiegowosc.Wynagrodzenie AS w ON w.id_pensji=p.id_pensji
GROUP BY p.stanowisko;

--o
SELECT p.stanowisko, COUNT(pre.kwota)
FROM ksiegowosc.Pensja AS p
JOIN ksiegowosc.Wynagrodzenie AS w ON w.id_pensji=p.id_pensji
JOIN ksiegowosc.Premia AS pre ON w.id_premii=pre.id_premii
WHERE pre.kwota>0
GROUP BY p.stanowisko;

--p
ALTER TABLE ksiegowosc.Wynagrodzenie
DROP CONSTRAINT wynagrodzenie_id_pensji_fkey;
ALTER TABLE ksiegowosc.Wynagrodzenie
ADD CONSTRAINT wynagrodzenie_id_pensji_fkey
FOREIGN KEY (id_pensji) REFERENCES ksiegowosc.Pensja(id_pensji)
ON DELETE CASCADE;

DELETE FROM ksiegowosc.Pensja AS p WHERE p.kwota < 2000;