# RISC-V-Pipelined-Processor-ELO311
Este repositorio almacena un procesador RISC-V con pipeline descrito en SystemVerilog. Este cuenta con las 5 etapas revisadass a lo largo del curso ELO311 (Estructura de Computadores), siendo estas: Instruction Fetch, Instruction Decode, Execute, Memory Access y Writeback.
Todos estos módulos (y sus respectivos submódulos) fueron descritos a modo de proyecto para presentar para este mismo curso.
Adicionalmente también deberían existir algunos testbenchs (tb_) de las 5 etapas para asegurar su funcionamiento y asímismo del procesador como tal.


# Notas Adicionales
Actualmente este repositorio no está actualizado, ya que debería contar con Hazard Unit y un programa que puede transformar el ISA de RISC-V a hexadecimal, pero aún no tengo acceso al dispositivo en donde
lo desarrollé. 
Este "traductor" se realizó a modo de mejorar el flujo de trabajo para lograr ingresar instrucciones al procesador con mayor facilidad.

El modo de uso básico sería ingresar las instrucciones para obtener su respectivo valor hexadecimal y posteriormente esto, ingresarlo al módulo Instruction Memory, el cual 
posteriormente procesará estas instrucciones.
