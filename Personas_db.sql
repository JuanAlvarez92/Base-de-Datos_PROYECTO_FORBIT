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
    Id_Persona INT PRIMARY KEY AUTO_INCREMENT,
    Apellido VARCHAR(100),
    Nombres VARCHAR(100),
    DNI VARCHAR(20),
    Domicilio VARCHAR(255),
    Fecha_Nac DATE,
    Telefono VARCHAR(20),
    FecHora_Registros DATETIME DEFAULT CURRENT_TIMESTAMP,
    FecHora_Modificacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    Edad INT,
    Genero VARCHAR(50),
    Antiguedad INT,
    Email VARCHAR(100),
    Id_Reparticion INT,
    Id_Estado_Registro INT DEFAULT 1
);

-- Tabla Repartición
CREATE TABLE Reparticion (
    Id_Reparticion INT PRIMARY KEY AUTO_INCREMENT,
    Nombres VARCHAR(100),
    Descripcion VARCHAR(255),
    Id_Estado_Registro INT DEFAULT 1
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
-- Procedimientos Almacenados para la Tabla Personas:
DELIMITER $$
CREATE PROCEDURE SP_AgregarPersona (
    IN p_Apellido VARCHAR(50), 
    IN p_Nombres VARCHAR(50), 
    IN p_DNI VARCHAR(10), 
    IN p_Domicilio VARCHAR(100),
    IN p_Fecha_Nac DATE, 
    IN p_Telefono VARCHAR(15), 
    IN p_Edad INT, 
    IN p_Genero VARCHAR(10),
    IN p_Antiguedad INT,
    IN p_Email VARCHAR(100),
    IN p_Id_Reparticion INT
)
BEGIN
    INSERT INTO Personas (
        Apellido, Nombres, DNI, Domicilio, Fecha_Nac, Telefono, Edad, Genero, Antiguedad, Email, Id_Reparticion, FecHora_Registros, Id_Estado_Registro
    ) 
    VALUES (
        p_Apellido, p_Nombres, p_DNI, p_Domicilio, p_Fecha_Nac, p_Telefono, p_Edad, p_Genero, p_Antiguedad, p_Email, p_Id_Reparticion, CURRENT_TIMESTAMP, 1
    );
END $$
DELIMITER ;

-- Procedimientos Almacenados para la Tabla Personas:
DELIMITER $$
CREATE PROCEDURE SP_ConsultaPersonaID (IN p_Id_Persona INT)
BEGIN
    SELECT * FROM Personas WHERE Id_Persona = p_Id_Persona;
END $$
DELIMITER ;

-- Procedimientos Almacenados para la Tabla Personas:
DELIMITER $$
CREATE PROCEDURE SP_EliminarPersona (IN p_Id_Persona INT)
BEGIN
    UPDATE Personas 
    SET Id_Estado_Registro = 2, FecHora_Modificacion = CURRENT_TIMESTAMP 
    WHERE Id_Persona = p_Id_Persona;
END $$
DELIMITER ;

-- Procedimientos Almacenados para la Tabla Personas:
DELIMITER $$
CREATE PROCEDURE SP_ModificarPersona (
    IN p_Id_Persona INT,
    IN p_Apellido VARCHAR(50), 
    IN p_Nombres VARCHAR(50), 
    IN p_DNI VARCHAR(10), 
    IN p_Domicilio VARCHAR(100),
    IN p_Fecha_Nac DATE, 
    IN p_Telefono VARCHAR(15), 
    IN p_Edad INT, 
    IN p_Genero VARCHAR(10),
    IN p_Antiguedad INT,
    IN p_Email VARCHAR(100),
    IN p_Id_Reparticion INT
)
BEGIN
    UPDATE Personas
    SET Apellido = p_Apellido, Nombres = p_Nombres, DNI = p_DNI, Domicilio = p_Domicilio, 
        Fecha_Nac = p_Fecha_Nac, Telefono = p_Telefono, Edad = p_Edad, Genero = p_Genero, 
        Antiguedad = p_Antiguedad, Email = p_Email, Id_Reparticion = p_Id_Reparticion, 
        FecHora_Modificacion = CURRENT_TIMESTAMP
    WHERE Id_Persona = p_Id_Persona;
END $$
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
