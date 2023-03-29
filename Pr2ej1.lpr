program Pr2ej1;
const
     ValorA = 9999;
type
  fecha = Record
           dia: integer;
           mes: integer;
           ano: integer;
  end;
  empleadoReg = Record
           codigo: integer;
           nombre: string[20];
           apellido: string[20];
           nacimiento: fecha;
           direccion: string[30];
           hijos: integer;
           telefono: integer;
           diasDeVaciones: integer;
  end;
  solicitud = Record
           codigo: integer;
           nacimiento: fecha;
           diasDeVaciones: integer;
  end;
  maestro = file of empleadoReg;
  detalle = file of solicitud;
  solicitudes = array[1..9] of solicitud;
  detalles = array[1..9] of detalle;
procedure Leer(var det: detalle; var regDet:solicitud);
begin
     if (not(EOF(det))) then
        read (det, regDet)
     else
         regDet.codigo := ValorA;
end;
procedure minimo(var arregloDetalles: detalles; var arregloSolicitud: solicitudes; var min:solicitud);
var
   posMin,i:integer;
begin
     min:=arregloSolicitud[1];
     posMin:=1;
     for i:=2 to 10 do
     begin
           if(arregloSolicitud[i].codigo < min.codigo)then
           begin
                min:=arregloSolicitud[i];
                posMin:=i;
           end;
     end;
     leer(arregloDetalles[posMin],arregloSolicitud[posMin]);
end;
procedure Actualizar(var M:maestro; var arregloDetalles:detalles; var nuevoArchivo:Text);
var
   arregloSolicitud:solicitudes;
   min: solicitud;
   regM:empleadoReg;
   i:integer;
begin
     for i:=1 to 10 do
     begin
          reset(arregloDetalles[i]);
          Leer(arregloDetalles[i],arregloSolicitud[i]);
     end;
     reset(M);
     minimo(arregloDetalles,arregloSolicitud,min);
     while(min.codigo <> ValorA)do
     begin
          read(M,regM);
          while(min.codigo <> regM.codigo)do
          begin
               read(M,regM);
          end;
          while(regM.codigo = min.codigo)and (min.codigo <> ValorA)do
          begin
               if(regM.diasDeVaciones < min.diasDeVaciones)then
               begin
                    writeln(nuevoArchivo,min.codigo);
                    writeln(nuevoArchivo,regM.nombre);
                    writeln(nuevoArchivo,regM.apellido);
                    writeln(nuevoArchivo,regM.diasDeVaciones, min.diasDeVaciones);
               end
               else
                   regM.diasDeVaciones:= regM.diasDeVaciones - min.diasDeVaciones;
               minimo(arregloDetalles,arregloSolicitud,min);
          end;
          seek(M,filepos(M)-1);{se ubica el puntero y actualiza}
          write(M,regM);
     end;
     close(M);
     for i:=1 to 10 do
         close(arregloDetalles[i]);
end;
//PROGRAMA PRINCIPAL
var
  M:maestro;
  arregloDetalles:detalles;
  archivoTexto:Text;
  nombreDet:String;
  i:integer;
begin
     assign(M,'maestro');
     for i:=1 to 10 do
     begin
          writeln('Escriba un nombre para el archivo');
          read(nombreDet);
          assign(arregloDetalles[i], nombreDet);
     end;
     assign(archivoTexto, 'empleadosConMasDiasDeVacaciones');
     rewrite(archivoTexto);
     Actualizar(M,arregloDetalles,archivoTexto);
end.
