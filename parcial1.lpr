program parcial1;
const
     valorAlto = 9999;
type
    cadena = string[50];
    corredor = record
             dni:integer;
             apellido: cadena;
             nombre: cadena;
             kms: real;
             gano_perdio:integer;
    end;
    tArchivo = file of corredor;
    arregloDetalles = array[1..5] of tArchivo;
    arregloCorredores = array[1..5] of corredor;
procedure leer (var archivo:tArchivo; var dato:corredor);
begin
     if(not(EOF(archivo)))then
         read(archivo,dato)
     else
         dato.dni:=valorAlto;
end;

procedure minimo(var detalles:arregloDetalles;var corredores:arregloCorredores; var minimo:corredor);
var
   posMin, i:integer;
begin
     posMin:=1;
     minimo:=corredores[1];
     for i:= 2 to 5 do
     begin
          if(corredores[i].dni < minimo.dni)then
          begin
              minimo:=corredores[i];
              posMin:=i;
          end;
     end;
     leer(detalles[posMin], corredores[posMin]);
end;

var
   detalles:arregloDetalles;
   corredores:arregloCorredores;
   maestro: tArchivo;
   min, reg: corredor;
   i:integer;
   text: string;
begin
     for i:=1 to 5 do
     begin
          Str(i,text);
          writeln(text);
          assign(detalles[i], 'detalle' + text);
          reset(detalles[i]);
          leer(detalles[i],corredores[i]);
     end;
     assign(maestro,'maestro');
     rewrite(maestro);

     minimo(detalles,corredores,min);
     while(min.dni <> valorAlto) do
     begin
          reg.dni := min.dni;
          reg.apellido := min.apellido;
          reg.nombre := min.nombre;
          reg.kms := 0;
          reg.gano_perdio := 0;
          while(min.dni = reg.dni) do
          begin
               reg.kms := reg.kms + min.kms;
               if(min.gano_perdio = 1)then
                   reg.gano_perdio := reg.gano_perdio + 1;
               minimo(detalles,corredores,min);
          end;
          write(maestro,reg);
     end;
     close(maestro);
     for i:=1 to 5 do
         close(detalles[i]);
end.
