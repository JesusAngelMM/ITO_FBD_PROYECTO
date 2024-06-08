-- crear el esquema y establecer el search_path
create schema if not exists paws_and_claws authorization postgres;
set search_path to paws_and_claws;

-- tabla para los clientes
create table if not exists cliente (
    id_dueno int primary key,
    nombre varchar(100) not null,
    apellido_p varchar(100) not null,
    apellido_m varchar(100),
    email varchar(100),
    direccion varchar(255)
);

-- tabla para los veterinarios
create table if not exists veterinario (
    no_cedula int primary key,
    nombre varchar(100) not null,
    apellido_p varchar(100) not null,
    apellido_m varchar(100),
    email varchar(100) not null
);

-- tabla para las especialidades de los veterinarios
create table if not exists especialidad_veterinario (
    no_cedula int,
    especialidad varchar(100) not null,
    descripcion varchar(255),
    foreign key (no_cedula) references veterinario(no_cedula)
);

-- tabla para los teléfonos de los veterinarios
create table if not exists telefono_veterinario (
    no_cedula int,
    telefono varchar(20) not null,
    tipo_contacto varchar(50),
    foreign key (no_cedula) references veterinario(no_cedula)
);

-- tabla para los pacientes
create table if not exists paciente (
    id_paciente int primary key,
    id_dueno int,
    nombre varchar(100) not null,
    especie varchar(50) not null,
    raza varchar(50),
    sexo varchar(10),
    fecha_nac date,
    peso decimal(5,2),
    foreign key (id_dueno) references cliente(id_dueno)
);

-- tabla para las citas
create table if not exists cita (
    no_cita int primary key,
    no_cedula int,
    id_paciente int,
    descripcion varchar(255),
    estado varchar(50),
    fecha date not null,
    hora time not null,
    folio_cita int unique not null,
    foreign key (no_cedula) references veterinario(no_cedula),
    foreign key (id_paciente) references paciente(id_paciente)
);

-- tabla para el historial médico de los pacientes
create table if not exists historial_medico (
    id_historial int primary key,
    id_paciente int,
    diagnostico varchar(255),
    tratamiento varchar(255),
    fecha_reg date not null,
    folio_cita int,
    foreign key (id_paciente) references paciente(id_paciente),
    foreign key (folio_cita) references cita(folio_cita)
);

-- tabla para las alergias de los pacientes
create table if not exists paciente_alergia (
    id_paciente int,
    alergia varchar(100) not null,
    descripcion varchar(255),
    foreign key (id_paciente) references paciente(id_paciente)
);

-- tabla para los teléfonos de los clientes
create table if not exists telefono_cliente (
    id_dueno int,
    telefono varchar(20) not null,
    tipo_contacto varchar(50),
    foreign key (id_dueno) references cliente(id_dueno)
);

-- tabla para los productos
create table if not exists producto (
    codigo_barras int primary key,
    nombre varchar(100) not null,
    descripcion varchar(255),
    tipo varchar(50),
    stock int,
    precio_v decimal(10,2),
    precio_c decimal(10,2)
);

-- tabla para las ventas
create table if not exists venta (
    id_venta int primary key,
    id_dueno int,
    id_veterinario int,
    fecha date not null,
    foreign key (id_dueno) references cliente(id_dueno),
    foreign key (id_veterinario) references veterinario(no_cedula)
);

-- tabla para el detalle de ventas
create table if not exists detalle_venta (
    id_venta int,
    codigo_barras int,
    cantidad int,
    foreign key (id_venta) references venta(id_venta),
    foreign key (codigo_barras) references producto(codigo_barras)
);

-- tabla para los proveedores
create table if not exists proveedor (
    id_proveedor int primary key,
    nombre varchar(100) not null,
    email varchar(100),
    direccion varchar(255)
);

-- tabla para las compras
create table if not exists compra (
    id_compra int primary key,
    id_proveedor int,
    fecha date not null,
    foreign key (id_proveedor) references proveedor(id_proveedor)
);

-- tabla para el detalle de compras
create table if not exists detalle_compra (
    id_compra int,
    codigo_barras int,
    cantidad int,
    foreign key (id_compra) references compra(id_compra),
    foreign key (codigo_barras) references producto(codigo_barras)
);

-- tabla para los teléfonos de los proveedores
create table if not exists telefono_proveedor (
    id_proveedor int,
    telefono varchar(20) not null,
    tipo_contacto varchar(50),
    foreign key (id_proveedor) references proveedor(id_proveedor)
);

-- insertar datos en la tabla cliente
insert into cliente (id_dueno, nombre, apellido_p, apellido_m, email, direccion)
values 
(1, 'carlos', 'ramirez', 'sanchez', 'carlos.ramirez@example.com', 'calle falsa 123'),
(2, 'ana', 'lopez', 'garcia', 'ana.lopez@example.com', 'avenida siempre viva 742'),
(3, 'lucia', 'martinez', 'sanchez', 'lucia.martinez@example.com', 'calle del sol 123'),
(4, 'roberto', 'torres', 'lopez', 'roberto.torres@example.com', 'avenida de la luna 742'),
(5, 'julia', 'gomez', 'perez', 'julia.gomez@example.com', 'calle estrella 456'),
(6, 'luis', 'alvarez', 'rodriguez', 'luis.alvarez@example.com', 'avenida central 123');

-- insertar datos en la tabla telefono_cliente
insert into telefono_cliente (id_dueno, telefono, tipo_contacto)
values 
(1, '555-4321', 'personal'),
(2, '555-8765', 'trabajo'),
(3, '555-2345', 'personal'),
(4, '555-3456', 'trabajo'),
(5, '555-4567', 'personal'),
(6, '555-5678', 'trabajo');

-- insertar datos en la tabla veterinario
insert into veterinario (no_cedula, nombre, apellido_p, apellido_m, email)
values 
(12345, 'juan', 'perez', 'lopez', 'juan.perez@example.com'),
(67890, 'maria', 'gonzalez', 'martinez', 'maria.gonzalez@example.com'),
(11223, 'luis', 'martinez', 'diaz', 'luis.martinez@example.com'),
(33445, 'susan', 'rodriguez', 'alvarez', 'susan.rodriguez@example.com'),
(55667, 'emilio', 'gomez', 'santos', 'emilio.gomez@example.com'),
(77889, 'lucia', 'fernandez', 'torres', 'lucia.fernandez@example.com');

-- insertar datos en la tabla especialidad_veterinario
insert into especialidad_veterinario (no_cedula, especialidad, descripcion)
values 
(12345, 'cirugía', 'especialista en cirugía animal'),
(67890, 'dermatología', 'especialista en dermatología animal'),
(11223, 'oftalmología', 'especialista en oftalmología animal'),
(33445, 'neurología', 'especialista en neurología animal'),
(55667, 'oncología', 'especialista en oncología animal'),
(77889, 'cardiología', 'especialista en cardiología animal');

-- insertar datos en la tabla telefono_veterinario
insert into telefono_veterinario (no_cedula, telefono, tipo_contacto)
values 
(12345, '555-1234', 'personal'),
(12345, '555-5678', 'trabajo'),
(67890, '555-8765', 'personal'),
(11223, '555-2233', 'personal'),
(11223, '555-3344', 'trabajo'),
(33445, '555-4455', 'personal'),
(55667, '555-5566', 'personal'),
(77889, '555-6677', 'personal');

-- insertar datos en la tabla paciente
insert into paciente (id_paciente, id_dueno, nombre, especie, raza, sexo, fecha_nac, peso)
values 
(101, 1, 'firulais', 'perro', 'labrador', 'macho', '2015-05-10', 25.3),
(102, 2, 'michi', 'gato', 'siames', 'hembra', '2018-08-22', 4.2),
(103, 3, 'rex', 'perro', 'pastor alemán', 'macho', '2016-07-10', 30.0),
(104, 4, 'nina', 'gato', 'persa', 'hembra', '2017-01-15', 3.8),
(105, 5, 'bobby', 'perro', 'beagle', 'macho', '2014-03-20', 15.0),
(106, 6, 'duke', 'perro', 'golden retriever', 'macho', '2019-02-14', 28.5);

-- insertar datos en la tabla cita
insert into cita (no_cita, no_cedula, id_paciente, descripcion, estado, fecha, hora, folio_cita)
values 
(1001, 12345, 101, 'consulta general', 'completada', '2024-06-15', '10:00:00', 2001),
(1002, 67890, 102, 'vacunación', 'programada', '2024-06-16', '11:00:00', 2002),
(1003, 11223, 103, 'control de peso', 'completada', '2024-06-17', '12:00:00', 2003),
(1004, 33445, 104, 'limpieza dental', 'completada', '2024-06-18', '13:00:00', 2004),
(1005, 55667, 105, 'consulta por infección', 'completada', '2024-06-19', '14:00:00', 2005),
(1006, 77889, 106, 'vacunación anual', 'programada', '2024-06-20', '15:00:00', 2006);

-- insertar datos en la tabla historial_medico
insert into historial_medico (id_historial, id_paciente, diagnostico, tratamiento, fecha_reg, folio_cita)
values 
(1, 101, 'otitis', 'antibiótico', '2024-06-15', 2001),
(2, 102, 'gastroenteritis', 'dieta blanda', '2024-06-10', 2002),
(3, 103, 'infección de piel', 'antibiótico', '2024-06-20', 2003),
(4, 104, 'parásitos intestinales', 'desparasitante', '2024-06-21', 2004),
(5, 105, 'problemas dentales', 'limpieza dental', '2024-06-22', 2005),
(6, 106, 'vacunación anual', 'vacuna', '2024-06-23', 2006);

-- insertar datos en la tabla paciente_alergia
insert into paciente_alergia (id_paciente, alergia, descripcion)
values 
(101, 'polen', 'reacción alérgica al polen'),
(102, 'lácteos', 'intolerancia a los productos lácteos'),
(103, 'polvo', 'alergia al polvo'),
(104, 'granos', 'intolerancia a los granos'),
(105, 'flores', 'reacción alérgica a las flores'),
(106, 'humo', 'alergia al humo');

-- insertar datos en la tabla producto
insert into producto (codigo_barras, nombre, descripcion, tipo, stock, precio_v, precio_c)
values 
(100001, 'vacuna rabia', 'vacuna contra la rabia', 'vacuna', 50, 20.00, 15.00),
(100002, 'alimento perro', 'alimento para perros adultos', 'alimento', 200, 15.00, 10.00),
(100003, 'collar antipulgas', 'collar para el control de pulgas', 'accesorio', 100, 10.00, 7.00),
(100004, 'juguete para perro', 'juguete resistente para perros', 'juguete', 150, 5.00, 3.00),
(100005, 'comida para gato', 'alimento premium para gatos', 'alimento', 120, 18.00, 12.00),
(100006, 'shampoo para perro', 'shampoo antipulgas para perros', 'accesorio', 80, 12.00, 9.00);

-- insertar datos en la tabla venta
insert into venta (id_venta, id_dueno, id_veterinario, fecha)
values 
(2001, 1, 12345, '2024-06-14'),
(2002, 2, 67890, '2024-06-15'),
(2003, 3, 11223, '2024-06-20'),
(2004, 4, 33445, '2024-06-21'),
(2005, 5, 55667, '2024-06-22'),
(2006, 6, 77889, '2024-06-23');

-- insertar datos en la tabla detalle_venta
insert into detalle_venta (id_venta, codigo_barras, cantidad)
values 
(2001, 100001, 1),
(2002, 100002, 2),
(2003, 100003, 2),
(2004, 100004, 3),
(2005, 100005, 1),
(2006, 100006, 2);

-- insertar datos en la tabla proveedor
insert into proveedor (id_proveedor, nombre, email, direccion)
values 
(3001, 'proveedor uno', 'proveedor1@example.com', 'calle principal 100'),
(3002, 'proveedor dos', 'proveedor2@example.com', 'avenida central 200'),
(3003, 'proveedor tres', 'proveedor3@example.com', 'calle comercial 300'),
(3004, 'proveedor cuatro', 'proveedor4@example.com', 'avenida industrial 400');

-- insertar datos en la tabla telefono_proveedor
insert into telefono_proveedor (id_proveedor, telefono, tipo_contacto)
values 
(3001, '555-1234', 'principal'),
(3002, '555-5678', 'secundario'),
(3003, '555-6789', 'principal'),
(3004, '555-7890', 'secundario');

-- insertar datos en la tabla compra
insert into compra (id_compra, id_proveedor, fecha)
values 
(4001, 3001, '2024-06-13'),
(4002, 3002, '2024-06-14'),
(4003, 3003, '2024-06-15'),
(4004, 3004, '2024-06-16');

-- insertar datos en la tabla detalle_compra
insert into detalle_compra (id_compra, codigo_barras, cantidad)
values 
(4001, 100001, 10),
(4002, 100002, 20),
(4003, 100003, 30),
(4004, 100004, 50);
