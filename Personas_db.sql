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

--  SP_ConsultaPersonalike: permitirá obtener los Datos de personas mediante LIKE en el atributo Apellido (@Apellido). 

CREATE PROCEDURE SP_ConsultaPersonalike (
    IN p_Apellido VARCHAR(50)
)
BEGIN
    SELECT Id, Apellido, Nombres, DNI, Domicilio, Telefono, FecHora_Registros, FecHora_Modificacion
    FROM Personas
    WHERE Apellido LIKE CONCAT('%', p_Apellido, '%') 
      AND Id_Estado = 1; -- Solo personas activas
END //

DELIMITER ;
--- fin --  SP_ConsultaPersonalike:

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

---consulta persona id---
DELIMITER //

CREATE PROCEDURE SP_ConsultaPersonaID (
    IN p_Id INT
)
BEGIN
    SELECT 
        Id,
        Apellido,
        Nombres,
        DNI,
        Domicilio,
        Telefono,
        Id_Estado,
        FecHora_Registro,
        FecHora_Modificacion
    FROM 
        Personas
    WHERE 
        Id = p_Id;
END //
---fin consulta persona id---
DELIMITER ;

-- Tabla Licencias
CREATE TABLE Licencias (
    Id_Licencia INT PRIMARY KEY AUTO_INCREMENT,
    Id_Persona INT,
    Fecha_Creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Nro_Art VARCHAR(20),
    Codigo VARCHAR(20),
    Diagnostico VARCHAR(255),
    Medico VARCHAR(50),
    Matricula VARCHAR(20),
    Establecimiento VARCHAR(50),
    Fecha_de_inicio DATE,
    Fecha_de_fin DATE,
    Cant_dias_licencias INT,
    Id_Estado_Licencia INT,
    Id_Estado_Registro INT DEFAULT 1,
    Observaciones VARCHAR(255),
    FOREIGN KEY (Id_Persona) REFERENCES Personas(Id_Persona)
);

-- Tabla Estados_Licencia
CREATE TABLE Estados_Licencia (
    Id_Estado_Licencia INT PRIMARY KEY AUTO_INCREMENT,
    Descripcion VARCHAR(255)
);

-- Tabla Estados_Registro
CREATE TABLE Estados_Registro (
    Id_Estado_Registro INT PRIMARY KEY AUTO_INCREMENT,
    Descripcion VARCHAR(255)
);



-- Tabla Usuarios
CREATE TABLE Usuarios (
    Id_Usuario INT PRIMARY KEY AUTO_INCREMENT,
    Apellido VARCHAR(50),
    Nombres VARCHAR(50),
    Password VARCHAR(32),
    Id_Tipo_Usuario INT DEFAULT 3,
    FecHora_Registros TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FecHora_Modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    Id_Estado_Registro INT DEFAULT 1
);

-- Tabla Tipo_Usuarios
CREATE TABLE Tipo_Usuarios (
    Id_Tipo_Usuario INT PRIMARY KEY,
    Descripcion VARCHAR(50)
);

-- Insertar valores por defecto en Tipo_Usuarios
INSERT INTO Tipo_Usuarios (Id_Tipo_Usuario, Descripcion) VALUES
(1, 'Administrador'),
(2, 'Supervisor'),
(3, 'Usuario');
