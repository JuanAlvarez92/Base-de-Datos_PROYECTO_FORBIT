DROP DATABASE IF EXISTS Personas_db;
CREATE DATABASE Personas_db;
USE Personas_db;

-- Tabla Estados
CREATE TABLE IF NOT EXISTS Estados (
    Id_Estado INT PRIMARY KEY,
    Descripcion VARCHAR(50)
);

INSERT INTO Estados (Id_Estado, Descripcion) VALUES
(1, 'Activo'),
(2, 'Inactivo');

-- Tabla Personas
CREATE TABLE IF NOT EXISTS Personas (
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
    Id_Estado_Registro INT DEFAULT 1,
    FOREIGN KEY (Id_Estado_Registro) REFERENCES Estados(Id_Estado)
);

-- Tabla Reparticion
CREATE TABLE IF NOT EXISTS Reparticion (
    Id_Reparticion INT PRIMARY KEY AUTO_INCREMENT,
    Nombres VARCHAR(100),
    Descripcion VARCHAR(255),
    Id_Estado_Registro INT DEFAULT 1,
    FOREIGN KEY (Id_Estado_Registro) REFERENCES Estados(Id_Estado)
);

-- Tabla Estados_Licencia
CREATE TABLE IF NOT EXISTS Estados_Licencia (
    Id_Estado_Licencia INT PRIMARY KEY AUTO_INCREMENT,
    Descripcion VARCHAR(255)
);

-- Tabla Licencias
CREATE TABLE IF NOT EXISTS Licencias (
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
    FOREIGN KEY (Id_Persona) REFERENCES Personas(Id_Persona),
    FOREIGN KEY (Id_Estado_Registro) REFERENCES Estados(Id_Estado),
    FOREIGN KEY (Id_Estado_Licencia) REFERENCES Estados_Licencia(Id_Estado_Licencia)
);



-- Tabla Estados_Registro
CREATE TABLE IF NOT EXISTS Estados_Registro (
    Id_Estado_Registro INT PRIMARY KEY AUTO_INCREMENT,
    Descripcion VARCHAR(255)
);

-- Tabla Tipo_Usuarios
CREATE TABLE IF NOT EXISTS Tipo_Usuarios (
    Id_Tipo_Usuario INT PRIMARY KEY,
    Descripcion VARCHAR(50)
);

-- Insertar valores por defecto en Tipo_Usuarios
INSERT INTO Tipo_Usuarios (Id_Tipo_Usuario, Descripcion) VALUES
(1, 'Administrador'),
(2, 'Supervisor'),
(3, 'Usuario');

-- Tabla Usuarios
CREATE TABLE IF NOT EXISTS Usuarios (
    Id_Usuario INT PRIMARY KEY AUTO_INCREMENT,
    Apellido VARCHAR(50),
    Nombres VARCHAR(50),
    Password VARCHAR(32),
    Id_Tipo_Usuario INT DEFAULT 3,
    FecHora_Registros TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FecHora_Modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    Id_Estado_Registro INT DEFAULT 1, 
    FOREIGN KEY (Id_Tipo_Usuario) REFERENCES Tipo_Usuarios (Id_Tipo_Usuario),
    FOREIGN KEY (Id_Estado_Registro) REFERENCES Estados(Id_Estado)
);

-- Procedimiento para eliminar persona
DELIMITER $$
CREATE PROCEDURE SP_EliminarPersona (IN p_Id INT)
BEGIN
    UPDATE Personas
    SET Id_Estado_Registro = 2,
        FecHora_Modificacion = CURRENT_TIMESTAMP
    WHERE Id_Persona = p_Id;
END $$
DELIMITER ;

-- Procedimiento para registrar una persona
DELIMITER $$
CREATE PROCEDURE SP_RegistroPersona (
    IN p_Apellido VARCHAR(100),
    IN p_Nombres VARCHAR(100),
    IN p_DNI VARCHAR(20),
    IN p_Domicilio VARCHAR(255),
    IN p_Telefono VARCHAR(20),
    IN p_Id_Estado INT
)
BEGIN
    INSERT INTO Personas (Apellido, Nombres, DNI, Domicilio, Telefono, Id_Estado_Registro, FecHora_Registros)
    VALUES (p_Apellido, p_Nombres, p_DNI, p_Domicilio, p_Telefono, p_Id_Estado, NOW());
END $$
DELIMITER ;

-- Procedimiento para consultar personas activas
DELIMITER $$
CREATE PROCEDURE SP_ConsultaPersona()
BEGIN
    SELECT Id_Persona, Apellido, Nombres, DNI, Domicilio, Telefono, FecHora_Registros, FecHora_Modificacion
    FROM Personas
    WHERE Id_Estado_Registro = 1; -- Solo personas activas
END $$
DELIMITER ;

-- Procedimiento para editar una persona
DELIMITER $$
CREATE PROCEDURE SP_EditarPersona(
    IN PersonaId INT,
    IN p_Apellido VARCHAR(100),
    IN p_Nombres VARCHAR(100),
    IN p_DNI VARCHAR(20),
    IN p_Domicilio VARCHAR(255),
    IN p_Telefono VARCHAR(20)
)
BEGIN
    UPDATE Personas
    SET Apellido = p_Apellido, Nombres = p_Nombres, DNI = p_DNI, Domicilio = p_Domicilio, 
        Telefono = p_Telefono, FecHora_Modificacion = CURRENT_TIMESTAMP
    WHERE Id_Persona = PersonaId;
END $$
DELIMITER ;

-- Procedimiento para buscar persona por apellido (LIKE)
DELIMITER $$
CREATE PROCEDURE SP_ConsultaPersonalike (
    IN p_Apellido VARCHAR(100)
)
BEGIN
    SELECT Id_Persona, Apellido, Nombres, DNI, Domicilio, Telefono, FecHora_Registros, FecHora_Modificacion
    FROM Personas
    WHERE Apellido LIKE CONCAT('%', p_Apellido, '%') 
      AND Id_Estado_Registro = 1; -- Solo personas activas
END $$
DELIMITER ;

-- Procedimiento para consultar persona por DNI
DELIMITER $$
CREATE PROCEDURE SP_ConsultaPersonaDNI(
    IN DNI_Persona VARCHAR(20)
)
BEGIN
    SELECT * FROM Personas
    WHERE DNI = DNI_Persona;
END $$
DELIMITER ;

-- Procedimiento para consultar persona por ID
DELIMITER $$
CREATE PROCEDURE SP_ConsultaPersonaID (
    IN p_Id INT
)
BEGIN
    SELECT 
        Id_Persona,
        Apellido,
        Nombres,
        DNI,
        Domicilio,
        Telefono,
        Id_Estado_Registro,
        FecHora_Registros,
        FecHora_Modificacion
    FROM 
        Personas
    WHERE 
        Id_Persona = p_Id;
END $$
DELIMITER ;

-- Procedimiento para agregar repartición
DELIMITER $$
CREATE PROCEDURE SP_AgregarReparticion(
    IN p_Nombres VARCHAR(100),
    IN p_Descripcion VARCHAR(255)
)
BEGIN
    INSERT INTO Reparticion (Nombres, Descripcion)
    VALUES (p_Nombres, p_Descripcion);
END $$
DELIMITER ;

-- Procedimiento para consultar repartición por ID (solo activos)
DELIMITER $$
CREATE PROCEDURE SP_ConsultaReparticionID(IN p_Id_Reparticion INT)
BEGIN
    SELECT * FROM Reparticion 
    WHERE Id_Reparticion = p_Id_Reparticion 
    AND Id_Estado_Registro = 1;  -- Solo registros activos
END $$
DELIMITER ;

-- Procedimiento para eliminar repartición (cambiar estado a inactivo)
DELIMITER $$
CREATE PROCEDURE SP_EliminarReparticion(IN p_Id_Reparticion INT)
BEGIN
    UPDATE Reparticion 
    SET Id_Estado_Registro = 2  -- Cambiar a inactivo
    WHERE Id_Reparticion = p_Id_Reparticion;
END $$
DELIMITER ;

-- Procedimiento para modificar repartición
DELIMITER $$
CREATE PROCEDURE SP_ModificarReparticion(
    IN p_Id_Reparticion INT,
    IN p_Nombres VARCHAR(100),
    IN p_Descripcion VARCHAR(255)
)
BEGIN
    UPDATE Reparticion
    SET Nombres = p_Nombres,
        Descripcion = p_Descripcion,
        FecHora_Modificacion = CURRENT_TIMESTAMP  -- Actualizar la fecha de modificación
    WHERE Id_Reparticion = p_Id_Reparticion;
END $$
DELIMITER ;

-- Procedimiento para agregar licencia
DELIMITER $$
CREATE PROCEDURE SP_AgregarLicencia (
    IN p_Id_Persona INT, 
    IN p_Nro_Art VARCHAR(20), 
    IN p_Codigo VARCHAR(20), 
    IN p_Diagnostico TEXT, 
    IN p_Medico VARCHAR(50), 
    IN p_Matricula VARCHAR(20), 
    IN p_Establecimiento VARCHAR(50),
    IN p_Fecha_de_inicio DATE, 
    IN p_Fecha_de_fin DATE, 
    IN p_Cant_dias_licencias INT,
    IN p_Id_Estado_Licencia INT, 
    IN p_Observaciones TEXT
)
BEGIN
    INSERT INTO Licencias (Id_Persona, Nro_Art, Codigo, Diagnostico, Medico, Matricula, Establecimiento, Fecha_de_inicio, Fecha_de_fin, Cant_dias_licencias, Id_Estado_Licencia, Observaciones)
    VALUES (p_Id_Persona, p_Nro_Art, p_Codigo, p_Diagnostico, p_Medico, p_Matricula, p_Establecimiento, p_Fecha_de_inicio, p_Fecha_de_fin, p_Cant_dias_licencias, p_Id_Estado_Licencia, p_Observaciones);
END $$
DELIMITER ;
