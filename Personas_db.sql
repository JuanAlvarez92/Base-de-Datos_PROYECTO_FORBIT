CREATE DATABASE Personas_db;
USE Personas_db;

CREATE TABLE Estados (
    Id_Estado INT PRIMARY KEY,
    Descripcion VARCHAR(50)
);

INSERT INTO Estados (Id_Estado, Descripcion) VALUES
(1, 'Activo'),
(2, 'Inactivo');

CREATE TABLE Personas (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Apellido VARCHAR(50),
    Nombres VARCHAR(50),
    DNI VARCHAR(20),
    Domicilio VARCHAR(100),
    Telefono VARCHAR(20),
    Id_Estado INT,
    FecHora_Registros DATETIME,
    FecHora_Modificacion DATETIME,
    FOREIGN KEY (Id_Estado) REFERENCES Estados(Id_Estado)
);

-- Consultar Persona
DELIMITER //
CREATE PROCEDURE SP_ConsultaPersona ()
BEGIN
    SELECT Id, Apellido, Nombres, DNI, Domicilio, Telefono, FecHora_Registro, FecHora_Modificacion
    FROM Personas
    WHERE Id_Estado = 1; -- Solo las personas activas
END //
DELIMITER ;
-- Fin consultar Persona

