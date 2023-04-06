program Ej9P2;
const
    valorAlto = 9999;

type
    Mesa = record
        codProvincia: integer;
        codLocalidad: integer;
        codMesa: integer;
        cantVotos: integer;
    end;
    
    Maestro = file of Mesa;
//////////////////////////////////////////////
procedure CargarMesa(var m: Mesa);
begin

    with m do begin
    
        readln(codProvincia);
        if(codProvincia <> -1) then begin
            readln(codLocalidad);
            readln(codMesa);
            readln(cantVotos);
        end;
    
    end;

end;
//////////////////////////////////////////////
procedure CargarArchivo(var M: Maestro);
var mReg: Mesa;
begin

    Assign(M, 'Maestro.bi');
    Rewrite(M);
    
    CargarMesa(mReg);
    
    while (mReg.codProvincia <> -1) do begin
        write(M, mReg);
        CargarMesa(mReg);
    end;
    
    Close(M);

end;
//////////////////////////////////////////////
procedure Leer(var Maestro: Maestro; var m: Mesa);
begin

    if(not eof(Maestro)) then read(Maestro, m)
                         else m.codProvincia := 9999;

end;
//////////////////////////////////////////////
procedure ProcesarVotos(var Maestro: Maestro);
var m: Mesa; Provincia, Localidad, totalLocalidad, totalProvincia, totalPais: integer;
begin
    totalPais := 0;
    Reset(Maestro);
    Leer(Maestro, m);
    
    while (m.codProvincia <> valorAlto) do begin
        
        Provincia := m.codProvincia;
        totalProvincia := 0;
        writeln('Provincia: ', Provincia);
        while ((m.codProvincia <> valorAlto) and (Provincia = m.codProvincia)) do begin
            Localidad := m.codLocalidad;
            totalLocalidad := 0;
            while ((m.codProvincia <> valorAlto) and (Provincia = m.codProvincia) and (Localidad = m.codLocalidad)) do begin
                
                totalLocalidad := totalLocalidad + m.cantVotos;
                Leer(Maestro, m);
            end;
            writeln('Localidad: ', Localidad, '      Votos: ', totalLocalidad);
            totalProvincia := totalProvincia + totalLocalidad;
        end;
        totalPais := totalPais + totalProvincia;
        writeln('Total de Votos Provincia: ', totalProvincia);
        writeln('---------------------------------');
    end;
    
    writeln('Total de Votos Pais: ', totalPais);
    Close(Maestro);


end;
//////////////////////////////////////////////
var M: Maestro;
begin
    CargarArchivo(M);
    ProcesarVotos(M);
end.
