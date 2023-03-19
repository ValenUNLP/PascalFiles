procedure LeerArchivo(var archivo: numbersFile);
    var aux: integer;
    begin
        Reset(archivo);
        
        while not eof(archivo) do begin
            Read(archivo, aux);
            writeln(aux);
        end;
        Close(archivo);
    end;