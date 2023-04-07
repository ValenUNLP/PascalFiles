program Ej13P2;

const 
    valorAlto = 9999;

type
    palabra = string[20];
    
    RegMaestro = record
        nro_usuario: integer;
        nombreUsuario: palabra;
        nombre: palabra;
        apellido: palabra;
        cantidadMailEnviados: integer;
    end;
    
    RegDetalle = record
        nro_usuario: integer;
        cuentaDestino: palabra;
        cuerpoMensaje: palabra;
    end;
    
    Detalle = file of RegDetalle;
    Maestro = file of RegMaestro;

////////////////////////////////////////////////////////////////////
procedure CargarRegDetalle(var reg: RegDetalle);
begin

    with reg do begin
    
        readln(nro_usuario);
        
        if(nro_usuario <> -1) then begin
            readln(cuentaDestino);
            readln(cuerpoMensaje);
        end;
    
    end;

end;
///////////////////////////////////////////////////////////////////
procedure CargarRegMaestro(var reg: RegMaestro);
begin

    with reg do begin
    
        readln(nro_usuario);
        
        if(nro_usuario <> -1) then begin
            readln(nombreUsuario);
            readln(nombre);
            readln(apellido);
            readln(cantidadMailEnviados);
        end;
    
    end;

end;
///////////////////////////////////////////////////////////////////////
procedure CargarArchivos(var M: Maestro; var D: Detalle; ano, mes, dia: integer);
var str_ano, str_mes, str_dia: palabra; regM: RegMaestro; regD: RegDetalle;
begin
    Str(ano, str_ano);
    Str(mes, str_mes);
    Str(dia, str_dia);
    
    Assign(M, 'Maestro.bi');
    Assign(D, str_ano+'-'+str_mes+'-'+str_dia);
    
    Rewrite(M);
    Rewrite(D);
    
    
    CargarRegMaestro(regM);
    
    while(regM.nro_usuario <> -1) do begin
        write(M, regM);
        CargarRegMaestro(regM);
    end;
    
    CargarRegDetalle(regD);
    
    while(regD.nro_usuario <> -1) do begin
        write(D, regD);
        CargarRegDetalle(regD);
    end;
    
    
    Close(M);
    Close(D);

end;
///////////////////////////////////////////////////////////////////////
procedure Leer(var archivo: Detalle;var reg: RegDetalle);
begin

    if(not eof(archivo)) then read(archivo, reg)
                         else reg.nro_usuario := valorAlto;

end;
///////////////////////////////////////////////////////////////////////
procedure ActualizarMaestro(var M: Maestro; var D: Detalle);
var regM: RegMaestro; regD: RegDetalle;cod,totalMail: integer;
begin

    Reset(M);
    Reset(D);

    Leer(D, regD);
    read(M, regM);
    
    while (regD.nro_usuario <> valorAlto) do begin
    
        while (regD.nro_usuario <> regM.nro_usuario) do read(M, regM);
        
        cod := regD.nro_usuario;
        totalMail := 0;
        while (cod = regD.nro_usuario) do begin
            totalMail := totalMail + 1;
            Leer(D, regD);
        end;
        regM.cantidadMailEnviados := regM.cantidadMailEnviados + totalMail;
        Seek(M, filepos(M)-1);
        write(M, regM);
    end;

    Close(M);
    Close(D);
end;
///////////////////////////////////////////////////////////////////////
procedure ExportarTxT(var M: Maestro;var txt: text);
var regM: RegMaestro; campo: palabra;
begin
    Assign(txt,'Users.txt');
    Rewrite(txt);
    Reset(M);
    
    while (not eof(M)) do begin
        read(M, regM);
        writeln(txt, 'User: ', regM.nro_usuario, '  Mails Enviados: ', regM.cantidadMailEnviados);
    end;
    
    Close(txt);
    Close(M);
    
end;
///////////////////////////////////////////////////////////////////////
var M: Maestro; D: Detalle; txt: text;
begin
    CargarArchivos(M, D, 2023, 4, 7);
    ActualizarMaestro(M, D);
    ExportarTxT(M, txt);
end.
