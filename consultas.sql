
--1 
select count(equipo) as Cant_Equipo_de_la_Temporada from ( 
select p.id_equipo as equipo 
from participacion p 
where p.id_tem = 1
group by p.id_equipo) as tabla


--2

select p.id,p.equipo_local,p.puntos_local, p.equipo_visita,p.puntos_visita, p.id_tem 
from partido p where year(getdate())=year(fecha) and month(fecha)<=6

--3
select p.id , e.nombre, e1.nombre from partido p inner join equipo e on(e.id=p.equipo_local) 
inner join equipo e1 on (e1.id=p.equipo_visita)
where e.nombre='Nets' 
group by p.id , e.nombre, e1.nombre
having sum(p.puntos_local- p.puntos_visita) > 0 
union
select p.id , e.nombre, e1.nombre from partido p inner join equipo e on(e.id=p.equipo_local) 
inner join equipo e1 on (e1.id=p.equipo_visita)
where e1.nombre='Nets' 
group by p.id , e.nombre, e1.nombre
having sum(p.puntos_local- p.puntos_visita) < 0


--4

select p.id , e.nombre, e1.nombre from partido p inner join equipo e on(e.id=p.equipo_local) 
inner join equipo e1 on (e1.id=p.equipo_visita)
where e1.nombre='Nets' 
group by p.id , e.nombre, e1.nombre
having e1.nombre='Nets' and sum(p.puntos_local- p.puntos_visita) < 0


--5 


select top 1 j.nombre,j.apellido,p.num_camiseta, e.nombre as equipo, avg(r.valor) as puntos 
from rendimiento r inner join  jugador j on (j.id=r.id_jugador) 
inner join participacion p on(j.id=p.id_jugador) 
inner join equipo e on (p.id_equipo=e.id)
where r.id_estadistica = 16 
group by  j.nombre,j.apellido,p.num_camiseta, e.nombre, r.id_jugador
order by puntos desc

--6 

select top 5 e.nombre as equipo, avg(cast(j.peso as money)) as peso
from equipo e inner join participacion p on (p.id_equipo= e.id)
inner join jugador j on (j.id=p.id_jugador)
group by e.nombre
order by peso desc



--7 Timberwolves

select p.id , e.nombre, e1.nombre ,p.puntos_local from partido p inner join equipo e on(e.id=p.equipo_local) 
inner join equipo e1 on (e1.id=p.equipo_local)
where e.nombre='Timberwolves' and p.puntos_local>=100
group by p.id , e.nombre, e1.nombre,p.puntos_local
having sum(p.puntos_local- p.puntos_visita) < 0 
union
select p.id , e.nombre, e1.nombre,p.puntos_visita from partido p inner join equipo e on(e.id=p.equipo_local) 
inner join equipo e1 on (e1.id=p.equipo_visita)
where e1.nombre='Timberwolves' and p.puntos_visita>=100
group by p.id , e.nombre, e1.nombre,p.puntos_visita
having  sum(p.puntos_local- p.puntos_visita) > 0 


--8 
select * from equipo
select * from divicion
select * from conferencia
alter table equipo add  conferencia int
constraint fk_conf foreign key (conferencia) references conferencia(id)


select c.nombre,( avg(p.puntos_local) + avg(p.puntos_visita) )/2 as puntos 
from partido p inner join equipo e on (e.id=p.equipo_local) 
inner join equipo e1 on (e1.id=p.equipo_visita) inner join conferencia c on (c.id=e.conferencia) 
inner join conferencia c1 on (c1.id=e1.conferencia)
group by c.nombre


--9 

select c.nombre, (avg(p.puntos_local) + avg(p.puntos_visita))/2  as puntos 
from partido p inner join equipo e on (e.id=p.equipo_local) 
inner join equipo e1 on (e1.id=p.equipo_visita) inner join divicion c on (c.id=e.divicion) 
inner join divicion c1 on (c1.id=e1.divicion)
group by c.nombre



--10  Ricky Rubio
select * from estadistica

1 asistencia
11 rebotes
16 puntos

select  sum( r.valor) as asistencias_rebotes_puntos  from rendimiento r inner join jugador j on (j.id=r.id_jugador)
inner join participacion p on(p.id_jugador=j.id) inner join partido pr on (pr.id=r.id_partido) 
inner join equipo e on (e.id=pr.equipo_local) inner join equipo e1 on (e1.id=pr.equipo_visita)
where (j.nombre ='Ricky' and j.apellido='Rubio') and 
(r.id_estadistica=1 or  r.id_estadistica=11 or  r.id_estadistica=16) and
e.conferencia =2 and e1.conferencia=2
group by p.id_equipo , r.id_estadistica

--11

select * from pais
select * from jugador
begin tran
update pais set nombre=replace(nombre,'       ','')
update pais set nombre=replace(nombre,'ú','u')
update pais set nombre=replace(nombre,'í','i')
update pais set nombre=replace(nombre,'ñ�','ni')
República Checa
Turquía
España
--commit

select top 1 p.nombre, count(*) as jugadores from jugador j inner join pais p on (j.pais=p.id)
where p.id != 3
group by p.nombre
order by jugadores desc 

--12
/*Promedio de minutos jugados por partido de los jugadores originarios del pa�s del
punto anterior. Se considera partido jugado si jug� al menos 1 minuto en el
partido*/


select avg(r.valor)as minutos from rendimiento r inner join jugador j on (j.id=r.id_jugador)
where r.id_estadistica = 9 and j.pais = 16 and r.valor>=1



--13
select * from jugador

select 'mas de 15' as intervalos ,count(*) as cantidad from jugador j where (year(getdate())-j.anio_reclutado)  > 15
union
select 'entre 10 y 15 ',count(*) from jugador j where(year(getdate())-j.anio_reclutado)  between   10 and 15
union
select 'menos de 10',count(*) from jugador j where (year(getdate())-j.anio_reclutado)  <10


--14

select p.id,p.fecha,e.sigla, p.puntos_local,e1.sigla, p.puntos_visita
from partido p inner join equipo e on (e.id=p.equipo_local) 
inner join equipo e1 on (e1.id=p.equipo_visita) inner join rendimiento r on (r.id_partido=p.id)
inner join jugador j on (j.id=r.id_jugador)
where r.valor =  ( select max(r.valor) from rendimiento r inner join jugador j on (j.id=r.id_jugador)
where j.nombre = 'Vince' and j.apellido='Carter' and r.id_estadistica = 16 ) and 
j.nombre = 'Vince' and j.apellido='Carter' and r.id_estadistica = 16

--15

select count(r.id_partido) as cant from rendimiento r inner join jugador j on (j.id=r.id_jugador)
inner join participacion p on (p.id_jugador=j.id)
inner join equipo e on (e.id=p.id_equipo)
where r.id_estadistica = 3 and r.valor>10 and e.nombre= 'Raptors'



select * from estadistica

select * from equipo where nombre= 'Raptors'
