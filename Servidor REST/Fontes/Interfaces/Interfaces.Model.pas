unit Interfaces.Model;

interface

Uses
  Banco.Classe,
  Rest.ConstStr,
  Classes;

Type
  IModelBanco = Interface
    ['{396BC014-0AD9-4BE3-9B77-EF4066334DE3}']
    Function Get(Banco: TBanco; Offset: integer =0; limit:integer=0): TextJSON;
    Function Post(Banco: TBanco): Boolean;
    Function Put(Banco: TBanco): Boolean;
    Function Delete(Banco: TBanco): Boolean;
  End;

implementation

end.
