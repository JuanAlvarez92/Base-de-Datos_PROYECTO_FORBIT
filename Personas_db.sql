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
/* Este linea de codigo permite realizar la baja logica en el servidor*/
DELIMITER $$
CREATE PROCEDURE SP_EliminarPersona (
    IN p_Id INT
)
BEGIN
    UPDATE Personas
    SET Id_Estado = 2,
        FecHora_Modificacion = CURRENT_TIMESTAMP
    WHERE Id = p_Id;
END $$
DELIMITER ;

-- Crear Procedimiento Almacenado para registrar una persona
DELIMITER //

CREATE PROCEDURE SP_RegistroPersona (
    IN p_Apellido VARCHAR(50),
    IN p_Nombres VARCHAR(50),
    IN p_DNI VARCHAR(20),
    IN p_Domicilio VARCHAR(100),
    IN p_Telefono VARCHAR(20),
    IN p_Id_Estado INT
)
BEGIN
    INSERT INTO Personas (Apellido, Nombres, DNI, Domicilio, Telefono, Id_Estado, FecHora_Registros)
    VALUES (p_Apellido, p_Nombres, p_DNI, p_Domicilio, p_Telefono, p_Id_Estado, NOW());
END //

DELIMITER ;


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
---consulta persona---
DELIMITER //
CREATE PROCEDURE SP_ConsultaPersonaDNI(
    IN DNI_Persona VARCHAR(20)
)
BEGIN
    SELECT * FROM Personas
    WHERE DNI = DNI_Persona;
END //
DELIMITER ;