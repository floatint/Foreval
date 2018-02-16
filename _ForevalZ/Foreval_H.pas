unit Foreval_H;

{******************************************************************************}
{                                                                              }
{                 SOREL (C)CopyRight 1999-2001. Russia, S.-Petersburg.         }
{                                                                              }
{ Algebra - программируемый интерпретатор строковых алгебраических  выражений  }
{                                                                              }
{                     -AlgebraG1-   ver. 1.0.1                                 }
{******************************************************************************}


{.$DEFINE TEXTOUT}

interface

uses
  Windows,  SysUtils, Classes,  Dialogs, Math, Forms, Controls, StdCtrls;

  const _PI = 3.141592653589793238462643;
  const  PI_2: extended = _PI/2;
  const  _LDSF = 3;
  const  _LDSC = 4;
  const  _FUNC = 1;
  const  _COP  = 2;



type
TAddress = Cardinal;

type TFloatType = double;

type PFloatType = ^TFloatType;



type
TArray4 = array [1..4] of byte;
type TCode = array of Byte;
type TArrayF = array of TFloatType;
type PArrayF = ^TArrayF;
type TAddFunc = function(N: Integer; SF: TArrayF): TFloatType;



type TArrayI = array of Integer;
type TArrayC = array of Cardinal;


type TIntType = array of Cardinal;



type TIntFunc  = array of
                  record
                   TypeF:   Cardinal;          //возвращаемый тип ф-ии
                   Addr: Cardinal;             //адрес ф-ии
                   N:    Integer;              //N=-1 Infinite
                   TV:   array of Cardinal;    //массив типов переменных (Size=N)
                  end;

type TAlgFunction = array of
                      record
                       Name: String;        //имя ф-ии
                       Func: TIntFunc;      //характеристики ф-ий с данным именем
                      end;






type TAlgOperation = array of
                      record
                       PR:  Cardinal;        //приоритет операции  (кроме '0'!)
                       Name:  String;        //имя символьной операции
                       NFunc: Cardinal;      //номер массива соответствующей ф-ии
                       GS:  Integer;         //для одноарг. операций: расположение
                                             //((-1)впереди;(-2)сзади)
                      end;                   //для многоарг. операций: >= 0 !!!

                      //приоритет любой одноарг. операции выше любой многоарг. операции !!!




type TAlgObject = array of
                   record
                    Name: String;
                   TypeF: Cardinal;          //тип переменной
                    Addr: Cardinal;
                   end;

type TAlgLoadFunction = array of
                        record
                         TypeF: Cardinal;    //тип переменной для загрузки
                          Addr: Cardinal;
                         end;


// Bri = 1  если ф-ия установлена и NFi - номер массива
type
TAlgBracket = record
               Br1: Integer;    // (,) не исп-ся !!!
               NF1: Cardinal;
               Br2: Integer;    // [,]
               NF2: Cardinal;
               Br3: Integer;    // {,}
               NF3: Cardinal;
               Br4: Integer;    // <,>
               NF4: Cardinal;
              end;

type
 PFunc      = ^TFunc;



 
 TFunc = record
               NL: Cardinal;               //порядковый номер комманды на уровне
               S:  Cardinal;               //Stack
               N:  Cardinal;               //Node
           TypeF:  Cardinal;               //возвращаемый тип
             COP:  Cardinal;
           NFunc:  Cardinal;               //номер массива ф-ий
              NF:  Cardinal;               //номер ф-ии в массиве
            NObj:  Cardinal;               //номер массива переменных
              FD:    Double;               //константа
             Arg:  Cardinal;               //числу переменных (для infinite)
             IdN:    Cardinal;
             IdL:    Cardinal;

         end;


type
TArrayOfPFunc = array of PFunc;

type
TFunction = record
                 Interp: TArrayOfPFunc;
                   Comp: TCode;
                  ICode: TAddress;
                  end;

type PFunction = ^TFunction;

type TNStack = record
                S: Cardinal; //текущий номер стека
                N: Cardinal; //число вытекающих узлов
              end;


type
PNode = ^TNode;
TNode = record
         Stack: TNStack;
         IdN:    Cardinal;
         IdL:    Cardinal;
         NL:     Cardinal;           //порядковый номер комманды (составляющая уровня);
         NCOP:   Cardinal;           //операция (номер массива) (составляющая узла);
         NFunc:  Cardinal;           //ф-ия (номер массива ф-ий)
         NObj:   Cardinal;           //номер массива переменной
         COP:    Integer;            //COP: = 1(ф-ия) в Func номер массива ф-ий;
                                     //2(операция) в NCOP номер массива;
                                     //3(загрузка переменной) в NObj - номер массива;
                                     //4(загрузка константы) в FD - константа;
         FD:     Double;             //константа
         Expression: String;
         Ch: PNode;
         Nb: PNode;
         Pr: PNode;
       end;

type
TDataNode = record
             N:      Cardinal;
             IdN:    Cardinal;
             NCOP:   Cardinal;
             NFunc:  Cardinal;
             NObj:   Cardinal;
             COP:    Integer;
             FD:     Double;
             FX:     Extended;
             Expression: String;
            end;

type
TLevel = record
          NL:  Cardinal;               //порядковый номер комманды (составляющая уровня);
          IdL: Cardinal;
          Expression: String;
        end;

type PLevel = array of TLevel;




type
TArrayS = array of String;





type
TParamList = record
               Name: String;
               Value: TFloatType;
             end;






{type
TArrayI = array of Integer;
}

type
TString1 = String[1];





type
TAlgebra = record
             Name:  String;
            Types:  TArrayC;
              Obj:  TAlgObject;
              Opr:  TAlgOperation;
           ExFunc:  TAlgFunction;
           LdFunc:  TAlgLoadFunction;
          Bracket:  TAlgBracket;
           end;


type TExternalException = procedure (TypeError: Integer); {of object;} stdcall;


type

  TForevalH = class



  private


    Alg: TAlgebra;
    CurrentExpression: String;      //текущее выражение
    LFunc    : Cardinal;          //длина скомпилированного выражения
    StackSize: Cardinal;          //размер стека
    ArgM : TArrayS;              //список аргументов в случае > 2 арг.(отсчёт с '1')
    Func: TFunction;                     //исполняемый код скомпилированного выражения
    Tree: PNode;                                //дерево разбора выражения
    //F_SyntaxExtension:       Boolean; //вкл./выкл.: имена ф-ий > 1; '{' ; '['; '!'; '^'; .
    BeginTree: PNode;                 //указатель начала дерева (не обязательно)
    F_VarShift:              Boolean;  //распознавание var&param в верхнем/нижнем/обоих регистрах.
    F_FuncShift:             Boolean;
    F_SyntaxErrorCode: Cardinal;    //код ошибки при разборе
    F_SyntaxErrorString: String;   //строка ошибки
    F_CalcErrorCode: Integer;    //вычислит. ошибка
    F_InternalError: Integer;
    F_ShowException: Boolean;      //вкл./выкл. показ исключений
    F_ExternalException: Boolean;  //вкл./выкл. внешнего обработчика исключений
    //BeginLinker: Integer; //0,1 - начало/конец трансляции - исп-ся при обработке ошибок
    F_BeginCalc: Integer; //0,1 - начало/конец трансляции - исп-ся при обработке ошибок



    //Alg:
    F_NumberStack: Cardinal;
    F_Address: Cardinal;
    F_NumberArg: Cardinal;
    F_FConst: TFloatType;
    ICOMP: TCode;
    F_SyntaxErrorString1: String;
    F_IdN: Cardinal;
    F_ResultType: Cardinal;
    F_ExtNumberArg: Cardinal;


    function  FindNumberPR(PR: Cardinal): Cardinal;
    function  FindOperation(S: String): Cardinal;
    procedure FindSingleOP(S: String; var NCop: Integer);
    procedure FindCallFunction(var nf: Integer);
    procedure FindLdFunction(var nf: Integer);
    procedure FindConstLdFunction(var nf: Integer);
    procedure FindNumberLevel(var ANL: TArrayC);
    procedure InsertBracketOperation(S: String; var S1: String);
    procedure IntToHex(N: TAddress; var AH: TArray4);
    procedure AddAddress(Adr: TAddress);
    procedure AddCommand(I: Integer);
    procedure AddByte(B: Byte);
    procedure AddWord(B1: Byte; B2: Byte);
    procedure Compile;
    procedure CALLA;
    procedure CALLB;
    procedure RET;
    procedure FSTP(N: TAddress);
    procedure FLD(N: TAddress);
    procedure MOVAM(N: TAddress);
    procedure MOVMA(N: TAddress);
    procedure MOVA1(N: TAddress);
    procedure PUSHA;
    procedure POPA;


    procedure FindExternalBracket(S: String; var SS: String);
    procedure FindMainOperation(S:String; var NCOP: Integer; var NPos: Cardinal);
    procedure StringAnalizator(S:String; var ND: TDataNode; var HS:PLevel);
    procedure WriteCode;
    procedure WriteLevelParam(H: PNode; HS: PLevel; N: Cardinal);
    procedure SubstParam(S1: String;  var C: TFloatType; var SB: Integer);
    function  PointToDec(S: String):String;
    procedure CreateInitData;
    procedure FindVar(S1: String; var ni: Integer);
    procedure SyntaxAnalizator(S:String; var ND: TDataNode; var LV:PLevel;  var EOFN: Boolean);
    procedure NumberAnalizator(S: String; var ND: TDataNode;  var EOFN: Boolean);
    procedure WriteNodeParam(ND: TDataNode);
    procedure InitNode(var ND: TDataNode);
    procedure WriteDataCode;
    procedure FindFunction(S: String;  var ND: TDataNode; var LV: PLevel;  var BH: Boolean);
    procedure XchangeAddingBracket(S: String; var S1: String);
    procedure PrevTreat(S: String; var S1: String);
    //procedure SetExpression(S: String);
    procedure FreeTree;
    procedure FreeFunction;
    procedure Linker(S:String);
    procedure SetStackSize;
    procedure CodeGeneration;
    //function  Calculation: TFloatType;
    procedure FindManyArg(S: String; var ArgM: TArrayS);
    function  Calc: TFloatType;


  protected
   //ExtException: TExternalException; //внешний обработчик исключений
   procedure  CalcException(Sender: TObject; E: Exception);  virtual;


  public

   //procedure InsertBracketOperation(S: String; var S1: String);
   constructor Create;
   destructor  Destroy;
   //function  ReadErrorCode: Integer;
   //function  CalculateExpression(S: String): TFloatType;
   procedure SetExtExpression(S: String;  var E_Func: TFunction; var Stack: Cardinal);
   procedure CalcExtFunc(E_Func: TFunction);
   function  CalcExtFuncA(Addr: TAddress): TFloatType;
   procedure FreeExtFunc(E_Func: TFunction);
   property  VarShift: Boolean read F_VarShift write F_VarShift default False;
   property  FuncShift: Boolean read F_FuncShift write F_FuncShift default False;
   property  ShowException: Boolean read F_ShowException write F_ShowException default True;
   property  SyntaxError: Cardinal read  F_SyntaxErrorCode write F_SyntaxErrorCode default 0;
   property  SyntaxErrorString: String read F_SyntaxErrorString write F_SyntaxErrorString;
   property  CalcError: Integer read F_CalcErrorCode write F_CalcErrorCode default 0;
   property  InternalError: Integer read F_InternalError write F_InternalError default 0;
   property  ExternalException: Boolean read F_ExternalException write F_ExternalException default False;
   //property  SetExternalException: TExternalException write ExtException;
   property  BeginCalc: Integer read F_BeginCalc write F_BeginCalc default 0;



   //Algebra:
   property  GetStack: Cardinal read F_NumberStack;
   property  GetAddress: Cardinal read F_Address;
   property  ResultType: Cardinal read F_ResultType;
   property  GetNumberArg: Cardinal read F_NumberArg;   //для Infinite ф-ий: число аргументов
   property  ExtNumberArg: Cardinal read F_ExtNumberArg write F_ExtNumberArg; //для Infinite ф-ий:
                                                        //min число аргументов для вызова ф-ии
   procedure SetType(IdType: Cardinal);
   procedure SetObject(Name: String; Addr: Cardinal; IdType: Cardinal);
   procedure SetFunction(Name: String; Addr: Cardinal; TF: TArrayC; IdType: Cardinal);
   procedure SetFunctionEx(Name: String; Addr: Cardinal; TypeF: Cardinal; IdType: Cardinal);
   procedure SetLoadFunction(IdType: Cardinal; Addr: Cardinal);
   procedure SetOperation(Name: String; Func: String; PR: Cardinal; GS: Integer);
   procedure SetBracketOperation(Br: Integer; Name: String);




  published



  end;



var
  ak,bk: array[1..7] of TFloatType;
  C_2dqrPi: extended;


  ForevalH: TForevalH;



implementation
{$IFDEF TEXTOUT}
uses
TestG8;
{$ENDIF}







procedure TForevalH.SetType(IdType: Cardinal);
label endp;
var
i: Integer;
begin
{
for i:=0 to High(Alg.Types) do
begin
 if Alg.Types[i] = IdType then goto endp;
end;
}
SetLength(Alg.Types,Length(Alg.Types)+1);
Alg.Types[High(Alg.Types)]:=IdType;

endp:
end;



procedure TForevalH.SetObject(Name: String; Addr: Cardinal; IdType: Cardinal);
label endp;
var
i: Integer;
S: String;
begin
{
S:=Copy(Name,1,Length(Name));
for i:=0 to High(Alg.Obj) do
begin
 if Alg.Obj[i].TypeF = IdType then
 begin
  if F_VarShift = False then S:=LowerCase(S));
  if S = Alg.Obj[i].Name then goto endp;
 end;
end;
}
SetLength(Alg.Obj,Length(Alg.Obj)+1);
Alg.Obj[High(Alg.Obj)].TypeF:=IdType;
Alg.Obj[High(Alg.Obj)].Addr:=Addr;
Alg.Obj[High(Alg.Obj)].Name:=Copy(Name,1,Length(Name));

endp:
end;





procedure TForevalH.SetFunction(Name: String; Addr: Cardinal; TF: TArrayC; IdType: Cardinal);
label endp;
var
N,K,i,j: Integer;
begin
  for i:=0 to High(Alg.ExFunc) do
  begin
   if Name = Alg.ExFunc[i].Name then
   begin
    K:=i;
    N:=High(Alg.ExFunc[K].Func);
    SetLength(Alg.ExFunc[K].Func,Length(Alg.ExFunc[K].Func)+1);
    N:=N+1;
    Alg.ExFunc[K].Func[N].TypeF:=IdType;
    Alg.ExFunc[K].Func[N].Addr:=Addr;
    Alg.ExFunc[K].Func[N].N:=Length(TF);
    SetLength(Alg.ExFunc[K].Func[N].TV,Length(TF));
    for j:=0 to High(TF) do
    begin
     Alg.ExFunc[K].Func[N].TV[j]:=TF[j];
    end;

    goto endp;
   end;
  end;

  SetLength(Alg.ExFunc,Length(Alg.ExFunc)+1);
  Alg.ExFunc[High(Alg.ExFunc)].Name:=Copy(Name,1,Length(Name));

  K:=High(Alg.ExFunc);
  N:=High(Alg.ExFunc[K].Func);
  SetLength(Alg.ExFunc[K].Func,Length(Alg.ExFunc[K].Func)+1);
  N:=N+1;
  Alg.ExFunc[K].Func[N].TypeF:=IdType;
  Alg.ExFunc[K].Func[N].Addr:=Addr;
  Alg.ExFunc[K].Func[N].N:=Length(TF);
  SetLength(Alg.ExFunc[K].Func[N].TV,Length(TF));
  for j:=0 to High(TF) do
  begin
   Alg.ExFunc[K].Func[N].TV[j]:=TF[j];
  end;

endp:
end;



procedure TForevalH.SetFunctionEx(Name: String; Addr: Cardinal; TypeF: Cardinal; IdType: Cardinal);
label endp;
var
N,K,i,j: Integer;
begin
  for i:=0 to High(Alg.ExFunc) do
  begin
   if Name = Alg.ExFunc[i].Name then
   begin
    K:=i;
    N:=High(Alg.ExFunc[K].Func);
    SetLength(Alg.ExFunc[K].Func,Length(Alg.ExFunc[K].Func)+1);
    N:=N+1;
    Alg.ExFunc[K].Func[N].TypeF:=IdType;
    Alg.ExFunc[K].Func[N].Addr:=Addr;
    Alg.ExFunc[K].Func[N].N:=-1;
    SetLength(Alg.ExFunc[K].Func[N].TV,1);
    Alg.ExFunc[K].Func[N].TV[0]:=TypeF;
    goto endp;
   end;
  end;

  SetLength(Alg.ExFunc,Length(Alg.ExFunc)+1);
  Alg.ExFunc[High(Alg.ExFunc)].Name:=Copy(Name,1,Length(Name));

  K:=High(Alg.ExFunc);
  N:=High(Alg.ExFunc[K].Func);
  SetLength(Alg.ExFunc[K].Func,Length(Alg.ExFunc[K].Func)+1);
  N:=N+1;
  Alg.ExFunc[K].Func[N].TypeF:=IdType;
  Alg.ExFunc[K].Func[N].Addr:=Addr;
  Alg.ExFunc[K].Func[N].N:=-1;
  SetLength(Alg.ExFunc[K].Func[N].TV,1);
  Alg.ExFunc[K].Func[N].TV[0]:=TypeF;

endp:
end;




procedure TForevalH.SetLoadFunction(IdType: Cardinal; Addr: Cardinal);
begin
 SetLength(Alg.LdFunc,Length(Alg.LdFunc)+1);
 Alg.LdFunc[High(Alg.LdFunc)].TypeF:=IdType;
 Alg.LdFunc[High(Alg.LdFunc)].Addr:=Addr;
end;



procedure TForevalH.SetOperation(Name: String; Func: String; PR: Cardinal; GS: Integer);
label 1;
var
i,nf: Integer;                             //Операции взывают только 1,2 - аргументные ф-ии
begin
nf:=-1;
for i:=0 to High(Alg.ExFunc) do
begin
 if Func = Alg.ExFunc[i].Name then
 begin
  nf:=i; goto 1;
 end;
end;

1:
if nf = -1 then begin {Error} end;
if PR <= 0 then begin {Error} end;

SetLength(Alg.Opr,Length(Alg.Opr)+1);
Alg.Opr[High(Alg.Opr)].Name:=Name[1];
Alg.Opr[High(Alg.Opr)].NFunc:=nf;
Alg.Opr[High(Alg.Opr)].PR:=PR;
Alg.Opr[High(Alg.Opr)].GS:=GS;

end;



procedure TForevalH.SetBracketOperation(Br: Integer; Name: String);
label 1;
var
i,nf: Integer;
begin                                        //Br = 1 (); не исп-ся !!!
                                             //Br = 2 []; 3 {}; 4 <>;
nf:=-1;
for i:=0 to High(Alg.ExFunc) do
begin
 if Name = Alg.ExFunc[i].Name then
 begin
  nf:=i; goto 1;
 end;
end;

1:
if (nf = -1) or (Br < 2) or (Br > 4) then begin {Error} end;


{if Br = 1 then
begin
 Alg.Bracket.Br1:=1;
 Alg.Bracket.NF1:=nf;
end
else}
if Br = 2 then
begin
 Alg.Bracket.Br2:=1;
 Alg.Bracket.NF2:=nf;
end
else
if Br = 3 then
begin
 Alg.Bracket.Br3:=1;
 Alg.Bracket.NF3:=nf;
end
else
if Br = 4 then
begin
 Alg.Bracket.Br4:=1;
 Alg.Bracket.NF4:=nf;
end;


end;



procedure TForevalH.SetStackSize;
label endp;
begin
if F_SyntaxErrorCode <> 0 then goto endp;
Tree:=BeginTree;   //не обязательно, т.к. чтение дерева - циклически

while Tree^.Ch <> nil do
begin
Tree:=Tree^.Ch;
end;
StackSize:=Tree^.Stack.S;

while Tree^.Pr <> nil do
begin
 while Tree^.Nb <> nil  do
 begin
 Tree:=Tree^.Nb;
  while Tree^.Ch <> nil do
  begin
  Tree:=Tree^.Ch;
  end;
if Tree^.Stack.S > StackSize then StackSize:=Tree^.Stack.S;
 end;
 Tree:=Tree^.Pr;
if Tree^.Stack.S > StackSize then StackSize:=Tree^.Stack.S;
end;


endp:
end;



procedure TForevalH.Linker(S: String);
label endp;
var
HS: PLevel;
ND: TDataNode;
H,H1: PNode;
EOFN: Boolean;
i: Cardinal;
begin
if F_SyntaxErrorCode <> 0 then goto endp;
New(Tree);
Tree^.Ch:=nil;
Tree^.Nb:=nil;
Tree^.Pr:=nil;
BeginTree:=Tree;
//вершина дерева:
Tree^.Expression:=Copy(S,1,Length(S));
Tree^.Stack.S:=1;
EOFN:=True;

SyntaxAnalizator(Copy(Tree^.Expression,1,Length(Tree^.Expression)),ND,HS,EOFN);
//спуск:
//COP<>NOP:
while EOFN <> True do
begin
if F_SyntaxErrorCode <> 0 then goto endp;

New(H);
Tree^.Ch:=H;

WriteNodeParam(ND);
WriteLevelParam(H,HS,0);


H^.Stack.S:=Tree^.Stack.S;
H^.Pr:=Tree;
H1:=H;
H^.Ch:=nil;
H^.Nb:=nil;

for i:=1 to High(HS) do
begin
 New(H);
 H^.Ch:=nil;
 H^.Nb:=nil;
 WriteLevelParam(H,HS,i);
 H^.Stack.S:=H1^.Stack.S+1;
 H1.Nb:=H;
 H^.Pr:=Tree;
 //HS:=HS^.Next;
 H1:=H;
end;
Tree:=H^.Pr^.Ch;
HS:=nil; //??? (освобождение массива уровня)
SyntaxAnalizator(Copy(Tree^.Expression,1,Length(Tree^.Expression)),ND,HS,EOFN);
end;
//EOFN=True: последняя команда узла (нижний левый)
WriteNodeParam(ND);

//подъём:
while Tree^.Pr <> nil do
begin
 while Tree^.Nb <> nil  do
 begin
 Tree:=Tree^.Nb;
 SyntaxAnalizator(Copy(Tree^.Expression,1,Length(Tree^.Expression)),ND,HS,EOFN);
//COP<>NOP:
while EOFN<>True do
 begin
 if F_SyntaxErrorCode <> 0 then goto endp;

 New(H);
 Tree^.Ch:=H;
 WriteNodeParam(ND);
 WriteLevelParam(H,HS,0);

 H^.Stack.S:=Tree^.Stack.S;
 H^.Pr:=Tree;
 H1:=H;
 H^.Ch:=nil;
 H^.Nb:=nil;
 for i:=1 to High(HS) do
 begin
  New(H);
  H^.Ch:=nil;
  H^.Nb:=nil;
  WriteLevelParam(H,HS,i);

  H^.Stack.S:=H1^.Stack.S+1;
  H1.Nb:=H;
  H^.Pr:=Tree;
  H1:=H;
 end;
 Tree:=H^.Pr^.Ch;
 HS:=nil; //??? (освобождение массива уровня)
 SyntaxAnalizator(Copy(Tree^.Expression,1,Length(Tree^.Expression)),ND,HS,EOFN);
 end;
//EOFN=True:последняя команда узла
WriteNodeParam(ND);
end;
Tree:=Tree^.Pr;
end;

Tree:=BeginTree;

endp:
end;



procedure TForevalH.FreeFunction;
var
i: Integer;
begin

if F_SyntaxErrorCode = 0 then
for i:=1 to Length(Func.Interp)-1 do
begin
dispose(Func.Interp[i]);
end;
Func.Comp:=nil;
Func.Interp:=nil;

end;



procedure TForevalH.WriteNodeParam(ND: TDataNode);
begin
Tree^.Stack.N:=ND.N;
Tree^.NCOP:=ND.NCOP;
Tree^.FD:=ND.FD;
Tree^.NFunc:=ND.NFunc;
Tree^.COP:=ND.COP;
Tree^.NObj:=ND.NObj;
Tree^.IdN:=ND.IdN;
end;



procedure TForevalH.WriteLevelParam(H: PNode; HS: PLevel; N: Cardinal);
begin
H^.Expression:=Copy(HS[N].Expression,1,Length(HS[N].Expression));
H^.NL:=HS[N].NL;
H^.IdL:=HS[N].IdL;
end;



procedure TForevalH.FindExternalBracket(S: String; var SS: String);
label 1,endp;
var
b,i,z,a:Integer;
begin
SS:=Copy(S,1,Length(S));



1:
if SS = '' then
begin
goto endp;
end;

if (SS[1] = '(') and (SS[Length(SS)] = ')') then
begin
  b:=-1;
  for i:=2 to Length(SS)-1 do
  begin
   if SS[i] = '(' then b:=b-1;
   if SS[i] = ')' then b:=b+1;
   if b = 0 then goto endp;
  end;

 Delete(SS,Length(SS),1);
 Delete(SS,1,1);
 goto 1;
end;




endp:
end;





function TForevalH.FindNumberPR(PR: Cardinal): Cardinal;
label 1;
var
i: Integer;
N: Cardinal;
begin
for i:=0 to High(Alg.Opr) do
begin
 if PR = Alg.Opr[i].PR then
 begin
  N:=i; goto 1;
 end;
end;

1:
FindNumberPR:=N;
end;



function TForevalH.FindOperation(S: String): Cardinal;
label 1;
var
i,NCOP: Integer;
begin
NCOP:=-1;
for i:=0 to High(Alg.Opr) do
begin
    if S = Alg.Opr[i].Name then
    begin
     NCOP:=i;
     goto 1;
    end;
end;

1:
FindOperation:=NCOP;
end;




procedure TForevalH.FindSingleOP(S: String; var NCop: Integer);
var
i,j,PR1,PR2: Integer;
NCop1,NCop2: Integer;
begin
PR1:=0;
PR2:=0;
NCop1:=-1; NCop2:=-1;  NCop:=-1;

for i:=0 to High(Alg.Opr) do
begin
 if Alg.Opr[i].GS < 0 then    //только одноарг. операции
 begin
    if (S[1] = Alg.Opr[i].Name[1]) and (Alg.Opr[i].GS = -1) then
    begin
     NCop1:=i;
    end;

    if (S[Length(S)] = Alg.Opr[i].Name[1]) and  (Alg.Opr[i].GS = -2) then
    begin
     NCop2:=i;
    end;
  end;  
end;


if (NCop1 <> -1) and (NCop2 <> -1) then
begin
 if  Alg.Opr[NCop1].PR < Alg.Opr[NCop2].PR then NCop:=NCop1 else NCop:=NCop2;
end
else
if NCop1 <> -1 then NCop:=NCop1
else
if NCop2 <> -1 then NCop:=NCop2;

end;




procedure TForevalH.FindMainOperation(S:String; var NCOP: Integer; var NPos: Cardinal);
label endp;
var
Pl,Ml: Boolean;
i,b: Integer;
NCOP1,NCOP2,NPos1: Integer;
begin
if S = '' then
begin
F_SyntaxErrorCode:=5;
goto endp;
end;

NCOP1:=-1; NCOP2:=-1;  NCOP:=-1;
b:=0; Pl:=False; Ml:=False;

if S[1] = '(' then b:=-1
 else
  if S[1] = ')' then
   begin
   F_SyntaxErrorCode:=2;
   goto endp;
   end;


for i:=2 to Length(S)-1 {т.к. 1-ый и последний символы м.б. одноарг. символами}  do
begin
 if S[i] = '(' then b:=b-1;
 if S[i] = ')' then b:=b+1;

 if b = 0 then
 begin
  NCOP2:=FindOperation(S[i]);
  if Alg.Opr[NCOP2].GS >= 0 then //только многоарг. операции
  begin
   if (NCOP2 <> -1) and (NCOP1 <> -1) then
   begin
    {обязательно <=, чтобы взять последнее слагаемое !!!}
    if (Alg.Opr[NCOP2].PR <= Alg.Opr[NCOP1].PR)  then
    begin
     NCOP1:=NCOP2;
     NPos1:=i;
    end;
   end
   else
   if (NCOP2 <> -1) and (NCOP1 = -1) then
   begin
    NCOP1:=NCOP2;
    NPos1:=i;
   end;
  end;
 end;

NPos:=NPos1;
NCOP:=NCOP1;
end;


//коррекция выражений на одноарг. оп. типа -x^y,   (neg)
//FindSingleOP(S,NCop,NPos1);
NCop1:=FindOperation(S[1]);
if (NCOP1 <> -1) and (Alg.Opr[NCOP1].PR < Alg.Opr[NCOP].PR)  then NCOP:=-1;

endp:
end;



procedure TForevalH.StringAnalizator(S:String; var ND: TDataNode; var HS:PLevel);
label endp;
var
SS,S1: String;
PR,NPR: Cardinal;
BH,IH,IH1: PLevel;
i,p,b: Cardinal;
PR1,N,NCop: Integer;
ni: Integer;
NPos: Cardinal;
begin
if F_SyntaxErrorCode <> 0 then goto endp;

FindExternalBracket(S,SS);

InitNode(ND);
PR:=0;
FindMainOperation(SS,NCop,NPos);
N:=0;
if NCop <> -1 then
begin
 inc(F_IdN);
 ND.IdN:=F_IdN;
 SetLength(HS,2);
 HS[0].Expression:=Copy(SS,1,NPos-1);
 HS[0].NL:=1;
 HS[0].IdL:=F_IdN;
 HS[1].Expression:=Copy(SS,NPos+1,Length(SS)-NPos+1);
 HS[1].NL:=2;
 HS[1].IdL:=F_IdN;
 ND.N:=2;
 ND.COP:=_COP;
 ND.NFunc:=Alg.Opr[NCop].NFunc;
 ND.NCOP:=NCOP;  //для ошибок
end
else
begin
 FindSingleOp(SS,NCop);
 if NCop <> -1 then
 begin
  ND.COP:=_FUNC;
  ND.N:=1;
  ND.NFunc:=Alg.Opr[NCop].NFunc;
  SetLength(HS,1);
  if Alg.Opr[NCop].GS = -1 then HS[0].Expression:=Copy(SS,2,Length(SS)-1)
  else
  if Alg.Opr[NCop].GS = -2 then HS[0].Expression:=Copy(SS,1,Length(SS)-1);
  HS[0].NL:=1;
  ND.NCOP:=NCOP;  //для ошибок
  inc(F_IdN);
  ND.IdN:=F_IdN;
  HS[0].IdL:=F_IdN;
 end
 else
 begin
  ND.COP:=0;
  SetLength(HS,1);
  ND.N:=1;
  HS[0].NL:=1;
  HS[0].Expression:=Copy(SS,1,Length(SS));
 end;
end;


endp:
end;




procedure TForevalH.SubstParam(S1: String;  var C: TFloatType; var SB: Integer);
label endp;
var
N,i: Cardinal;
S1h,S3: String;
begin
if F_SyntaxErrorCode <> 0 then goto endp;
C:=0;
if S1 = '' then
begin
F_SyntaxErrorCode:=5;
goto endp;
end;

N:=1; S1h:=Copy(S1,1,Length(S1));  SB:=0;


try
C:=StrToFloat(PointToDec(S1h));
SB:=1;
except
SB:=0;
end;

endp:
end;




procedure TForevalH.NumberAnalizator(S: String;  var ND: TDataNode; var EOFN: Boolean);
label 1;
var
S2: String;
ni,SB: Integer;
C: TFloatType;
begin
EOFN:=False;
InitNode(ND);
FindVar(S,ni);
if ni >= 0 then
 begin
  ND.COP:=_LDSF;
  ND.NObj:=ni;
  EOFN:=True;
  goto 1;
 end;


SubstParam(S,C,SB);
if SB = 1 then
begin
ND.FD:=C;
ND.COP:=_LDSC;
EOFN:=True;
inc(F_IdN);
ND.IdN:=F_IdN;
goto 1;
end;

F_SyntaxErrorCode:=1;         //неизвестный символ
F_SyntaxErrorString:=Copy(S,1,Length(S));
EOFN:=False;

1:
end;





procedure TForevalH.FindVar(S1: String; var ni: Integer);
label endp;
var
i: Cardinal;
S2,S3: String;
begin                                          //ni - номер массива найденной переменной
if F_SyntaxErrorCode <> 0 then goto endp;      //ni = -1: перем. не найдена
ni:=-1;

S2:=Copy(S1,1,Length(S1));
if F_VarShift = False then S2:=LowerCase(S2);

for i:=0 to High(Alg.Obj) do
begin
S3:=Alg.Obj[i].Name;
if F_VarShift = False then S3:=LowerCase(S3);
 if S2 = S3 then
  begin
   ni:=i;
   goto endp;
  end;
end;



endp:
end;




procedure TForevalH.FindFunction(S: String;  var ND: TDataNode; var LV: PLevel;  var BH: Boolean);
label 1,2,3,4,endp;
var
i,k,l,bb,pf,pr,b1,b2,nf: Integer;
S1,Sa,Sf,Sf1,Sfn: String;
Neg: Integer;
begin
if F_SyntaxErrorCode <> 0 then goto endp;
BH:=False;



//поск функции:
nf:=0; bb:=0;  pf:=0; b1:=0;
for i:=1 to Length(S) do
begin
 if S[i] = '(' then begin b1:=i; goto 1; end;
end;
if b1 = 0 then goto endp;

1:
b2:=0; bb:=-1;
for i:=b1+1 to Length(S) do
begin
 if S[i] = '(' then bb:=bb-1;
 if S[i] = ')' then bb:=bb+1;
 if (i <> Length(S)) and (bb = 0) then begin {Internal Error} end;
end;


Sf:=Copy(S,1,b1-1);
Sa:=Copy(S,b1+1,Length(S)-b1-1);


if F_FuncShift = False then Sf1:=LowerCase(Sf) else Sf1:=Sf;

nf:=-1;
for i:=0 to High(Alg.ExFunc) do
begin
  Sfn:=Alg.ExFunc[i].Name;
  if F_FuncShift = False then
  begin
   Sfn:=LowerCase(Sfn);
  end;
  if Sf1 = Sfn then  begin nf:=i;  goto 4; end;
end;


F_SyntaxErrorCode:=6; //UknownFunction
F_SyntaxErrorString:=Copy(Sf,1,Length(Sf));
goto endp;


4:
 if nf <> -1 then
 begin
    FindManyArg(Sa,ArgM);
    if Length(ArgM) <= 1 then
    begin
     {ф-ия без аргументов}
     F_SyntaxErrorCode:=4;
     F_SyntaxErrorString:=Copy(Sf,1,Length(Sf));
     goto endp;
    end;
    
    inc(F_IdN);
    ND.IdN:=F_IdN;

    LV[0].Expression:=Copy(ArgM[1],1,Length(ArgM[1]));
    LV[0].NL:=1;
    LV[0].IdL:=F_IdN;
    for i:= 2 to High(ArgM) do
    begin
     SetLength(LV,Length(LV)+1);
     LV[i-1].Expression:=Copy(ArgM[i],1,Length(ArgM[i]));
     LV[i-1].NL:=i;
     LV[i-1].IdL:=F_IdN;
    end;

    ND.N:=High(ArgM);
    ND.COP:=_Func;
    ND.NFunc:=nf;
    BH:=True;
 end;


endp:
end;




procedure TForevalH.FindManyArg(S: String; var ArgM: TArrayS);
label endp;
var
i,N,bb: Cardinal;
PP: array of Cardinal;
begin

bb:=0;
N:=1; SetLength(PP,N+1); PP[1]:=0;

for i:=1 to Length(S) do
begin
 if S[i] = '(' then bb:=bb-1;
 if (bb = 0) and (S[i] = ',') then begin inc(N); SetLength(PP,N+1); PP[N]:=i; end;
 if S[i] = ')' then bb:=bb+1;
end;

inc(N);  SetLength(PP,N+1); PP[N]:=Length(S)+1;

SetLength(ArgM,N);

for i:=1 to N-1 do
begin
ArgM[i]:=Copy(S,PP[i]+1,PP[i+1]-PP[i]-1);
if (ArgM[i] = '')  then
begin
F_SyntaxErrorCode:=4; F_SyntaxErrorString:=Copy(S,1,Length(S)); goto endp;
end;
end;

endp:
end;





procedure TForevalH.XchangeAddingBracket(S: String; var S1: String);
var
i: Cardinal;
begin
S1:=Copy(S,1,Length(S));
for i:=1 to Length(S1) do
 begin
  if (S1[i] = '[') or  (S1[i] = '{') or  (S1[i] = '<') then
   begin Delete(S1,i,1); Insert('(',S1,i); end;
  if (S1[i] = ']') or  (S1[i] = '}') or  (S1[i] = '>') then
   begin Delete(S1,i,1); Insert(')',S1,i); end;
 end;
end;



procedure TForevalH.InsertBracketOperation(S: String; var S1: String);
label 1,2,3,4,5,endp;
var
i,b,b1,k,j: Integer;
BH: Boolean;
begin
S1:=Copy(S,1,Length(S));
k:=0;

//круглые скобки для операций не исп-ся !!!
(*
i:=1;
while i <= Length(S1) do
 begin

  if (S1[i] = '(') and (Alg.Bracket.Br1 = 1) then
  begin
   b:=0;
   b1:=-1;
   BH:=False;
   for j:=i+1 to Length(S1) do
   begin
    if (S1[j] = '(') or (S1[j] = '{') or (S1[j] = '[') or (S1[j] = '<') then b:=b-1;
    if (S1[j] = ')') or (S1[j] = '}') or (S1[j] = ']') or (S1[j] = '>')  then b:=b+1;
    if S1[j] = '(' then b1:=b1-1;
    if S1[j] = ')' then b1:=b1+1;
    if (b = 0) and (S1[j] = ',') then BH:=True;
    if b1 = 0 then begin k:=j; goto 1; end;
   end;

   F_SyntaxErrorCode:=2;
   F_SyntaxErrorString:=')';
   goto endp;

   1:
   if BH = True then
   begin
    Delete(S1,k,1);
    Insert(')',S1,k);
    Delete(S1,i,1);
    Insert(Alg.ExFunc[Alg.Bracket.NF1].Name+'(',S1,i);
    i:=i+Length(Alg.ExFunc[Alg.Bracket.NF1].Name)+1;
   end
   else inc(i);
  end
  else inc(i);


end;
*)



5:
for i:=1 to Length(S1) do
 begin
  if (S1[i] = '[') and (Alg.Bracket.Br2 = 1) then
  begin
   b:=0;
   b1:=-1;
   BH:=False;
   for j:=i+1 to Length(S1) do
   begin
    if (S1[j] = '(') or (S1[j] = '{') or (S1[j] = '[') or (S1[j] = '<') then b:=b-1;
    if (S1[j] = ')') or (S1[j] = '}') or (S1[j] = ']') or (S1[j] = '>')  then b:=b+1;
    if S1[j] = '[' then b1:=b1-1;
    if S1[j] = ']' then b1:=b1+1;
    //if (b = 0) and (S1[j] = ',') then BH:=True;   {для любого числа перем.}
    if b1 = 0 then begin k:=j; goto 2; end;
   end;

   F_SyntaxErrorCode:=2;
   F_SyntaxErrorString:=']';
   goto endp;

   2:
   //if BH = True then   {для любого числа перем.}
   begin
    Delete(S1,k,1);
    Insert(')',S1,k);
    Delete(S1,i,1);
    Insert(Alg.ExFunc[Alg.Bracket.NF2].Name+'(',S1,i);
    goto 5;
   end;
  end;


  if (S1[i] = '{') and (Alg.Bracket.Br3 = 1) then
  begin
   b:=0;
   b1:=-1;
   BH:=False;
   for j:=i+1 to Length(S1) do
   begin
    if (S1[j] = '(') or (S1[j] = '{') or (S1[j] = '[') or (S1[j] = '<') then b:=b-1;
    if (S1[j] = ')') or (S1[j] = '}') or (S1[j] = ']') or (S1[j] = '>')  then b:=b+1;
    if S1[j] = '{' then b1:=b1-1;
    if S1[j] = '}' then b1:=b1+1;
    //if (b = 0) and (S1[j] = ',') then BH:=True;
    if b1 = 0 then begin k:=j; goto 3; end;
   end;

   F_SyntaxErrorCode:=2;
   F_SyntaxErrorString:='}';
   goto endp;

   3:
   //if BH = True then
   begin
    Delete(S1,k,1);
    Insert(')',S1,k);
    Delete(S1,i,1);
    Insert(Alg.ExFunc[Alg.Bracket.NF3].Name+'(',S1,i);
    goto 5;
   end;
  end;



  if (S1[i] = '<') and (Alg.Bracket.Br4 = 1) then
  begin
   b:=0;
   b1:=-1;
   BH:=False;
   for j:=i+1 to Length(S1) do
   begin
    if (S1[j] = '(') or (S1[j] = '{') or (S1[j] = '[') or (S1[j] = '<') then b:=b-1;
    if (S1[j] = ')') or (S1[j] = '}') or (S1[j] = ']') or (S1[j] = '>')  then b:=b+1;
    if S1[j] = '<' then b1:=b1-1;
    if S1[j] = '>' then b1:=b1+1;
    //if (b = 0) and (S1[j] = ',') then BH:=True;
    if b1 = 0 then begin k:=j; goto 4; end;
   end;

   F_SyntaxErrorCode:=2;
   F_SyntaxErrorString:='>';
   goto endp;

   4:
   //if BH = True then
   begin
    Delete(S1,k,1);
    Insert(')',S1,k);
    Delete(S1,i,1);
    Insert(Alg.ExFunc[Alg.Bracket.NF4].Name+'(',S1,i);
    goto 5;
   end;
  end;


end;




endp:
end;


procedure TForevalH.PrevTreat(S: String; var S1: String);
label endp;
var
b,i: Integer;
begin
if S = '' then S:='0';
//S:=LowerCase(S);


InsertBracketOperation(S,S);

if F_SyntaxErrorCode <> 0 then goto endp;

//дополнительные скобки могут исп-ся только в операциях !!!
{if F_SyntaxExtension = True then
begin
 XchangeAddingBracket(S,S);
end;
}



F_SyntaxErrorCode:=0;
b:=0;
for i:=1 to Length(S)-1 do
begin
 if S[i] = '(' then b:=b-1;
 if S[i] = ')' then b:=b+1;
end;

if S[Length(S)] = ')' then b:=b+1;
if b <> 0 then
begin            // внутреннее не соответствие откр. и закр. скобок
F_SyntaxErrorCode:=2;
if b > 0 then F_SyntaxErrorString:='('
else
if b < 0 then F_SyntaxErrorString:=')'
end;

//L1.Caption:=S[3];
S1:=Copy(S,1,Length(S));
endp:
end;








procedure TForevalH.SyntaxAnalizator(S:String; var ND: TDataNode; var LV:PLevel;  var EOFN: Boolean);
label endp;
var
COP,Arg1,Arg2: String;
nf: Cardinal;
BH: Boolean;
a,b: TFloatType;
begin
if F_SyntaxErrorCode <> 0 then goto endp;

EOFN:=False;
InitNode(ND);


StringAnalizator(Copy(S,1,Length(S)),ND,LV);
If ND.COP = 0 then
 begin
  FindFunction(LV[0].Expression,ND,LV,BH);
  if BH = True then
  begin
   EOFN:=False;
  end
  else
  NumberAnalizator(LV[0].Expression,ND,EOFN);
 end;


endp:
end;



procedure TForevalH.CodeGeneration;
label endp;
var
E: Exception;
begin
if F_SyntaxErrorCode <> 0 then goto endp;

LFunc:=1;
SetLength(Func.Interp,LFunc);
new(Func.Interp[0]);
Tree:=BeginTree; //не обязательно, т.к. чтение дерева - циклически

while Tree^.Ch <> nil do
begin
Tree:=Tree^.Ch;
end;
//COP=NOP:
WriteCode;

while Tree^.Pr <> nil do
begin
 while Tree^.Nb <> nil  do
 begin
 Tree:=Tree^.Nb;
  while Tree^.Ch <> nil do
  begin
  Tree:=Tree^.Ch;
  end;
//COP=NOP:
WriteCode;
end;

//COP<>NOP:
Tree:=Tree^.Pr;
WriteCode;
end;
//1-ый элемент в WriteCode выпадает

endp:

if F_SyntaxErrorCode <> 0 then
 begin
  CalcException(ForevalH as TObject,E);
 end
end;




function TForevalH.Calc: TFloatType; assembler;
asm
 call [eax+Func.ICode];
end;


procedure TForevalH.WriteCode;
label endp;
var
i: Cardinal;
begin
SetLength(Func.Interp,LFunc+1);
new(Func.Interp[LFunc]);
WriteDataCode;


endp:
{---------}
//out:
{$IFDEF TEXTOUT}
if TestG8.Form1.CB_Cod.Checked = True then
begin
if Tree^.COP = _LDSC then
begin
 TestG8.Form1.M2.Lines[LFunc-1]:='LDSC:  '+String(StrUpper(PChar(FloatToStr(Tree^.FD))));
end
else
if Tree^.COP = _LDSF then
begin
 TestG8.Form1.M2.Lines[LFunc-1]:='LDSF:  '+String(StrUpper(PChar(Alg.Obj[Tree^.NObj].Name)));
end
else
if (Tree^.COP = _Func) or (Tree^.COP = _COP) then
begin
 TestG8.Form1.M2.Lines[LFunc-1]:=String(StrUpper(PChar(Alg.ExFunc[Tree^.NFunc].Name)));
end;




end;
{$ENDIF}
{---------}
inc(LFunc);

end;



procedure TForevalH.WriteDataCode;
label endp;
var
fa,i,L,j: Cardinal;
S: String;
nf: Integer;
ANL: TArrayC;
begin
if F_SyntaxErrorCode <> 0 then goto endp;
if Tree^.COP = _LDSC then
begin
 FindConstLdFunction(nf);
 if nf = -1 then
 begin {Error: нет ф-ии загрузки типа}
  F_SyntaxErrorCode:=7;
  F_SyntaxErrorString:='1';
 end;
 Func.Interp[LFunc]^.FD:=Tree^.FD;
 Func.Interp[LFunc]^.NF:=NF;
 Func.Interp[LFunc]^.COP:=_LDSC;
 Func.Interp[LFunc]^.TypeF:=1;
end
else
if Tree^.COP = _LDSF then
begin
 FindLdFunction(nf);
 if nf = -1 then
 begin {Error: нет ф-ии загрузки типа}
  F_SyntaxErrorCode:=7;
  F_SyntaxErrorString:=IntToStr(Alg.Obj[Tree^.NObj].TypeF);
 end;
 Func.Interp[LFunc]^.NObj:=Tree^.NObj;
 Func.Interp[LFunc]^.NF:=nf;
 Func.Interp[LFunc]^.TypeF:=Alg.Obj[Tree^.NObj].TypeF;
 Func.Interp[LFunc]^.COP:=_LDSF;
end
else
if (Tree^.COP = _FUNC) or (Tree^.COP = _COP) then
begin
 FindCallFunction(nf);
 if nf = -1 then
 begin {Error: нет ф-ии}
  //для операций
  if Tree^.COP = _COP then
  begin
   F_SyntaxErrorCode:=8;
   F_SyntaxErrorString1:=Alg.Opr[Tree^.NCOP].Name;
  end
  else
  //для ф-ий
  begin
   F_SyntaxErrorCode:=9;
   F_SyntaxErrorString1:=Alg.ExFunc[Tree^.NFunc].Name;
  end;

  F_SyntaxErrorString:='';
  FindNumberLevel(ANL);
  for j:=0 to Tree^.Stack.N-1 do
  begin
   if j > 0 then  F_SyntaxErrorString:=F_SyntaxErrorString+',';
   F_SyntaxErrorString:=F_SyntaxErrorString+IntToStr(Func.Interp[ANL[j]].TypeF);
  end;

 end;

 Func.Interp[LFunc]^.COP:=_FUNC;
 Func.Interp[LFunc]^.NFunc:=Tree^.NFunc;
 Func.Interp[LFunc]^.Arg:=Tree^.Stack.N;
 Func.Interp[LFunc]^.NF:=nf;
 Func.Interp[LFunc]^.TypeF:=Alg.ExFunc[Tree^.NFunc].Func[nf].TypeF;
end;



Func.Interp[LFunc]^.S:=Tree^.Stack.S-1;  //начинается с '0'
Func.Interp[LFunc]^.N:=Tree^.Stack.N;
Func.Interp[LFunc]^.NL:=Tree^.NL;
Func.Interp[LFunc]^.IdN:=Tree^.IdN;
Func.Interp[LFunc]^.IdL:=Tree^.IdL;

endp:
end;



procedure TForevalH.FindCallFunction(var nf: Integer);
label 1,2,endp;
var
Fnc: TIntFunc;
i,N,T,j,S: Integer;
ANL: TArrayC;
begin
nf:=-1;
i:=Tree^.NFunc;
N:=Tree^.Stack.N;
S:=Tree^.Stack.S;
Fnc:=Alg.ExFunc[Tree^.NFunc].Func;


FindNumberLevel(ANL);

//вначале искать среди Infinite
if (F_ExtNumberArg > 0)  and (Length(ANL) >= F_ExtNumberArg) then
begin

 for i:=0 to High(Fnc) do
 begin

  if  Fnc[i].N = -1 then //проверить совпадение типов:
  begin

   for j:=0 to High(ANL) do
   begin
    if Func.Interp[ANL[j]].TypeF <> Fnc[i].TV[0] then goto 2;
   end;

   nf:=i;
   goto endp;
  end;

 2:
 end;

end;



for i:=0 to High(Fnc) do
begin

 if N = Fnc[i].N then //проверить совпадение типов:
 begin

  for j:=0 to N-1 do
  begin
   if Func.Interp[ANL[j]].TypeF <> Fnc[i].TV[j] then goto 1;
  end;

  nf:=i;
  goto endp;
 end;

1:
end;


endp:
end;


procedure TForevalH.FindNumberLevel(var ANL: TArrayC);
var   //определение номеров уровней, вытекающих из данного узла
i,j: Integer;
E: Exception;
begin


for j:=1 to LFunc-1 do
begin
   if Tree^.IdN = Func.Interp[j]^.IdL then
   begin
    SetLength(ANL,Length(ANL)+1);
    ANL[High(ANL)]:=j;
   end;
end;

if Tree^.Stack.N <> Length(ANL) then
begin {InternalError}
 F_InternalError:=1;
 CalcException(ForevalH as TObject,E);
end;

end;



procedure TForevalH.FindLdFunction(var nf: Integer);
label endp;
var
i: Integer;
begin
nf:=-1;
  for i:=0 to High(Alg.LdFunc) do
  begin
   if Alg.Obj[Tree^.NObj].TypeF = Alg.LdFunc[i].TypeF then
   begin
    nf:=i;
    goto endp;
   end;
  end;

endp:
end;



procedure TForevalH.FindConstLdFunction(var nf: Integer);
label endp;
var
i: Integer;
begin
nf:=-1;
  for i:=0 to High(Alg.LdFunc) do
  begin
   if Alg.LdFunc[i].TypeF = 1 then
   begin
    nf:=i;
    goto endp;
   end;
  end;

endp:
end;






procedure TForevalH.InitNode(var ND: TDataNode);
var
i: Integer;
begin
ND.N:=0;
ND.NCOP:=0;
ND.NFunc:=0;
ND.NObj:=0;
ND.COP:=0;
ND.FD:=0;
ND.FX:=0;
ND.IdN:=0;
end;






function TForevalH.PointToDec(S: String):String;
label
1;
var
i:Cardinal;
SS: String;
begin
SS:=Copy(S,1,Length(S));
for i:=1 to Length(S) do
 begin
  if SS[i] = '.' then
  begin
   Delete(SS,i,1);
   Insert(',',SS,i);
   goto 1;
 end
end;

1:
PointToDec:=Copy(SS,1,Length(SS));
end;




procedure TForevalH.CreateInitData;
begin                             //порядок не менять


F_SyntaxErrorCode:=0;
LFunc:=0;

F_ShowException:=False;
F_ExternalException:=False;
F_VarShift:=False;
F_FuncShift:=False;

Alg.Bracket.Br1:=0;
Alg.Bracket.Br2:=0;
Alg.Bracket.Br3:=0;
Alg.Bracket.Br4:=0;

Application.OnException:=CalcException;

SetType(1);
end;




procedure TForevalH.SetExtExpression(S: String;  var E_Func: TFunction; var Stack: Cardinal);
var
I_Func: TFunction;
I_LFunc: Cardinal;
E: Exception;
begin
try
I_LFunc:=LFunc;
I_Func:=Func;
Func:=E_Func;
F_SyntaxErrorCode:=0;
F_CalcErrorCode:=0;
F_InternalError:=0;
F_SyntaxErrorString:='';
F_IdN:=0;
CurrentExpression:=Copy(S,1,Length(S));
PrevTreat(S,S);
Linker(S);
FreeFunction;
CodeGeneration;
if Length(Func.Interp) <> 0 then
F_ResultType:=Func.Interp[High(Func.Interp)]^.TypeF;
SetStackSize;
Compile;
Func.ICode:=TAddress(@Func.Comp[0]);
FreeTree;
Stack:=StackSize; 
E_Func:=Func;
LFunc:=I_LFunc;
Func:=I_Func;

except
 on E: EZeroDivide      do F_InternalError:=1;
 on E: EInvalidOp       do F_InternalError:=2;
 on E: EOverFlow        do F_InternalError:=3;
 on E: EUnderFlow       do F_InternalError:=4;
 on E: EIntOverFlow     do F_InternalError:=5;
 on E: EAccessViolation do F_InternalError:=6;
 on E: EOutOfMemory     do F_InternalError:=7;
 on E: EStackOverFlow   do F_InternalError:=8;
end;
if F_InternalError <> 0 then CalcException(ForevalH as TObject,E);
//BeginLinker:=1;
end;


procedure TForevalH.CalcExtFunc(E_Func: TFunction); assembler;
asm
 //call [E_Func.ICode]
end;




function TForevalH.CalcExtFuncA(Addr: TAddress): TFloatType; assembler;
asm
 call  Addr
 //fstp  @Result
end;



procedure TForevalH.FreeExtFunc(E_Func: TFunction);
var
i: Cardinal;
begin

for i:=1 to Length(E_Func.Interp)-1 do
begin
dispose(E_Func.Interp[i]);
end;
E_Func.Comp:=nil;
E_Func.Interp:=nil;

end;




constructor TForevalH.Create;
begin
//inherited Create(AOwner);
CreateInitData;
end;


destructor TForevalH.Destroy;
begin
FreeFunction;
inherited Destroy;
end;



procedure TForevalH.FreeTree;
label endp;
var
H: PNode;
begin
if F_SyntaxErrorCode <> 0 then goto endp;
Tree:=BeginTree;

while Tree^.Ch <> nil do
begin
Tree:=Tree^.Ch;
end;
//COP=NOP

while Tree^.Pr <> nil do
begin
 while Tree^.Nb <> nil  do
 begin
  H:=Tree; Tree:=Tree^.Nb;  H^.Nb:=nil;
  dispose(H);
  while Tree^.Ch <> nil do
  begin
  Tree:=Tree^.Ch;
  end;
 //COP=NOP
 end;

//COP<>NOP
H:=Tree; Tree:=Tree^.Pr; H^.Pr:=nil;
dispose(H);
end;
dispose(Tree);

endp:
end;




procedure TForevalH.CalcException(Sender: TObject; E: Exception);
var
S: String;
T: Integer;
begin


if F_BeginCalc = 0 then
begin
 {if E.ClassType  = EZeroDivide       then F_InternalError:=1
 else
 if E.ClassType =  EInvalidOp        then F_InternalError:=2
 else
 if E.ClassType =  EOverFlow         then F_InternalError:=3
 else
 if E.ClassType =  EUnderFlow        then F_InternalError:=4
 else
 if E.ClassType =  EIntOverFlow      then F_InternalError:=5
 else
 if E.ClassType =  EAccessViolation  then F_InternalError:=6
 else
 if E.ClassType =  EOutOfMemory      then F_InternalError:=7
 else
 if E.ClassType =  EStackOverFlow    then F_InternalError:=8;
 }
end

else
if F_SyntaxErrorCode = 0 then
begin
 if E.ClassType  = EZeroDivide       then F_CalcErrorCode:=1
 else
 if E.ClassType =  EInvalidOp        then F_CalcErrorCode:=2
 else
 if E.ClassType =  EOverFlow         then F_CalcErrorCode:=3
 else
 if E.ClassType =  EUnderFlow        then F_CalcErrorCode:=4
 else
 if E.ClassType =  EIntOverFlow      then F_CalcErrorCode:=5
 else
 if E.ClassType =  EAccessViolation  then F_CalcErrorCode:=6;

 F_BeginCalc:=0;
end;


if F_ShowException then
begin
 MessageBeep(MB_ICONHAND);
 if F_CalcErrorCode <> 0 then
 begin
  MessageDlg('Calculation Error',mtError,[mbOk],0)
 end
 else
 if F_SyntaxErrorCode <> 0 then
 begin
  if F_SyntaxErrorCode = 1 then S:='UNKNOWN SYMBOL:';
  if F_SyntaxErrorCode = 2 then S:='MISSING BRACKET:';
  if F_SyntaxErrorCode = 3 then S:='MISSING OPERATION:';
  if F_SyntaxErrorCode = 4 then S:='INCOINCIDENCE NUMBER OF ARGUMENTS:';
  if F_SyntaxErrorCode = 5 then S:='MISSING EXPRESSION:';
  if F_SyntaxErrorCode = 6 then S:='UNKNOWN FUNCTION:';
  if F_SyntaxErrorCode = 7 then S:='ABSENT FUNCTION FOR LOAD TYPE:';
  if F_SyntaxErrorCode = 8 then S:='NOT DEFINED OPERATION '+'"'+F_SyntaxErrorString1+'"'+' FOR TYPES:';
  if F_SyntaxErrorCode = 9 then S:='NOT DEFINED FUNCTION '+'"'+F_SyntaxErrorString1+'"'+' FOR TYPES:';

  MessageDlg(S+#13+#10+'"'+F_SyntaxErrorString+'"',mtError,[mbOk],0)
 end
 else
 if F_InternalError <> 0  then
 MessageDlg('Internal Error',mtError,[mbOk],0)
end;

{
if F_ExternalException then
begin
 if F_SyntaxErrorCode <> 0 then T:=1000
 else
 if F_CalcErrorCode <> 0 then T:=1001
 else
 if F_InternalError <> 0 then T:=1002;

 ExtException(T);
end;
}

end;






procedure TForevalH.Compile;
label 1;
var
i,j,N: Integer;
AH,AB: TArray4;
R: TFloatType;
P: Pointer;
X: TFloatType;
begin

LFunc:=Length(Func.Interp);

SetLength(ICOMP,0);


PUSHA;
for i:=1 to LFunc-1 do
begin
 AddCommand(i);
end;
POPA;
RET;

SetLength(Func.Comp,Length(ICOMP));
Func.Comp:=Copy(ICOMP,0,Length(ICOMP));
ICOMP:=nil;
end;


procedure TForevalH.RET;
begin
AddByte($C3);
end;




procedure TForevalH.AddCommand(I: Integer);
var
N,NF: Integer;
begin
//стек:
MOVMA(TAddress(@Func.Interp[I]^.S));
MOVAM(TAddress(@F_NumberStack));

if Func.Interp[I]^.COP = _LDSC then
begin
 MOVA1(TAddress(@Func.Interp[I]^.FD));
 MOVAM(TAddress(@F_Address));
 N:=Func.Interp[I]^.NF;
 MOVA1(TAddress(Alg.LdFunc[N].Addr));
 CALLA;
end
else
if Func.Interp[I]^.COP = _LDSF then
begin
 N:=Func.Interp[I]^.NObj;
 MOVA1(Alg.Obj[N].Addr);
 MOVAM(TAddress(@F_Address));
 N:=Func.Interp[I]^.NF;
 MOVA1(TAddress(Alg.LdFunc[N].Addr));
 CALLA;
end
else
if Func.Interp[I]^.COP = _FUNC then
begin
 N:=Func.Interp[I]^.NFunc;
 NF:=Func.Interp[I]^.NF;

 //infinite:
 if Alg.ExFunc[N].Func[NF].N = -1 then
 begin
  MOVA1(TAddress(Func.Interp[I]^.Arg));
  MOVAM(TAddress(@F_NumberArg));
 end;

 MOVA1(Alg.ExFunc[N].Func[NF].Addr);
 CALLA;
end;



end;



procedure TForevalH.IntToHex(N: TAddress; var AH: TArray4);
var
i,K,N1,j: Integer;
A8: array [1..8] of Integer;
begin
N1:=N;  j:=1;
for i:=7 downto 1 do
begin
 K:=Trunc(N1/IntPower(2,i*4));
 A8[j]:=(K);
 N1:=N1-Trunc(IntPower(2,i*4))*K;
 inc(j);
end;
A8[j]:=N1;


//в обратном порядке:
j:=1;
for i:=4 downto 1 do
begin
 AH[i]:=A8[j]*16+A8[j+1];
 j:=j+2;
end;
end;



procedure TForevalH.AddByte(B: Byte);
var
j: Integer;
begin
j:=High(ICOMP)+1;
SetLength(ICOMP,Length(ICOMP)+1);
ICOMP[j]:=B;
end;



procedure TForevalH.AddWord(B1: Byte; B2: Byte);
var
j: Integer;
begin
j:=High(ICOMP)+1;
SetLength(ICOMP,Length(ICOMP)+2);
ICOMP[j]:=B1; ICOMP[j+1]:=B2;
end;


procedure TForevalH.AddAddress(Adr: TAddress);
var
AB: TArray4;
j: Integer;
begin
IntToHex(Adr,AB);
j:=High(ICOMP)+1;
SetLength(ICOMP,Length(ICOMP)+4);
ICOMP[j]:=AB[1];  ICOMP[j+1]:=AB[2]; ICOMP[j+2]:=AB[3]; ICOMP[j+3]:=AB[4];
end;



procedure TForevalH.CALLA;
begin
AddWord($FF,$D0);
end;


procedure TForevalH.CALLB;
begin
AddWord($FF,$D3);
end;


procedure TForevalH.MOVAM(N: TAddress);
begin
//EAX->MEM
AddWord($89,$05);
AddAddress(N);
end;


procedure TForevalH.MOVMA(N: TAddress);
begin
//MEM->EAX
AddWord($8B,$05);
AddAddress(N);
end;


procedure TForevalH.MOVA1(N: TAddress);
begin
//N - число
AddByte($B8);
AddAddress(N);
end;


procedure TForevalH.FLD(N: TAddress);
begin
AddWord($DD,$05);
AddAddress(N);
end;



procedure TForevalH.FSTP(N: TAddress);
begin
AddWord($DD,$1D);
AddAddress(N);
end;


procedure TForevalH.PUSHA;
begin
AddByte($50);
end;


procedure TForevalH.POPA;
begin
AddByte($58);
end;

end.
