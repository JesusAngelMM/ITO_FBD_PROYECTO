### Descripción del Script DDL y DML

#### Script DDL (Data Definition Language)
El script DDL define la estructura de la base de datos, creando las tablas y sus relaciones. Aquí se detallan las operaciones:

1. **Crear esquema y establecer el `search_path`**:
    ```sql
    create schema if not exists paws_and_claws authorization postgres;
    set search_path to paws_and_claws;
    ```

2. **Crear tablas**:
    - `cliente`: Define los datos de los dueños de los pacientes.
    - `veterinario`: Define los datos de los veterinarios.
    - `especialidad_veterinario`: Define las especialidades de los veterinarios.
    - `telefono_veterinario`: Define los teléfonos de contacto de los veterinarios.
    - `paciente`: Define los datos de los pacientes (mascotas).
    - `cita`: Define las citas entre veterinarios y pacientes.
    - `historial_medico`: Define el historial médico de los pacientes.
    - `paciente_alergia`: Define las alergias de los pacientes.
    - `telefono_cliente`: Define los teléfonos de contacto de los clientes.
    - `producto`: Define los productos disponibles en la clínica.
    - `venta`: Define las ventas realizadas a los clientes.
    - `detalle_venta`: Define los detalles de las ventas.
    - `proveedor`: Define los proveedores de productos.
    - `compra`: Define las compras realizadas a los proveedores.
    - `detalle_compra`: Define los detalles de las compras.
    - `telefono_proveedor`: Define los teléfonos de contacto de los proveedores.

#### Script DML (Data Manipulation Language)
El script DML inserta datos en las tablas creadas. Aquí se detallan las operaciones:

## Descripción de las Consultas

### 01 - Seleccionar el nombre de los productos con un precio de venta mayor a $10

#### Álgebra Relacional:
$$
\LARGE
\pi_{\text{nombre}}(\sigma_{\text{precio\_v} > 10}(\text{producto}))
$$

**Explicación:**
- **Selección ($\sigma$)**: Aquí usamos la selección para filtrar las tuplas de la relación `producto` donde el atributo `precio_v` es mayor a 10. Esto se indica con $\sigma_{\text{precio\_v} > 10}(\text{producto})$.
- **Proyección ($\pi$)**: Después, usamos la proyección para seleccionar solo el atributo `nombre` de las tuplas filtradas. Esto se representa con $\pi_{\text{nombre}}(\ldots)$.

#### SQL:
```sql
select nombre
	from producto
	where precio_v > 10;
```

**Explicación SQL:**
- `select nombre`: Selecciona el atributo `nombre`.
- `from producto`: Indica la tabla `producto`.
- `where precio_v > 10`: Filtra las filas donde `precio_v` es mayor a 10.

---

### 02 - Seleccionar el nombre y la especialidad de todos los veterinarios

#### Álgebra Relacional:
$$
\LARGE
\pi_{\text{nombre}, \text{especialidad}}(\text{veterinario} |x| \text{especialidad\_veterinario}) 
$$

**Explicación:**
- **Proyección ($\pi$)**: Seleccionamos los atributos `nombre` y `especialidad`.
- **Producto natural ($|x|$)**: Unimos las relaciones `veterinario` y `especialidad_veterinario` usando un producto natural, combinando las tuplas que tienen el mismo valor en el atributo común.

#### SQL:
```sql
select veterinario.nombre, veterinario.apellido_p, veterinario.apellido_m, especialidad_veterinario.especialidad
	from veterinario
	natural join especialidad_veterinario;
```

**Explicación SQL:**
- `select veterinario.nombre, veterinario.apellido_p, veterinario.apellido_m, especialidad_veterinario.especialidad`: Selecciona los atributos `nombre`, `apellido_p`, `apellido_m` de `veterinario` y `especialidad` de `especialidad_veterinario`.
- `from veterinario`: Indica la tabla `veterinario`.
- `natural join especialidad_veterinario`: Realiza un join natural con `especialidad_veterinario` basándose en los atributos comunes.

---

### 03 - Pacientes que tienen alergias y su historial médico

#### Álgebra Relacional:
$$
\LARGE
\pi_{\text{nombre\_paciente}, \text{alergia}, \text{diagnostico}, \text{tratamiento}}(\text{paciente} \bowtie \text{paciente\_alergia} \bowtie \text{historial\_medico}) 
$$

**Explicación:**
- **Join (⨝)**: Utilizamos joins para combinar las relaciones `paciente`, `paciente_alergia` y `historial_medico` basándonos en atributos comunes.
- **Proyección ($\pi$)**: Luego proyectamos los atributos `nombre_paciente`, `alergia`, `diagnostico` y `tratamiento` de las tuplas resultantes.

#### SQL:
```SQL
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
```

**Explicación SQL:**
- `select paciente.nombre as nombre_paciente, paciente_alergia.alergia, historial_medico.diagnostico, historial_medico.tratamiento`: Selecciona y renombra (cuando es necesario) los atributos `nombre`, `alergia`, `diagnostico` y `tratamiento`.
- `from paciente`: Indica que los datos se obtendrán de la tabla `paciente`.
- `natural join paciente_alergia`: Realiza un join natural entre `paciente` y `paciente_alergia`.
- `natural join historial_medico`: Realiza un join natural entre `paciente_alergia` y `historial_medico`.

---

### 04 - Total de productos vendidos por tipo

#### Álgebra Relacional:
$$
\LARGE
_{\text{tipo}}G_{sum(cantidad)\text{as total\_vendidos}}(\text{producto} \bowtie \text{detalle\_venta})
$$

**Explicación:**
- **Proyección Generalizada ($G$)**: Aquí usamos la proyección generalizada para agrupar por el atributo `tipo` y calcular la suma del atributo `cantidad`, renombrándolo como `total_vendidos`.
- **Join (⨝)**: Utilizamos un join para combinar las relaciones `producto` y `detalle_venta` basándonos en atributos comunes.

#### SQL:
```SQL
set search_path to paws_and_claws;

select distinct p.tipo, 
       (select sum(dv.cantidad)
        from producto p2
        natural join detalle_venta dv
        where p2.tipo = p.tipo) as total_vendidos
from producto p
natural join detalle_venta;
```

**Explicación SQL:**
- `select distinct p.tipo`: Selecciona y asegura que cada tipo sea único.
- `(select sum(dv.cantidad) from producto p2 natural join detalle_venta dv where p2.tipo = p.tipo) as total_vendidos`: Suma la cantidad de productos vendidos para cada tipo.
- `from producto p`: Indica que los datos se obtendrán de la tabla `producto`.
- `natural join detalle_venta`: Realiza un join natural entre `producto` y `detalle_venta`.

---

### 05 - Calcular el total de ventas realizadas por cada veterinario (Proyección Generalizada y Función de Agregación)

#### Álgebra Relacional:
$$
\LARGE
_{\text{nombre}}G_{sum(cantidad) \text{as total\_venta}}(\text{veterinario} \bowtie \text{detalle\_venta})
$$

**Explicación:**
- **Proyección Generalizada ($G$)**: Aquí usamos la proyección generalizada para agrupar por el atributo `nombre` y calcular la suma del atributo `cantidad`, renombrándolo como `total_venta`.
- **Join (⨝)**: Utilizamos un join para combinar las relaciones `veterinario` y `detalle_venta` basándonos en atributos comunes.

#### SQL:
```sql
set search_path to paws_and_claws;

select veterinario.nombre, sum(detalle_venta.cantidad) as total_ventas
	from veterinario
	natural join venta
	natural join detalle_venta
	group by veterinario.nombre;
```

**Explicación SQL:**
- `select veterinario.nombre, sum(detalle_venta.cantidad) as total_ventas`: Selecciona el nombre de los veterinarios y calcula la suma de las ventas realizadas por cada uno.
- `from veterinario`: Indica que los datos se obtendrán de la tabla `veterinario`.
- `natural join venta`: Realiza un join natural entre `veterinario` y `venta`.
- `natural join detalle_venta`: Realiza un join natural entre `venta` y `detalle_venta`.
- `group by veterinario.nombre`: Agrupa los resultados por el nombre del veterinario.

Espero que estas explicaciones sean claras y útiles para tu exposición. ¡Buena suerte!