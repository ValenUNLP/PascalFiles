program Ej12P2;
const 
    valorAlto = 9999;
type
    Acceso = record
        ano: integer;
        mes: integer;
        dia: integer;
        cod: integer;
        tiempo: integer;
    end;

    Maestro = file of Acceso;
//////////////////////////////////////////////////
procedure CargarAcceso(var a: Acceso);
begin

    with a do begin
    
        read(cod);
        
        if(cod <> -1) then begin
        
            readln(ano);
            readln(mes);
            readln(dia);
            readln(tiempo);
        
        end;
    
    end;


end;
//////////////////////////////////////////////////
procedure CargarMaestro(var M: Maestro);
var a: Acceso;
begin

    Assign(M, 'Maestor.bi');
    Rewrite(M);
    
    CargarAcceso(a);
    
    while (a.cod <> -1) do begin
    
        write(M, a);
        CargarAcceso(a);
    end;
    
    Close(M);

end;
//////////////////////////////////////////////////
procedure Leer(var m: Maestro; var a: Acceso);
begin

    if(not eof(m)) then read(m, a)
                   else a.cod := valorAlto;

end;
//////////////////////////////////////////////////
procedure ProcesarDatos(var M: Maestro; anoP: integer);
var a: Acceso; cod, ano, mes, dia, userTime, dayTime, monthTime, yearTime: integer; ok: boolean;
begin

    Reset(M);
    Leer(M, a);
    
        ok := true;
        while((a.ano <> anoP) and (ok)) do begin
            if(a.cod = valorAlto) then ok := false;
            Leer(M, a);
        end;
        ano := a.ano;
        yearTime := 0;
        if(ok) then begin
        writeln('Año ', ano);
        while ((anoP = a.ano) and (a.cod <> valorAlto)) do begin
            
            mes := a.mes;
            monthTime := 0;
            writeln('Mes ', mes);
            while ((anoP = a.ano) and (a.cod <> valorAlto) and (mes = a.mes)) do begin
            
                dia := a.dia;
                dayTime := 0;
                writeln('Dia ', dia);
                while((anoP = a.ano) and (a.cod <> valorAlto) and (mes = a.mes) and (dia = a. dia)) do begin
                
                    cod := a.cod;
                    userTime := 0;
                    while ((anoP = a.ano) and (a.cod <> valorAlto) and (mes = a.mes) and (dia = a. dia) and (cod = a.cod)) do begin
                        
                        userTime := userTime + a.tiempo;
                        Leer(M, a);
                    end;
                    dayTime := dayTime + userTime;
                    writeln('Usuario: ', cod, ' - Tiempo total de acceso: ', userTime, 'hs.');
                end;
                monthTime := monthTime + dayTime;
                writeln('Tiempo de acceso del dia: ', dayTime, 'hs.');
                writeln();
            end;
            yearTime := yearTime + monthTime;
            writeln('Tiempo de acceso del mes: ', monthTime, 'hs.');
            writeln();
        end;
        writeln('Tiempo de acceso del año: ', yearTime, 'hs.');
    end else begin
        writeln('No se encontro el año :p');
    end;
    
    Close(M);

end;
//////////////////////////////////////////////////
var m: Maestro;
begin
    CargarMaestro(m);
    ProcesarDatos(m, 2030);
end.
