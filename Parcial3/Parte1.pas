program Parcial3;
const
    valorAlto = 999;
type

sesion = record
    anio: integer;
    mes: integer;
    dia: integer;
    idUser: integer;
end;

ArchivoUsers = file of sesion;

//////////////////////////////////////
procedure cargarSesion(var s: sesion);
begin

    readln(s.anio);
    if(s.anio <> -1) then begin
        readln(s.mes);
        readln(s.dia);
        readln(s.idUser);
    end;

end;
//////////////////////////////////////
procedure cargarArchivoUsers(var Archivo: ArchivoUsers);
var s: sesion;
begin

    Rewrite(Archivo);
    
    cargarSesion(s);
    while(s.anio <> -1) do begin
        write(Archivo, s);
        cargarSesion(s);
    end;
    
    Close(Archivo);

end;
/////////////////////////////////////
procedure Leer(var a: ArchivoUsers; var s: sesion);
begin

if(not eof(a))  then read(a, s)
                else s.anio := valorAlto;

end;
/////////////////////////////////////
procedure informar(var Archivo: ArchivoUsers; anio: integer);
var s, act: sesion; totalUser, totalDia, totalMes, totalAnio: integer;
begin
    Reset(Archivo);
    
    Leer(Archivo, s);
    while(s.anio <> anio) and (s.anio <> valorAlto) do Leer(Archivo, s);
    
    if(s.anio = valorAlto) then begin
    
        writeln('No se encontro tal año');
    
    end else begin
        totalAnio := 0;
        act.anio := s.anio;
        writeln('Anio: ', act.anio);
        while(act.anio = s.anio) do begin
            act.mes := s.mes;
            writeln('   Mes: ', act.mes);
            totalMes := 0;
            while(act.anio = s.anio) and (act.mes = s.mes) do begin
                act.dia := s.dia;
                writeln('   Dia: ', act.dia);
                totalDia := 0;
                while (act.anio = s.anio) and (act.mes = s.mes)and (act.dia = s.dia) do begin 
                    act.idUser := s.idUser;
                    totalUser := 0;
                    while(act.idUser = s.idUser) and (act.anio = s.anio) and (act.mes = s.mes) and (act.dia = s.dia) do begin
                        totalUser := totalUser + 1;
                        Leer(Archivo, s);
                    end;
                        writeln('       User: ', act.idUser, ' Tiempo total acceso dia ', act.dia, ' Mes ', act.mes,': ', totalUser);
                        writeln('       ----------');
                        totalDia := totalDia + totalUser;
                end;
                    writeln('   Tiempo total de acceso dia ', act.dia, ' mes ', act.mes,': ', totalDia);
                    totalMes := totalMes + totalDia;
            end;
             writeln('   Tiempo total de acceso mes ', act.mes,': ', totalMes);
             totalAnio := totalAnio + totalMes;
        end;   
        writeln('   Tiempo total de acceso anio ', act.anio,': ', totalAnio);
    end;
    Close(Archivo);
end;
//////////////////////////////////////
var Archivo: ArchivoUsers;
begin
  assign(Archivo, 'ArchivoUsers.bi');
  cargarArchivoUsers(Archivo);
  /////// Procesos parcial
  informar(Archivo, 2018);//(lo adapta a cantidad de accesos y no a tiempo de acceso, me olvide de poner esa prop en el record xd)
end.
