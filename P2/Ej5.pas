program Ej5P2;
const valorAlto = 9999;
    cantDetalles = 3;
type
    Fecha = record
        ano: integer;
        mes: integer;
        dia: integer;
    end;
    
    Hora = record
        hora: integer;
        minutos: integer;
    end;
    palabra = string[20];
    Matricula_Medico = record
        fecha: Fecha;
        hora: Hora;
        lugar: palabra;
    end;
    
    Direccion = record
        calle: palabra;
        nro: integer;
        piso: integer;
        depto: integer;
        ciudad: palabra;
    end;
    
    Persona = record
        nombre: palabra;
        apellido: palabra;
        dni: integer;
    end;
    
    Nacimiento = record
        nro_partida_nacimiento: integer;
        nombre: palabra;
        apellido: palabra;
        direccion: Direccion;
        matricula_medico: Matricula_Medico;
        madre: Persona;
        padre: Persona;
    end;
    
    
    Fallecimiento = record
        nro_partida_nacimiento: integer;
        datos: Persona;
        matricula_medico: Matricula_Medico;
    end;
    
    MaestroReg = record
        nro_partida_nacimiento: integer;
        nombre: palabra;
        apellido: palabra;
        direccion: Direccion;
        matricula_medico_nacimiento: Matricula_Medico;
        madre: Persona;
        padre: Persona;
        muerte: boolean;
        matricula_medico_fallecimiento: Matricula_Medico;
    end;
    
    ArchNacimiento = file of Nacimiento;
    ArchFallecimiento = file of Fallecimiento;
    
    Detalles_Nacimiento = array[1..3] of ArchNacimiento;
    Detalles_Fallecimiento = array[1..3] of ArchFallecimiento;
    
    ArchMaestro = file of MaestroReg;
    
    RegNacimiento = array[1..3] of Nacimiento;
    RegFallecimiento = array[1..3] of Fallecimiento;
    
//////////////////////////////////////////////////////////////////////////    
procedure CargarRegistroNacimiento(var n: Nacimiento);
begin
    with n do begin
    
        readln(nro_partida_nacimiento);
        
        if(nro_partida_nacimiento <> -1) then begin
            
            readln(nombre);
            readln(apellido);
            
            readln(direccion.calle);
            readln(direccion.nro);
            readln(direccion.piso);
            readln(direccion.depto);
            readln(direccion.ciudad);
            
            readln(matricula_medico.fecha.ano);
            readln(matricula_medico.fecha.mes);
            readln(matricula_medico.fecha.dia);
            
            readln(matricula_medico.hora.hora);
            readln(matricula_medico.hora.minutos);
            
            readln(matricula_medico.lugar);
            
            readln(madre.nombre);
            readln(madre.apellido);
            readln(madre.dni);
            
            readln(padre.nombre);
            readln(padre.apellido);
            readln(padre.dni);
        end;
    
    end;
end;
//////////////////////////////////////////////////////////////////////////
procedure CargarRegistroFallecimiento(var f: Fallecimiento);
begin
    with f do begin
        
        readln(nro_partida_nacimiento);
        
        if(nro_partida_nacimiento <> -1) then begin
        
            readln(datos.nombre);
            readln(datos.apellido);
            readln(datos.dni);
            
            readln(matricula_medico.fecha.ano);
            readln(matricula_medico.fecha.mes);
            readln(matricula_medico.fecha.dia);
            
            readln(matricula_medico.hora.hora);
            readln(matricula_medico.hora.minutos);
            
            readln(matricula_medico.lugar);
        end;
        
    end;
end;
//////////////////////////////////////////////////////////////////////////
procedure CargarArchNacimiento(var Archivo: ArchNacimiento);
var n: Nacimiento;
begin
    Reset(Archivo);
    
    CargarRegistroNacimiento(n);
    
    while n.nro_partida_nacimiento <> -1 do begin
        write(Archivo, n);
        CargarRegistroNacimiento(n);
    end;
    
    Close(Archivo);
end;
//////////////////////////////////////////////////////////////////////////
procedure CargarArchFallecimiento(var Archivo: ArchFallecimiento);
var f: Fallecimiento;
begin
    Reset(Archivo);
    
    CargarRegistroFallecimiento(f);
    
    while f.nro_partida_nacimiento <> -1 do begin
        write(Archivo, f);
        CargarRegistroFallecimiento(f);
    end;
    
    Close(Archivo);
end;
//////////////////////////////////////////////////////////////////////////
procedure LeerNacimiento(var Archivo: ArchNacimiento; var n: Nacimiento);
begin

    if(not eof(Archivo)) then read(Archivo, n)
                         else n.nro_partida_nacimiento := valorAlto;

end;
//////////////////////////////////////////////////////////////////////////
procedure LeerFallecimiento(var Archivo: ArchFallecimiento; var f: Fallecimiento);
begin

    if(not eof(Archivo)) then read(Archivo, f)
                         else f.nro_partida_nacimiento := valorAlto;

end;
//////////////////////////////////////////////////////////////////////////
procedure CargarDetalles(var DetalleNacimiento : Detalles_Nacimiento; var DetalleFallecimiento: Detalles_Fallecimiento);
var i: integer; i_str: string;
begin
    
    for i:=1 to cantDetalles do begin
        Str(i, i_str);
        Assign(DetalleNacimiento[i], 'Detalle-Nacimiento-' + i_str);
        Assign(DetalleFallecimiento[i], 'Detalle-Falleci-' + i_str);
        
        Rewrite(DetalleNacimiento[i]);
        Rewrite(DetalleFallecimiento[i]);
        
        CargarArchNacimiento(DetalleNacimiento[i]);
        CargarArchFallecimiento(DetalleFallecimiento[i]);
        
    end;


end;
//////////////////////////////////////////////////////////////////////////
procedure MinimoNacimiento(var DetallesNacimiento: Detalles_Nacimiento; var min: Nacimiento; var Registros: RegNacimiento);
begin
    if((Registros[1].nro_partida_nacimiento <= Registros[2].nro_partida_nacimiento) and (Registros[1].nro_partida_nacimiento <= Registros[3].nro_partida_nacimiento)) then begin
        min := Registros[1];
        LeerNacimiento(DetallesNacimiento[1], Registros[1]);
    end else
        if ((Registros[2].nro_partida_nacimiento <= Registros[3].nro_partida_nacimiento)) then begin
            min := Registros[2];
            LeerNacimiento(DetallesNacimiento[2], Registros[2]);
        end else begin
                min := Registros[3];
                LeerNacimiento(DetallesNacimiento[3], Registros[3]);
            end;
end;
//////////////////////////////////////////////////////////////////////////
procedure MinimoFallecimiento(var DetallesFallecimiento: Detalles_Fallecimiento; var min: Fallecimiento; var Registros: RegFallecimiento);
begin
    if((Registros[1].nro_partida_nacimiento <= Registros[2].nro_partida_nacimiento) and (Registros[1].nro_partida_nacimiento <= Registros[3].nro_partida_nacimiento)) then begin
        min := Registros[1];
        LeerFallecimiento(DetallesFallecimiento[1], Registros[1]);
    end else
        if ((Registros[2].nro_partida_nacimiento <= Registros[3].nro_partida_nacimiento)) then begin
            min := Registros[2];
            LeerFallecimiento(DetallesFallecimiento[2], Registros[2]);
        end else begin
                min := Registros[3];
                LeerFallecimiento(DetallesFallecimiento[3], Registros[3]);
            end;
end;
//////////////////////////////////////////////////////////////////////////
procedure Merge(var DetallesNacimiento: Detalles_Nacimiento; var DetallesFallecimiento: Detalles_Fallecimiento; var Maestro: ArchMaestro);
var RegistrosNacimiento: RegNacimiento; RegistrosFallecimiento: RegFallecimiento; MinNacimiento, actualNacimiento: Nacimiento; MinFallecimiento: Fallecimiento; i: integer; regMaestro: MaestroReg;
begin
    Assign(Maestro, 'Maestro.bi');
    Rewrite(Maestro);
    
    for i := 1 to cantDetalles do begin
        Reset(DetallesNacimiento[i]);
        Reset(DetallesFallecimiento[i]);
        
        LeerNacimiento(DetallesNacimiento[i], RegistrosNacimiento[i]);
        LeerFallecimiento(DetallesFallecimiento[i], RegistrosFallecimiento[i]);
        
    end;
    
    MinimoNacimiento(DetallesNacimiento, MinNacimiento, RegistrosNacimiento);
    MinimoFallecimiento(DetallesFallecimiento, MinFallecimiento, RegistrosFallecimiento);
    
    while MinNacimiento.nro_partida_nacimiento <> valorAlto do begin
    
        //actualNacimiento := MinNacimiento;
        if(MinNacimiento.nro_partida_nacimiento = MinFallecimiento.nro_partida_nacimiento) then begin
        
            regMaestro.nro_partida_nacimiento := MinNacimiento.nro_partida_nacimiento;
            regMaestro.nombre := MinNacimiento.nombre;
            regMaestro.apellido := MinNacimiento.apellido;
            regMaestro.direccion.calle := MinNacimiento.direccion.calle;
            regMaestro.direccion.nro := MinNacimiento.direccion.nro;
            regMaestro.direccion.piso := MinNacimiento.direccion.piso;
            regMaestro.direccion.depto := MinNacimiento.direccion.depto;
            regMaestro.direccion.ciudad := MinNacimiento.direccion.ciudad;
            
            regMaestro.matricula_medico_nacimiento.fecha.ano := MinNacimiento.matricula_medico.fecha.ano;
            regMaestro.matricula_medico_nacimiento.fecha.mes := MinNacimiento.matricula_medico.fecha.mes;
            regMaestro.matricula_medico_nacimiento.fecha.dia := MinNacimiento.matricula_medico.fecha.dia;
            
            regMaestro.matricula_medico_nacimiento.hora.hora := MinNacimiento.matricula_medico.hora.hora;
            regMaestro.matricula_medico_nacimiento.hora.minutos := MinNacimiento.matricula_medico.hora.minutos;
            
            regMaestro.matricula_medico_nacimiento.lugar := MinNacimiento.matricula_medico.lugar;
            
            regMaestro.madre.nombre := MinNacimiento.madre.nombre;
            regMaestro.madre.apellido := MinNacimiento.madre.apellido;
            regMaestro.madre.dni := MinNacimiento.madre.dni;
            
            regMaestro.padre.nombre := MinNacimiento.padre.nombre;
            regMaestro.padre.apellido := MinNacimiento.padre.apellido;
            regMaestro.padre.dni := MinNacimiento.padre.dni;
            
            regMaestro.muerte := true;
            
            regMaestro.matricula_medico_fallecimiento.fecha.ano := MinFallecimiento.matricula_medico.fecha.ano;
            regMaestro.matricula_medico_fallecimiento.fecha.mes := MinFallecimiento.matricula_medico.fecha.mes;
            regMaestro.matricula_medico_fallecimiento.fecha.dia := MinFallecimiento.matricula_medico.fecha.dia;
            
            regMaestro.matricula_medico_fallecimiento.hora.hora := MinFallecimiento.matricula_medico.hora.hora;
            regMaestro.matricula_medico_fallecimiento.hora.minutos := MinFallecimiento.matricula_medico.hora.minutos;
            
            regMaestro.matricula_medico_fallecimiento.lugar := MinFallecimiento.matricula_medico.lugar;
        end else begin
        
            regMaestro.nro_partida_nacimiento := MinNacimiento.nro_partida_nacimiento;
            regMaestro.nombre := MinNacimiento.nombre;
            regMaestro.apellido := MinNacimiento.apellido;
            regMaestro.direccion.calle := MinNacimiento.direccion.calle;
            regMaestro.direccion.nro := MinNacimiento.direccion.nro;
            regMaestro.direccion.piso := MinNacimiento.direccion.piso;
            regMaestro.direccion.depto := MinNacimiento.direccion.depto;
            regMaestro.direccion.ciudad := MinNacimiento.direccion.ciudad;
            
            regMaestro.matricula_medico_nacimiento.fecha.ano := MinNacimiento.matricula_medico.fecha.ano;
            regMaestro.matricula_medico_nacimiento.fecha.mes := MinNacimiento.matricula_medico.fecha.mes;
            regMaestro.matricula_medico_nacimiento.fecha.dia := MinNacimiento.matricula_medico.fecha.dia;
            
            regMaestro.matricula_medico_nacimiento.hora.hora := MinNacimiento.matricula_medico.hora.hora;
            regMaestro.matricula_medico_nacimiento.hora.minutos := MinNacimiento.matricula_medico.hora.minutos;
            
            regMaestro.matricula_medico_nacimiento.lugar := MinNacimiento.matricula_medico.lugar;
            
            regMaestro.madre.nombre := MinNacimiento.madre.nombre;
            regMaestro.madre.apellido := MinNacimiento.madre.apellido;
            regMaestro.madre.dni := MinNacimiento.madre.dni;
            
            regMaestro.padre.nombre := MinNacimiento.padre.nombre;
            regMaestro.padre.apellido := MinNacimiento.padre.apellido;
            regMaestro.padre.dni := MinNacimiento.padre.dni;
            
            regMaestro.muerte := false;
        
        end;
        write(Maestro, regMaestro);
        MinimoNacimiento(DetallesNacimiento, MinNacimiento, RegistrosNacimiento);
        MinimoFallecimiento(DetallesFallecimiento, MinFallecimiento, RegistrosFallecimiento);
    end;
    
    for i:= 1 to cantDetalles do begin
    
        Close(DetallesNacimiento[i]);
        Close(DetallesFallecimiento[i]);
    
    end;
    
    Close(Maestro);
end;
//////////////////////////////////////////////////////////////////////////
procedure Importar(var Maestro: ArchMaestro; var txt:text);
var  aux: MaestroReg;
begin
    Assign(txt, 'Maestro.TXT');
    Rewrite(txt);
    
    Reset(Maestro);
    
    while (not eof(Maestro)) do begin
    
        read(Maestro, aux);
        
        with aux do begin
        
        writeln(txt, nro_partida_nacimiento, ' ', nombre, ' ', muerte);
        
        end;
    
    end;
    
    Close(txt);
    Close(Maestro);
    
end;
//////////////////////////////////////////////////////////////////////////
var DetallesNacimiento: Detalles_Nacimiento; DetallesFallecimiento: Detalles_Fallecimiento; Maestro: ArchMaestro; i: integer; Maestrotxt: text;
begin
    CargarDetalles(DetallesNacimiento, DetallesFallecimiento);
    Merge(DetallesNacimiento, DetallesFallecimiento, Maestro);
    Importar(Maestro, Maestrotxt);
end.
