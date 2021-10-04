CREATE DATABASE Aeroporto


CREATE TABLE Aereo(
	CodiceAereo INT IDENTITY(1,1),
	Tipo NVARCHAR(20) NOT NULL,
	NumeroPasseggeri INT NOT NULL,
	Quantit‡Merci INT NOT NULL,
	CONSTRAINT PK_AEREO PRIMARY KEY (CodiceAereo),
	CONSTRAINT UQ_AEREO UNIQUE (Tipo)
);

CREATE TABLE Aeroporto(
	CodiceAeroporto INT IDENTITY(1,1),
	Nome NVARCHAR(5) NOT NULL,
	Citt‡ NVARCHAR(20) NOT NULL,
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


