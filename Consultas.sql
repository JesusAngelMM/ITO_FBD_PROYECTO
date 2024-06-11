--- 1. Seleccionar el nombre de los productos con un precio de venta mayor a $10

set search_path to paws_and_claws;

select 
    nombre
from 
    producto
where 
    precio_v > 10;

--- 2. Seleccionar el nombre y la especialidad de todos los veterinarios
select 
	veterinario.nombre, veterinario.apellido_p, veterinario.apellido_m, especialidad_veterinario.especialidad
from 
	veterinario
natural join especialidad_veterinario;

--- 3. Pacientes que tienen alergias y su historial médico

set search_path to paws_and_claws;

select 
    paciente.nombre as nombre_paciente, 
    paciente_alergia.alergia, 
    historial_medico.diagnostico, 
    historial_medico.tratamiento
from 
    paciente
    natural join paciente_alergia
    natural join historial_medico;

--- 4. Total de productos vendidos por tipo
set search_path to paws_and_claws;

select distinct p.tipo, 
       (select sum(dv.cantidad)
        from producto p2
        natural join detalle_venta dv
        where p2.tipo = p.tipo) as total_vendidos
from producto p
natural join detalle_venta;


--- 5. Calcular el total de ventas realizadas por cada veterinario (Proyección Generalizada y Función de Agregación)
select veterinario.nombre, sum(detalle_venta.cantidad) as total_ventas
from veterinario
natural join venta
natural join detalle_venta
group by veterinario.nombre;