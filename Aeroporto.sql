CREATE DATABASE Aeroporto


CREATE TABLE Aereo(
	CodiceAereo INT IDENTITY(1,1),
	Tipo NVARCHAR(20) NOT NULL,
	NumeroPasseggeri INT NOT NULL,
	QuantitàMerci INT NOT NULL,
	CONSTRAINT PK_AEREO PRIMARY KEY (CodiceAereo),
	CONSTRAINT UQ_AEREO UNIQUE (Tipo)
);

CREATE TABLE Aeroporto(
	CodiceAeroporto INT IDENTITY(1,1),
	Nome NVARCHAR(20) NOT NULL,
	Città NVARCHAR(20) NOT NULL,
	Nazione NVARCHAR(20) NOT NULL,
	NumeroPiste INT,
	CONSTRAINT PK_AEROPORTO PRIMARY KEY (CodiceAeroporto)	
);


CREATE TABLE Volo(
	CodiceVolo NCHAR(5) NOT NULL,
	DataVolo DATE NOT NULL,
	OraPartenza TIME NOT NULL,
	OraArrivo TIME NOT NULL,
	CodiceAeroportoPartenza INT NOT NULL,	
	CodiceAeroportoArrivo INT NOT NULL,
	CodiceAereo INT not null,
	CONSTRAINT PK_VOLO PRIMARY KEY (CodiceVolo),
	CONSTRAINT FK_PARTENZA FOREIGN KEY (CodiceAeroportoPartenza) REFERENCES Aeroporto(CodiceAeroporto),
	CONSTRAINT FK_ARRIVO FOREIGN KEY (CodiceAeroportoArrivo)	REFERENCES Aeroporto (CodiceAeroporto),
	CONSTRAINT FK_AEREO FOREIGN KEY (CodiceAereo) REFERENCES Aereo (CodiceAereo)
);


INSERT INTO Aeroporto VALUES ('Fiuminicino', 'Roma', 'Italia', 8);
INSERT INTO Aeroporto VALUES ('Malpensa', 'Milano', 'Italia', 7);
INSERT INTO Aeroporto VALUES ('Ciampino', 'Napoli', 'Italia', 4);
INSERT INTO Aeroporto VALUES ('Napoli-Capodichino', 'Napoli', 'Italia', 5);
INSERT INTO Aeroporto VALUES ('Londra-Heathrow', 'Londra', 'Inghilterra', 8);
INSERT INTO Aeroporto VALUES ('Amsterdam-Schiphol', 'Amsterdam', 'Paesi Bassi', 8);
INSERT INTO Aeroporto VALUES ('JFK', 'New York', 'USA', 10);
INSERT INTO Aeroporto VALUES ('Tokyo-Haneda', 'Tokyo', 'Giappone', 7);
INSERT INTO Aeroporto (Nome, Città, Nazione) VALUES ('Pechino-O', 'Pechino', 'Cina');
INSERT INTO Aeroporto VALUES ('BOL', 'Bologna', 'Italia', 4);



INSERT INTO Aereo VALUES ('Boeing 747-400', 624, 300);
INSERT INTO Aereo VALUES ('Boeing 777-200', 440, 250);
INSERT INTO Aereo VALUES ('Airbus A321', 220, 100);
INSERT INTO Aereo VALUES ('Boeing 789-100', 420, 300);


INSERT INTO Volo VALUES ('AE123', '2021-12-05', '05:30', '16:30', 4, 6, 1);
INSERT INTO Volo VALUES ('AL146', '2021-11-16', '07:30', '13:30', 2, 4, 2);
INSERT INTO Volo VALUES ('BL123', '2021-10-01', '15:00', '13:30', 5, 3, 1);
INSERT INTO Volo VALUES ('BO980', '2022-01-01', '08:25', '13:30', 8, 1, 1);
INSERT INTO Volo VALUES ('CA145', '2022-03-12', '17:45', '13:30', 2, 7, 3);
INSERT INTO Volo VALUES ('CE003', '2021-11-10', '03:30', '13:30', 4, 8, 2);
INSERT INTO Volo VALUES ('RM123', '2021-10-22', '18:55', '13:30', 3, 1, 2);
INSERT INTO Volo VALUES ('LN156', '2022-02-01', '12:30', '13:30', 7, 2, 1);
INSERT INTO Volo VALUES ('AZ274', '2022-04-05', '15:30', '18:30', 1, 4, 1);
INSERT INTO Volo VALUES ('BL544', '2022-04-05', '18:30', '19:30', 10, 1, 4);
INSERT INTO Volo VALUES ('BL543', '2022-04-05', '18:30', '19:30', 5, 1, 4);
INSERT INTO Volo VALUES ('LM980', '2022-01-01', '08:25', '13:30', 5, 2, 1);

SELECT *
FROM Aereo

SELECT *
FROM Aeroporto

SELECT *
FROM Volo

--1)Le città con un aeroporto di cui non è noto il numero di piste (OK)
SELECT a.Città
FROM Aeroporto AS a
WHERE a.NumeroPiste IS NULL


--2)Le nazioni da cui parte e arriva il volo con codice AZ274 (OK)
SELECT aPart.Nazione AS 'Nazione Partenza', aArr.Nazione AS 'Nazione Arrivo'
FROM Volo AS v
JOIN Aeroporto AS aPart ON aPart.CodiceAeroporto = v.CodiceAeroportoPartenza
JOIN Aeroporto AS aArr ON aArr.CodiceAeroporto = v.CodiceAeroportoArrivo
WHERE v.CodiceVolo = 'AZ274' 


--3)I tipi di aereo usati nei voli che partono da Torino (OK)
SELECT a.Tipo
FROM Aereo AS a
JOIN Volo AS v ON v.CodiceAereo = a.CodiceAereo
JOIN Aeroporto AS ap ON ap.CodiceAeroporto = v.CodiceAeroportoPartenza
WHERE ap.Città = 'Torino'


--4)I tipi di aereo e il corrispondente numero di passeggeri per i tipi di aereo usati nei voli che partono da Torino. 
--  Se la descrizione dell'aereo non è disponibile, visualizzare solamente il tipo;  (OK)
SELECT DISTINCT a.Tipo, a.NumeroPasseggeri
FROM Aereo AS a
JOIN Volo AS v ON v.CodiceAereo = a.CodiceAereo
JOIN Aeroporto AS ap ON ap.CodiceAeroporto = v.CodiceAeroportoPartenza
WHERE ap.Città = 'Torino'
GROUP BY a.Tipo, a.NumeroPasseggeri


--5)Le città da cui partono voli internazionali
SELECT DISTINCT aPart.Città
FROM Volo AS v
JOIN Aeroporto AS aPart ON v.CodiceAeroportoPartenza = aPart.CodiceAeroporto
JOIN Aeroporto AS aArr ON v.CodiceAeroportoArrivo = aArr.CodiceAeroporto
WHERE aPart.Nazione <> aArr.Nazione



--6)Le città da cui partono voli diretti a Bologna, ordinate alfabeticamente;
SELECT DISTINCT aPart.Città AS 'Città di Partenza' 
FROM Volo AS v
JOIN Aeroporto AS aPart ON v.CodiceAeroportoPartenza = aPart.CodiceAeroporto
JOIN Aeroporto AS aArr ON v.CodiceAeroportoArrivo = aArr.CodiceAeroporto
WHERE aArr.Città = 'Bologna'
ORDER BY aPart.Città


--7)Il numero di voli internazionali che partono il giovedì da Napoli;
SELECT Count(*) AS 'Voli in partenza da Napoli il giovedì'
FROM Volo AS v
JOIN Aeroporto AS aPart ON v.CodiceAeroportoPartenza = aPart.CodiceAeroporto
JOIN Aeroporto AS aArr ON v.CodiceAeroportoArrivo = aArr.CodiceAeroporto
WHERE aPart.Città = 'Napoli' AND DATENAME(WEEKDAY, v.DataVolo) = 'thursday' AND aPart.Nazione <> aArr.Nazione


--8a)Il numero di voli che partono da città italiane
SELECT Count(*) AS 'Voli da città italiane'
FROM Volo AS v
JOIN Aeroporto AS ap ON ap.CodiceAeroporto = v.CodiceAeroportoPartenza
WHERE ap.Nazione = 'Italia'


--8b)Il numero di voli internazionali che partono da città italiane
SELECT Count(*) AS 'Numero Voli'
FROM Volo AS v
JOIN Aeroporto AS aPart ON v.CodiceAeroportoPartenza = aPart.CodiceAeroporto
JOIN Aeroporto AS aArr ON v.CodiceAeroportoArrivo = aArr.CodiceAeroporto
WHERE aPart.Nazione = 'Italia' AND aPart.Nazione <> aArr.Nazione


--9)Le città francesi da cui partono più di venti voli alla settimana diretti in Italia
SELECT DISTINCT aPart.Città
FROM Volo AS v
JOIN Aeroporto AS aPart ON v.CodiceAeroportoPartenza = aPart.CodiceAeroporto
JOIN Aeroporto AS aArr ON v.CodiceAeroportoArrivo = aArr.CodiceAeroporto
WHERE aPart.Nazione = 'Francia' AND aArr.Nazione = 'Italia'
GROUP BY aPart.Città
HAVING Count(*) > 20



--10)Gli aeroporti italiani che hanno solo voli interni.
SELECT DISTINCT aPart.* 
FROM Volo AS v
JOIN Aeroporto AS aPart ON v.CodiceAeroportoPartenza = aPart.CodiceAeroporto
JOIN Aeroporto AS aArr ON v.CodiceAeroportoArrivo = aArr.CodiceAeroporto
WHERE aArr.Nazione = 'Italia' AND aPart.Nazione = 'Italia' AND aPart.Città NOT IN 
(
SELECT DISTINCT aPart2.Città
FROM Volo AS v
JOIN Aeroporto AS aPart2 ON v.CodiceAeroportoPartenza = aPart2.CodiceAeroporto
JOIN Aeroporto AS aArr2 ON v.CodiceAeroportoArrivo = aArr2.CodiceAeroporto
WHERE aPart2.Nazione <> aArr2.Nazione
)


--11)Le città che sono servite dall'aereo caratterizzato dal massimo numero di passeggeri;
SELECT DISTINCT  ap.Città
FROM Aeroporto AS ap
JOIN Volo AS v ON v.CodiceAeroportoArrivo = ap.CodiceAeroporto
JOIN Aereo AS a ON v.CodiceAereo = a.CodiceAereo
WHERE a.NumeroPasseggeri =
(SELECT MAX(a.NumeroPasseggeri)
FROM Aereo AS a)
UNION
SELECT DISTINCT  ap.Città
FROM Aeroporto AS ap
JOIN Volo AS v ON v.CodiceAeroportoPartenza = ap.CodiceAeroporto
JOIN Aereo AS a ON v.CodiceAereo = a.CodiceAereo
WHERE a.NumeroPasseggeri =
(SELECT MAX(a.NumeroPasseggeri)
FROM Aereo AS a)


--12)La lista di tutti i tipi di aerei “Boeing”.
SELECT *
FROM Aereo AS a
WHERE a.Tipo like '%Boeing%'