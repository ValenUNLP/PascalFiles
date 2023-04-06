program Ej8P2;
const
    valorAlto = 9999;
type
    palabra = string[20];

    Venta = record
        cod: integer;
        nombre: palabra;
        apellido: palabra;
        ano: integer;
        mes: integer;
        dia: integer;
        monto: integer;
    end;

    Maestro = file of Venta;
//////////////////////////////////////////////////
procedure CargarVenta(var v: Venta);
begin

    with v do begin
    
        readln(cod);
        
        if(cod <> -1) then begin
        
            readln(nombre);
            readln(apellido);
            readln(ano);
            readln(mes);
            readln(dia);
            readln(monto);
            
        end;
    
    end;

end;
//////////////////////////////////////////////////
procedure CargarArchivo(var M: Maestro);
var v: Venta;
begin

    Assign(M, 'Maestro.bi');
    Rewrite(M);
    
    CargarVenta(v);
    
    while (v.cod <> -1) do begin
    
        write(M, v);
        CargarVenta(v);
    
    end;
    
    Close(M);

end;
//////////////////////////////////////////////////
procedure Leer(var m: Maestro;var v: Venta);
begin

    if(not eof(m)) then read(m, v)
                   else v.cod := valorAlto;
    
end;
//////////////////////////////////////////////////


procedure ProcesarInformacion(var M: Maestro);
var v:Venta; cod, ano, montoAno, montoTotal: integer;
begin

    Reset(M);
    
    Leer(M, v);
    montoTotal := 0;
    while(v.cod <> valorAlto) do begin
    
        cod := v.cod;
        
        writeln(v.cod,'-', v.nombre, ' ', v.apellido);
        while (cod = v.cod) do begin
            ano := v.ano;
            
            writeln('año: ', v.ano);
            montoAno := 0;
            while ((ano = v.ano) and (cod = v.cod)) do begin
                montoAno := montoAno + v.monto;
                writeln('mes ', v.mes,': ', v.monto);
                Leer(M, v);
            end;
            montoTotal := montoTotal + montoAno;
            writeln('Total gastado en el año por el cliente: ', montoAno);
        end;
            writeln('---------------------');
        
    end;
        writeln('Total ganancia en la empresa: ', montoTotal);
    Close(M);

end;
//////////////////////////////////////////////////
var M: Maestro;
begin

    CargarArchivo(M);
    ProcesarInformacion(M);
end.
