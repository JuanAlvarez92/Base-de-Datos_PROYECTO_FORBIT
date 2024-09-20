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

--- editar persona
DELIMITER //
CREATE PROCEDURE SP_EditarPersona(
    IN PersonaId INT,
    IN Apellido VARCHAR(50),
    IN Nombres VARCHAR(50),
    IN DNI VARCHAR(20),
    IN Domicilio VARCHAR(100),
    IN Telefono VARCHAR(20),
    IN FecHora_Modificacion DATETIME
)
BEGIN
    UPDATE Personas
    SET Apellido = Apellido, Nombres = Nombres, DNI = DNI, Domicilio = Domicilio, 
        Telefono = Telefono, FecHora_Modificacion = FecHora_Modificacion
    WHERE Id = PersonaId;
END //
DELIMITER ;
--- fin editar persona