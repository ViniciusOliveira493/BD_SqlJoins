CREATE DATABASE bdProjetos
GO
USE bdProjetos
CREATE TABLE tbProjects(
	id						INTEGER			IDENTITY(10001,1)	NOT NULL
	,	projectName			VARCHAR(45)							NOT NULL
	,	projectDescription	VARCHAR(45)							
	,	projectDate			DATE								NOT NULL	CHECK(projectDate > '01/09/2014')
	PRIMARY KEY (id)
);
CREATE TABLE tbUsers(
	id						INTEGER			IDENTITY(1,1)		NOT NULL
	,	firstName			VARCHAR(45)							NOT NULL
	,	username			VARCHAR(45)		UNIQUE				NOT NULL
	,	passwd				VARCHAR(45)							NOT	NULL	DEFAULT('123mudar')
	,	email				VARCHAR(45)							NOT	NULL
	PRIMARY KEY (id)
);
CREATE TABLE tbUserHasProjcts(
	usersId					INTEGER								NOT NULL
	,	projectsId			INTEGER								NOT NULL
	PRIMARY KEY(usersId,projectsId)	
	FOREIGN KEY (usersId)			REFERENCES tbUsers(id)
	,	FOREIGN KEY (projectsId)	REFERENCES tbProjects(id)
);
--====================================MODIFICA��ES============================================
ALTER TABLE tbUsers
DROP CONSTRAINT UQ__tbUsers__F3DBC57207020F21
ALTER TABLE tbUsers
ALTER COLUMN username	VARCHAR(10) NOT NULL
ALTER TABLE tbUsers
ADD CONSTRAINT uniqueUserName UNIQUE (username)

ALTER TABLE tbUsers
ALTER COLUMN passwd			VARCHAR(8)		NOT	NULL
--======================================INSERTS USU�RIOS================================================
INSERT INTO tbUsers(firstName,username,email)
	VALUES
		('Maria','Rh_maria','maria@empresa.com')
INSERT INTO tbUsers(firstName,username,passwd,email)
	VALUES
		('Paulo','Ti_paulo','123@456','paulo@empresa')
INSERT INTO tbUsers(firstName,username,email)
	VALUES
		('Ana','Rh_ana','ana@empresa.com')
		,('Clara','Ti_clara','clara@empresa.com')
INSERT INTO tbUsers(firstName,username,passwd,email)
	VALUES
		('Aparecido','Rh_apareci','55@!cido','aparecido@empresa.com')

--=======================================INSERTS PROJETOS===============================
INSERT INTO tbProjects(projectName, projectDescription,projectDate)
	VALUES
		('Re-folha','Refatora��o das Folhas','05/09/2014')	
		,('Manuten��o PC''s','Manuten��o PC''s','06/09/2014')
		,('Auditoria',null,'07/09/2014')
--=======================================INSERTS USUARIO_PROJETOS=======================
INSERT INTO tbUserHasProjcts(usersId,projectsId)
	VALUES
		(1,10001)
		,(5,10001)
		,(3,10003)
		,(4,10002)
		,(2,10002)
--=======================================ALTERA��O DADOS================================
UPDATE tbProjects
SET projectDate = '12/09/2014'
WHERE id = 10002

UPDATE tbUsers
SET username = 'Rh_cido'
WHERE firstName = 'Aparecido'

UPDATE tbUsers
SET passwd = '888@*'
WHERE username = 'Rh_maria' AND passwd = '123mudar'

DELETE FROM tbUserHasProjcts
WHERE usersId = 2 AND projectsId = 10002

--===================
INSERT INTO tbUsers (firstName,username,passwd,email)
	VALUES 
		('Joao', 'Ti_joao', '123mudar', 'joao@empresa.com')

--==
INSERT INTO tbProjects(projectName,projectDescription,projectDate)
	VALUES
		('Atualiza��o de Sistemas', 'Modifica��o de Sistemas Operacionais nos PC''s', '12/09/2014')

--========================== CONSULTAS ===============================

--1) Id, Name e Email de Users, Id, Name, Description e Data de Projects, dos usu�rios que
--participaram do projeto Name Re-folha
SELECT 
	usr.id
	,	usr.firstName AS 'name'
	,	usr.email
	,	prj.id
	,	prj.projectName
	,	prj.projectDescription
	,	prj.projectDate
FROM tbUsers AS usr
	INNER JOIN tbUserHasProjcts usrp
		ON usr.id = usrp.usersId
	INNER JOIN tbProjects prj
		on prj.id = usrp.projectsId
WHERE prj.projectName = 'Re-folha'

--2) Name dos Projects que n�o tem Users
SELECT 
	prj.projectName
FROM tbProjects AS prj
	LEFT OUTER JOIN tbUserHasProjcts usrp
		ON prj.id = usrp.projectsId
WHERE usrp.projectsId IS NULL

-- 3) Name dos Users que n�o tem Projects

SELECT 
	usr.firstName
FROM tbUsers usr
	LEFT OUTER JOIN tbUserHasProjcts usrp
		ON usr.id = usrp.usersId
WHERE usrp.usersId IS NULL

