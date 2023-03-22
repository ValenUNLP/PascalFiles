//Realizar un programa que presente un menú con opciones para:
//a. Crear un archivo de registros no ordenados de empleados y completarlo con
//datos ingresados desde teclado. De cada empleado se registra: número de
//empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
//DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
//b. Abrir el archivo anteriormente generado y
//i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
//determinado.
//ii. Listar en pantalla los empleados de a uno por línea.
//iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse

Program P1Ej3(output);
    type
    Palabra= string[20];
    Empleado = record
        apellido: Palabra;
        nombre: Palabra;
        edad: integer;
        dni: integer;
        id: integer;
    end;
    ArchivoEmpleado = file of Empleado;
    ///////////////////////////////////////
    procedure CargarEmpleado(var e: Empleado);
    begin
        readln(e.apellido);
        if(e.apellido <> 'fin') then begin
            readln(e.nombre);
            readln(e.edad);
            readln(e.dni);
            readln(e.id);
        end;
    end;
    ///////////////////////////////////////
    procedure CargarEmpleados(var arch: ArchivoEmpleado);
    var e: Empleado;
    begin
        Rewrite(arch);
        CargarEmpleado(e);
        while(e.apellido <> 'fin') do begin
            Write(arch, e);
            CargarEmpleado(e);
        end;
        Close(arch);
    end;
    ///////////////////////////////////////
    procedure BuscarEmpleado(var arch: ArchivoEmpleado; nom, ape: Palabra);
    var e: Empleado; cont: integer;
    begin
        Reset(arch);
        cont := 0;
        while not (eof(arch)) do begin
            Read(arch, e);
            if((e.nombre = nom) or (e.apellido = ape)) then begin
                cont := cont + 1;
                writeln('Datos del usuario encontrado: ', e.nombre, ' ', e.apellido);
                writeln('Edad: ', e.edad);
                writeln('Dni: ', e.dni);
                writeln('Id: ', e.id);
                writeln('                             ');
            end;
        end;
        Close(arch);
        if(cont = 0) then writeln('No se ah encontrado ningun empleado con ese nombre y apellido');
        writeln('-------------------------------');
    end;
    ///////////////////////////////////////
    procedure ListaDeEmpleados(var arch: ArchivoEmpleado);
    var e: Empleado; cont: integer;
    begin
        cont := 0;
        Reset(arch);
        while not (eof(arch)) do begin
            Read(arch, e);
            cont := cont + 1;
            writeln(e.nombre, ' ', e.apellido, ' ', e.edad, ' ', e.dni, ' ', e.id);
            writeln('----------------------------------------------');
        end;
        Close(arch);
        if(cont = 0) then writeln('No hay empleados en la base de datos');
    end;
    ///////////////////////////////////////
    procedure ProximosAJubilarse(var arch: ArchivoEmpleado);
    var e: Empleado; cont: integer;
    begin
        cont := 0;
        Reset(arch);
        while not (eof(arch)) do begin
            Read(arch, e);
            if(e.edad > 70) then begin 
                cont := cont + 1;
                writeln(e.nombre, ' ', e.apellido, ' ', e.edad, ' ', e.dni, ' ', e.id);
                writeln('----------------------------------------------');
            end;
        end;
        Close(arch);
        if cont = 0 then writeln('No hay empleados proximos a jubilarse');
    end;
    ///////////////////////////////////////
    var archEmpleados: ArchivoEmpleado;registerName: string; Nombre, Apellido: Palabra;opcion: integer;
    begin
        writeln('Bienvenido al menu');
        writeln('Ingrese la opcion que quiera ejecutar:');
        writeln('1. Cargar empleados');
        writeln('2. Buscar empleados por nombre o apellido');
        writeln('3. Lista de todos los empleados');
        writeln('4. Lista de empleados proximos a jubilarse');
        readln(opcion);
        if(opcion = 1) then
        begin
            readln(registerName);
            Assign(archEmpleados, registerName);
            CargarEmpleados(archEmpleados); 
        end
        else if (opcion = 2) then 
        begin
            readln(Nombre);
            readln(Apellido);
            BuscarEmpleado(archEmpleados, Nombre, Apellido);
        end
        else if (opcion = 3) then 
        begin
        ListaDeEmpleados(archEmpleados);
        end
        else if (opcion = 4) then 
        begin 
        ProximosAJubilarse(archEmpleados);
        end
        else writeln('Opcion invalida');
end.