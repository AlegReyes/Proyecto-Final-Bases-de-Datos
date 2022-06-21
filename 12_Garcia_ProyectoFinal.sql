--Proyecto Final
--Grupo:4 Bases de Datos
--Alejandro Garcia Reyes 
--Fecha Entrega:11/06/2020

CREATE DATABASE EnviosFinal--Creamos la base de Datos
Use EnviosFinal---Seleccionamos la base de datos

--Creamos las tablas en orden para no tener problemas.
-------Tabla 1
Create Table Envios(
	EnvioID varchar(10) NOT NULL PRIMARY KEY,
	TipoEnvio varchar(1) NOT NULL
);

-------2
	Create Table Compania_Local(
	CompaniaID varchar(15) NOT NULL PRIMARY KEY,
	Nombre varchar(30)  
);
-------3
Create Table Camion(
	Placa varchar(10) NOT NULL PRIMARY KEY,
	Carga_Maxima_Kg int,
	Ciudad_Resguardo varchar(20)
);

--------4
Create Table Conductor(
	RFC varchar(15) NOT NULL PRIMARY KEY,
	Nombre varchar(40),
	Direccion varchar(40), 
);
---5
Create Table EnvioInternacional(
    EnvioID varchar(10) REFERENCES Envios,
	Peso char(10) ,
	Direccion varchar(40),
	Destinatario varchar(50),
	Codigo_Com varchar(15) REFERENCES Compania_Local, 
	Linea_Aerea varchar(15),
	Fecha__Entrega date,
	PRIMARY KEY (EnvioID)
);

---6
Create Table RutaNacional(
	Id_Ruta int PRIMARY KEY,
	Ruta varchar(30)
);

----7
Create Table EnvioNacional(
    EnvioID varchar(10) REFERENCES Envios,  
	Peso char(10) ,
	Direccion varchar(40),
	Destinatario varchar(50),
	CiudadDestino varchar(20),
	RFC_Conductor varchar(15) REFERENCES Conductor,
	Rutas int REFERENCES RutaNacional,
	PRIMARY KEY (EnvioID)
);

---8
Create Table Conductor_Camion(
	RFC_Conductor varchar(15) REFERENCES Conductor,
	Placa_Camion varchar(10) REFERENCES Camion,
	Fecha Date,
	Constraint Conduc_Cami PRIMARY KEY CLUSTERED (RFC_Conductor,Placa_Camion)

);

---9
Create Table RutaConductor(
	RFC_Conductor varchar(15) REFERENCES Conductor,
	Ruta varchar(30)
);

--Esta tabla es parte del trigger DPNacional2
CREATE TABLE RegistrosNacional(
	EnvioID nvarchar(10),
	CiudadDestino nvarchar(30)
);


---Insercion de los valores de las tablas
INSERT INTO Envios(EnvioID,TipoEnvio)
VALUES('0001','N'),('0002','N'),('0003','N'),('0004','N'),('0005','I'),('0006','I'),('0007','I'),('0008','I')

INSERT INTO Compania_Local(CompaniaID,Nombre)
VALUES ('777','Astaroth'),('666','Samael'),('555','Belial'),('444','Ludociel');


INSERT INTO Camion(Placa,Carga_Maxima_Kg,Ciudad_Resguardo)
VALUES  ('HOMMY13A',300,'Ciudad de Mexico'),('CHOLO13C',300,'Monterrey'),
		('MICLO22B',300,'Cancun'),('CRUZITO25C',300,'Tijuana');

INSERT INTO Conductor(RFC,Nombre,Direccion)
VALUES  ('AS12DSFS','Armando Lios','Campeche,La Era N0.25'),('A1223GMB','Armando Carros','Yucatan,San tomas N0.10'),
		('FDSFDF43','Armando Porros','Cancun,San Pedro N0.32'),('GRAT1223R','Armando Tortas','Sinaloa,San Cuco N0.11');

INSERT INTO EnvioInternacional(EnvioID,Peso,Direccion,Destinatario,Codigo_Com,Linea_Aerea,Fecha__Entrega)
VALUES ('0005','50 kg','Carconte 258 Los Angeles Ensenada','Eduardo Davalos de Luna','777','Volaris','2020-01-01'),
       ('0006','60 kg','5th Ave. 89 NYC','David Guetta','666','VuelaBien','2020-02-02'),
       ('0007','70 kg','Scaletta 501 Little Italy Stilwater','Thanos Mato Mitades','555','VuelaMas','2020-03-03'),
	   ('0008','80 kg','Green Ridge 205 Brighton','Naruto Uzumaki','444','VuelaPLus','2020-04-04');

INSERT INTO RutaNacional(Id_Ruta,Ruta)
VALUES  ('01','34'),('02','43'),('03','12'),('04','19'),('05','20'),('06','03'),('07','98'),('08','77'),
		('09','67'),('10','95');

INSERT INTO EnvioNacional(EnvioID,Peso,Direccion,Destinatario,CiudadDestino,RFC_Conductor,Rutas)
VALUES  ('0001','10 kg','Lucitania,Sinaloa 25','Susana Distancia','Ciudad de Mexico','AS12DSFS','01'),
        ('0002','20 kg','Endor,Qchao 5','Abraham Sealv','Monterrey','A1223GMB','02'),
		('0003','30 kg','Sera,Tlatenco 18','El MotoMoto','Guadalajara','FDSFDF43','03'),
		('0004','40 kg','Piston,Tlatilco 11','El myDog','Tijuana','GRAT1223R','07');

INSERT INTO Conductor_Camion(RFC_Conductor,Placa_Camion,Fecha)
VALUES  ('AS12DSFS','HOMMY13A','2020-02-03'),('A1223GMB','CHOLO13C','2020-06-07'),
		('FDSFDF43','MICLO22B','2020-04-02'),('GRAT1223R','CRUZITO25C','2020-08-09');

INSERT INTO RutaConductor(RFC_Conductor,Ruta)
VALUES  ('AS12DSFS','16'),('A1223GMB','12'),('FDSFDF43','24'),('GRAT1223R','34');

---Se deberá crear un disparador para las siguientes tablas	
--• (envió	o paquete)-nacional		
--• (envió	o paquete)-Internacional	
--Lo anterior para garantizar	la integridad de los datos 
--(garantizar que un paquete o	envió  solo	pueda ser de un	solo tipo Nacional o Internacional pero no ambos).

CREATE or alter TRIGGER DPNacional
  on EnvioNacional 
  instead of insert
  as		
  declare @EnvioID varchar (10),@Peso char(10),@Direccion varchar(40),@Destinatario varchar(50),@CiudadDestino varchar(20),
    @RFC_Conductor varchar(15),@Rutas varchar (30) 
		set @EnvioID=(select EnvioID from inserted)
		set @Peso=(select Peso from inserted)
		set @Direccion=(select Direccion from inserted)
		set @Destinatario=(select Destinatario from inserted)
		set @CiudadDestino=(select CiudadDestino from inserted)
		set @RFC_Conductor=(select RFC_Conductor from inserted)
		set @Rutas=(select Rutas from inserted)
            
			insert into Envios(EnvioID,TipoEnvio)
			values(@EnvioID,'N')

			insert into EnvioNacional(EnvioID,Peso,Direccion,Destinatario,CiudadDestino,RFC_Conductor,Rutas)
			values(@EnvioID,@Peso,@Direccion,@Destinatario,@CiudadDestino,@RFC_Conductor,@Rutas)
   			print('La inserción es de un envio Nacional')
	
---Prueba
insert into envios(EnvioID,TipoEnvio)
values('0026','N')
INSERT INTO EnvioNacional(EnvioID,Peso,Direccion,Destinatario,CiudadDestino,RFC_Conductor,Rutas)
VALUES  ('0028','10 kg','Lucitania,Sinaloa 25','Susana Distancia','Ciudad de Mexico','AS12DSFS','01')

Select * from Envios 
select * from EnvioNacional

------------------------------
CREATE TRIGGER DPInternacional
  on EnvioInternacional 
  instead of insert
  as 
  declare 
    @EnvioID varchar(10),@Peso char(10) ,@Direccion varchar(40),@Destinatario varchar(50),
	@Codigo_Com varchar(15), @Linea_Aerea varchar(15),@Fecha__Entrega date
	SET @EnvioID=(Select EnvioID from inserted)
	SET @Peso=(Select Peso from inserted)
	SET @Direccion=(Select Direccion from inserted)
	SET @Destinatario=(Select Destinatario from inserted)
	SET @Codigo_Com=(Select Codigo_Com from inserted)
	SET @Linea_Aerea=(Select Linea_Aerea from inserted)
	SET @Fecha__Entrega=(Select EnvioID from inserted)
	   
			insert into Envios(EnvioID,TipoEnvio)
			values(@EnvioID,'I')

			INSERT INTO EnvioInternacional(EnvioID,Peso,Direccion,Destinatario,Codigo_Com,Linea_Aerea,Fecha__Entrega)
            VALUES (@EnvioID,@Peso,@Direccion,@Destinatario,@Codigo_Com,@Linea_Aerea,@Fecha__Entrega)
   			print('La inserción es de un envio Internacional')
			
---Prueba
INSERT INTO EnvioInternacional(EnvioID,Peso,Direccion,Destinatario,Codigo_Com,Linea_Aerea,Fecha__Entrega)
VALUES ('0030','50 kg','Carconte 258 Los Angeles Ensenada','Eduardo Davalos de Luna','777','Volaris','2020-01-01')

select * from EnvioInternacional
select * from Envios	
---------------
--Crear otro Disparador para la tabla(entidad)	
--• Camión
--Que	no permita dar de alta camiones con	cargas menores a 250 kg	o mayores a	1250 kg	
--Deberá mandar	un	mensaje	de la razón	por	la cual	no se pudo ingresar	camiones que no cumplan	con	lo establecido		

Create or alter Trigger DPCargaCamion
	on Camion
	for insert
	 as
	 declare
		@Carga int
		Set @Carga=(Select Carga_Maxima_Kg from inserted)
		
		
		if @Carga<250 or @Carga>1250  begin 
			print('No se puede dar de alta este Camion ')
			print('La carga minima es de 250 Kg')
			print('La carga maxima es de 1250 Kg')
			rollback transaction
		end
		else
		begin
			print('El Camion ha sido registrado')
		end
--Prueba 
INSERT INTO Camion(Placa,Carga_Maxima_Kg,Ciudad_Resguardo)
VALUES  ('LHRrEp2pR',1249,'Ciudad de Mexico')

select * from Camion
---------------------------
--Crear otro disparador para •(envió o paquete)-nacional	
--Que	al ingresar	un nuevo envió,ingrese en otra tabla el	id del envió y la ciudad de destino	
--y además muestre cuantos envíos se han hecho a dicha ciudad destino		

Create trigger DPNacional2
on EnvioNacional
 for insert
	as
	Declare @EnvioID varchar(10),@Ciudad varchar(30)
			Set @EnvioID = (Select EnvioID from inserted)
			Set @Ciudad = (Select CiudadDestino from inserted)

			Insert Into RegistrosNacional(EnvioID,CiudadDestino)
			Values(@EnvioID, @Ciudad)
			Select COUNT(EnvioID) as Envios_a_la_misma_ciudad FROM RegistrosNacional
			WHERE CiudadDestino = @Ciudad
		

----Prueba
INSERT INTO EnvioNacional(EnvioID,Peso,Direccion,Destinatario,CiudadDestino,RFC_Conductor,Rutas)
VALUES  ('0048','10 kg','Lucitania,Sinaloa 25','Susana Distancia','Ciudad de Mexico','AS12DSFS','01')

select * from RegistrosNacional
----------------------------	
--Se deberá crear	un procedimiento almacenado	el	cual tendrá	como entrada el	código de algún	paquete-envió.		
--Este procedimiento deberá mostrar lo siguiente;	
--1.el Id	
--2. Tipo	de	envió(Nacional	o	internacional)	
--a. Si	es	nacional	
	--i. Dirección	
	--ii. Peso	
	--iii. El	conductor	al	que	le	fue	asignado	el	paquete	
	--iv. la	ruta	
	--v. las	placas	del	camión	
	--vi. fecha(es	la	fecha	entre	conductor	y	camión)	
--b. Si	es	internacional	
	--i. Dirección	
	--ii. Línea	aérea		
	--iii. Y	el	código	de	la	compañía	local.	

Create or alter Procedure MostrarEnvios
@EnvioID varchar(10)
As
Begin
DECLARE @TipoEnvio varchar(1)
		SET @TipoEnvio=(Select TipoEnvio from Envios where EnvioID=@EnvioID)
	
	if @TipoEnvio='N'
	begin
		Select EN.Direccion,EN.Peso,C.Nombre,EN.Rutas,Ca.Placa,CC.Fecha
		from EnvioNacional EN join Conductor C on EN.RFC_Conductor=C.RFC
		                         join Conductor_Camion CC on C.RFC=CC.RFC_Conductor
								 join Camion Ca on Ca.Placa=CC.Placa_Camion
								 where EnvioID=@EnvioID
	end
	else
	 begin
	 Select  EI.Direccion,EI.Linea_Aerea,CL.CompaniaID,CL.Nombre
	 from EnvioInternacional EI join Compania_Local CL on EI.Codigo_Com=CL.CompaniaID
	 where EnvioID=@EnvioID
	 end
end

---Prueba 
exec MostrarEnvios '0005'
select * from Envios 


----Apartado para borrar tablas
--Primero borramos las tablas que contienen llaves foraneas 
Drop table EnvioNacional
Drop table EnvioInternacional
Drop table Conductor_Camion
Drop table RutaConductor
--Despues borramos las demas tablas
Drop table Envios
Drop table RutaNacional
Drop table Compania_Local
Drop table Camion
Drop table Conductor
----


