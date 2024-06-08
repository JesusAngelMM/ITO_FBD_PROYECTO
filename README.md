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

### Descripción de las Consultas

1. **Total de productos vendidos por tipo**
    - **Álgebra Relacional**:

    - **SQL**:
    ```sql
    set search_path to paws_and_claws;

    select 
        producto.tipo, 
        sum(detalle_venta.cantidad) as total_vendidos
    from 
        producto
        natural join detalle_venta
    group by 
        producto.tipo;
    ```
    - **Descripción**: Esta consulta calcula el total de productos vendidos agrupados por tipo de producto. Utiliza una agregación para sumar la cantidad de productos vendidos por cada tipo.

2. **Historial médico de pacientes**
    - **Álgebra Relacional**:
    $$ 
    \pi_{\text{nombre\_paciente}, \text{diagnostico}, \text{tratamiento}, \text{fecha\_reg}}(\text{paciente} \bowtie \text{historial\_medico}) 
    $$
    - **SQL**:
    ```sql
    set search_path to paws_and_claws;

    select 
        paciente.nombre as nombre_paciente, 
        historial_medico.diagnostico, 
        historial_medico.tratamiento, 
        historial_medico.fecha_reg
    from 
        paciente
        natural join historial_medico;
    ```
    - **Descripción**: Esta consulta recupera el historial médico de todos los pacientes, mostrando el nombre del paciente, diagnóstico, tratamiento y fecha de registro del historial.

3. **Pacientes que tienen alergias y su historial médico**
    - **Álgebra Relacional**:
    $$ 
    \pi_{\text{nombre\_paciente}, \text{alergia}, \text{diagnostico}, \text{tratamiento}}(\text{paciente} \bowtie \text{paciente\_alergia} \bowtie \text{historial\_medico}) 
    $$
    - **SQL**:
    ```sql
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
    - **Descripción**: Esta consulta obtiene los pacientes que tienen alergias junto con su historial médico, mostrando el nombre del paciente, alergia, diagnóstico y tratamiento.

4. **Seleccionar el nombre y la especialidad de todos los veterinarios**
    - **Álgebra Relacional**:
    $$ 
    \pi_{\text{nombre}, \text{especialidad}}(\text{veterinario} \bowtie \text{especialidad\_veterinario}) 
    $$
    - **SQL**:
    ```sql
    set search_path to paws_and_claws;

    select 
        veterinario.nombre, 
        especialidad_veterinario.especialidad
    from 
        veterinario
        natural join especialidad_veterinario;
    ```
    - **Descripción**: Esta consulta selecciona el nombre y la especialidad de todos los veterinarios, mostrando la relación entre veterinarios y sus especialidades.

5. **Calcular el total de ventas realizadas por cada veterinario (Proyección Generalizada y Función de Agregación)**
    - **Álgebra Relacional**:
    
    - **SQL**:
    ```sql
    set search_path to paws_and_claws;

    select 
        veterinario.nombre, 
        sum(detalle_venta.cantidad) as total_ventas
    from 
        veterinario
        natural join venta
        natural join detalle_venta
    group by 
        veterinario.nombre;
    ```
    - **Descripción**: Esta consulta calcula el total de ventas realizadas por cada veterinario, agrupando por el nombre del veterinario y sumando la cantidad de productos vendidos.

6. **Seleccionar el nombre de los productos con un precio de venta mayor a $10**
    - **Álgebra Relacional**:

    -SQL:
    ```sql
    set search_path to paws_and_claws;

    select 
        nombre
    from 
        producto
    where 
        precio_v > 10;
    ```
    - **Descripción**: Esta consulta selecciona el nombre de los productos cuyo precio de venta es mayor a 10 pesos, aplicando una selección sobre los productos.