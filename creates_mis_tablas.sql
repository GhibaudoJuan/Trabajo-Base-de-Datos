
select top 1 * from datos

create table temporada (
id int not null,
descripcion varchar(20) not null

constraint id_tem primary key (id)
)

insert into temporada select d.temporada_id, d.temporada_descripcion from datos d group by d.temporada_id, d.temporada_descripcion

create table pais (
id int not null,
nombre varchar(100) not null

constraint id_pais primary key (id))

insert into pais select d.idPais, d.pais  from datos d group by d.idPais, d.pais

create table conferencia (
id int not null,
nombre varchar(20) not null
constraint id_conf primary key (id))

insert into conferencia(id,nombre) values (1,'Este'),(2,'Oeste')
select d.equipo_conferencia  from datos d group by d.equipo_conferencia

create table divicion (
id int not null,
nombre varchar(20)
constraint id_div primary key (id))
insert into divicion(id,nombre) values (1,'Sudoeste'),(2,'Sudeste'),(3,'Noroeste'),(4,'Pacifico'),(5,'Atlantico'),(6,'Central')

create table ciudad(
id int not null,
nombre varchar(30)
constraint id_ciudad primary key (id))

insert into ciudad select d.equipo_idCiudad, d.equipo_ciudad from datos d group by d.equipo_idCiudad, d.equipo_ciudad
select nombre from ciudad
update ciudad set nombre=replace(nombre,'       ','')
update datos set equipó_nombre=replace(equipó_nombre,'  ',' ')
update datos set equipo_ciudad=replace(equipo_ciudad,'  ',' ')
update datos set equipo_ciudad=ltrim(equipo_ciudad)
update datos set equipo_ciudad=rtrim(equipo_ciudad)

create table equipo (
id int not null,
codigo varchar(30),
nombre varchar(30),
sigla varchar(5),
ciudad int not null,
divicion int not null
constraint id_equipo primary key (id),
constraint fk_ciu foreign key (ciudad) references ciudad(id),
constraint fk_div foreign key (divicion) references divicion(id))

insert into equipo select d.equipo_id, d.equipo_codigo, d.equipó_nombre, d.equipo_sigla, c.id ,div.id
from datos d inner join ciudad c on(c.nombre=d.equipo_ciudad)
inner join divicion div on (div.nombre=d.equipo_division)
group by d.equipo_id, d.equipo_codigo, d.equipó_nombre, d.equipo_sigla, c.id ,div.id

select * from ciudad
select equipo_ciudad from datos group by equipo_ciudad where equipo_division not in ('Noroeste','Pacifico')
update datos set equipo_division = 'Pacifico' where equipo_division like 'Pac%'

create table partido (
id int not null,
equipo_local int not null,
puntos_local int,
equipo_visita int not null,
puntos_visita int,
fecha datetime,
id_tem int not null
constraint id_partido primary key (id)
constraint pk_local foreign key (equipo_local) references equipo(id),
constraint pk_visita foreign key (equipo_visita) references equipo(id),
constraint pk_tem foreign key (id_tem) references temporada(id))

insert into partido select d.partido_id, d.equipo_id, d.equipo_puntos, d.equipoOP_id,d.equipoOP_puntos,d.fecha,d.temporada_id 
from datos d 
where d.esLocal='True'
group by d.partido_id, d.equipo_id, d.equipo_puntos, d.equipoOP_id,d.equipoOP_puntos,d.fecha,d.temporada_id
order by partido_id

select * from partido

select partido_id from datos group by partido_id

create table estadistica(
id int not null,
tipo varchar (50)
constraint id_estadistica primary key (id))

insert into estadistica(id,tipo) values 
(1,'asistencias'),
(2,'bloqueos'),
(3,'rebotes_defensivos'),
(4,'tiros_intentos'),
(5,'tiros_convertidos'),
(6,'faltas'),
(7,'tiros_libres_intentos'),
(8,'tiros_libres_convertidos'),
(9,'minutos'),
(10,'rebotes_ofensivos'),
(11,'rebotes'),
(12,'robos'),
(13,'tiros_triples_intentos'),
(14,'tiros_triples_convertidos'),
(15,'perdidas')
insert into estadistica(id,tipo) values (16,'puntos')

create table jugador (
id int not null,
codigo  varchar(40),
nombre varchar(30),
apellido varchar(30),
altura decimal(5,2),
peso varchar(50),
posicion varchar(5),
anio_reclutado int,
pais int not null
constraint id_jugador primary key (id)
constraint pf_pais foreign key (pais) references pais(id))

insert into jugador select d.jugador_id,d.jugador_codigo,d.nombre,d.apellido,d.altura,d.peso,d.posicion,d.draft_year,d.idPais
from datos d 
group by d.jugador_id,d.jugador_codigo,d.nombre,d.apellido,d.altura,d.peso,d.posicion,d.draft_year,d.idPais

update jugador set nombre=replace(nombre,'       ','')
update jugador set apellido=replace(apellido,'       ','')


create table rendimiento (
id_jugador int not null,
id_partido int not null,
id_estadistica int not null,
valor int 
constraint id_rend primary key (id_jugador,id_partido,id_estadistica)
constraint fk_jugador foreign key (id_jugador) references jugador(id),
constraint fk_partido foreign key (id_partido) references partido(id),
constraint fk_est foreign key (id_estadistica) references estadistica(id))

insert into rendimiento select d.jugador_id,d.partido_id, 1, d.asistencias from datos d
insert into rendimiento select d.jugador_id,d.partido_id, 2, d.bloqueos from datos d
insert into rendimiento select d.jugador_id,d.partido_id, 3, d.rebotes_defensivos from datos d
insert into rendimiento select d.jugador_id,d.partido_id, 4, d.tiros_intentos from datos d
insert into rendimiento select d.jugador_id,d.partido_id, 5, d.tiros_convertidos from datos d
insert into rendimiento select d.jugador_id,d.partido_id, 6, d.faltas from datos d
insert into rendimiento select d.jugador_id,d.partido_id, 7, d.tiros_libres_intentos from datos d
insert into rendimiento select d.jugador_id,d.partido_id, 8, d.tiros_libres_convertidos from datos d
insert into rendimiento select d.jugador_id,d.partido_id, 9, d.minutos from datos d
insert into rendimiento select d.jugador_id,d.partido_id, 10, d.rebotes_ofensivos from datos d
insert into rendimiento select d.jugador_id,d.partido_id, 11, d.rebotes from datos d
insert into rendimiento select d.jugador_id,d.partido_id, 12, d.robos from datos d
insert into rendimiento select d.jugador_id,d.partido_id, 13, d.tiros_triples_intentos from datos d
insert into rendimiento select d.jugador_id,d.partido_id, 14, d.tiros_triples_convertidos from datos d
insert into rendimiento select d.jugador_id,d.partido_id, 15, d.perdidas from datos d
insert into rendimiento select d.jugador_id,d.partido_id, 16, d.puntos from datos d

select * from rendimiento

select * from estadistica

create table participacion(
id_tem int not null,
id_equipo int not null,
id_jugador int not null,
num_camiseta int
constraint id_part primary key (id_tem,id_equipo,id_jugador)
constraint fk_jugador2 foreign key (id_jugador) references jugador(id),
constraint fk_tem2 foreign key (id_tem) references temporada(id),
constraint fk_equipo2 foreign key (id_equipo) references equipo(id))


insert into participacion select d.temporada_id,d.equipo_id,d.jugador_id,d.caminseta from datos d
group by d.temporada_id,d.equipo_id,d.jugador_id,d.caminseta 
