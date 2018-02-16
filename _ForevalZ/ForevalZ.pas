unit ForevalZ;
{******************************************************************************}
{                                                                              }
{                 SOREL (C)CopyRight 1999-2001. Russia, S.-Petersburg.         }
{                                                                              }
{                        программирование модуля Foreval_H                     }
{                                                                              }
{                                  ver. 1.0.0                                  }
{******************************************************************************}
interface

uses
Foreval_H, SysUtils, Math;


const
S_c1: single = 1;

const S_c2: single = 2;

const S_c05: single = 0.5;

const S_c025: single = 0.25;
const S_cs2: Single = -2;
const NumberFact = 1754;

const E_CPId2: extended = 1.57079632679489662;{Pi/2;}

const
 T_Complex: Integer = 2;
 T_Real: Integer = 1;

type TFloat = double;

type TArrayF = array of extended;

type
TComplex = record
            x: TFloat;
            y: TFloat;
           end;

type
PComplex = ^TComplex;

type
PFloat = ^TFloat;

type
TData = record
         x: TFloat;
         z: TComplex;
        end;

type
TComplFunc = record
         Addr: Pointer;
         R_Type: Integer;
        end;

type
TStack = array of TData;

type
TFunctionZ = record
              Func: TFunction;
              R_Type: Integer;
             end;

type TForevalZ = class(TForevalH) end;






  procedure CompileExpression(S: String; var Func: TComplFunc);
  procedure CompileExpressionA(S: String; var Addr: Pointer);
  procedure FreeFunctionA(Addr: Pointer);
  procedure FreeFunction(Func: TComplFunc);
  function GetResultR(Addr: Pointer): TFloat;
  function GetResultZ(Addr: Pointer): TComplex;
  function GetResult(Func: TComplFunc):TComplex;
  function GetResultType: Integer;
  function GetSyntaxError: Cardinal;
  function GetSyntaxErrorString: String;
  procedure SetVar(Name:String; Addr: Pointer; TypeV: Integer);











var

 ForevZ: TForevalZ;
 Stack: TStack;
 Factorial: TArrayF;
  CompZ: array of TFunctionZ;
 R_RESULT: PFloat;
 Z_RESULT: PComplex;




implementation
var
MEM: Cardinal;
pf: PFloatType;
pz: PComplex;
zi: TComplex;


procedure FreeCmplFuncList;
var
i: Integer;
begin
For i:=1 to Length(CompZ)-1 do
 begin
  if CompZ[i].Func.ICode <> 0 then
  ForevZ.FreeExtFunc(CompZ[i].Func);
 end;
end;


procedure FreeFunctionA(Addr: Pointer);
var
i: Integer;
begin
For i:=0 to High(CompZ) do
 begin
  if Cardinal(Addr) = CompZ[i].Func.ICode then
  begin
   ForevZ.FreeExtFunc(CompZ[i].Func);
   CompZ[i].Func.ICode:=0;
  end;
 end;
end;


procedure FreeFunction(Func: TComplFunc);
var
i: Integer;
begin
For i:=0 to High(CompZ) do
 begin
  if Cardinal(Func.Addr) = CompZ[i].Func.ICode then
  begin
   ForevZ.FreeExtFunc(CompZ[i].Func);
   CompZ[i].Func.ICode:=0;
  end;
 end;
end;



procedure CompileExpression(S: String; var Func: TComplFunc);
var
FS: TFunction;
NS: Cardinal;
begin
   ForevZ.SetExtExpression(S,FS,NS);
   if ForevZ.SyntaxError = 0 then
   begin
    SetLength(CompZ,Length(CompZ)+1);
    CompZ[High(CompZ)].Func:=FS;
    CompZ[High(CompZ)].R_Type:=ForevZ.ResultType;
    if NS > Length(Stack) then SetLength(Stack,NS+1);
    Func.Addr:=Pointer(CompZ[High(CompZ)].Func.ICode);
    Func.R_Type:= ForevZ.ResultType;
    Z_RESULT:=@Stack[0].z;
    R_RESULT:=@Stack[0].x;
   end;
end;



procedure CompileExpressionA(S: String; var Addr: Pointer);
var
FS: TFunction;
NS: Cardinal;
begin
   Addr:=nil;
   ForevZ.SetExtExpression(S,FS,NS);
   if FS.ICode <> 0 then
   begin
    SetLength(CompZ,Length(CompZ)+1);
    CompZ[High(CompZ)].Func:=FS;
    CompZ[High(CompZ)].R_Type:=ForevZ.ResultType;
    if NS > Length(Stack) then SetLength(Stack,NS);
    Addr:=Pointer(FS.ICode);
   end;
end;


function GetSyntaxError: Cardinal;
begin
 GetSyntaxError:=ForevZ.SyntaxError;
end;

function GetSyntaxErrorString: String;
begin
 GetSyntaxErrorString:=ForevZ.SyntaxErrorString;
end;





function GetResultZ(Addr: Pointer): TComplex;
begin
   asm
   call Addr
   end;
   GetResultZ:=Z_RESULT^;
end;


function GetResultR(Addr: Pointer): TFloat;
begin
 asm
   call Addr
  end;
 GetResultR:=R_RESULT^;
end;



function GetResult(Func: TComplFunc):TComplex;
begin
  asm
   call Func.Addr
  end;

if Func.R_Type = T_Real then
 begin
   GetResult.x:=R_RESULT^;
   GetResult.y:=0;
 end
 else
  if Func.R_Type = T_Complex then
 begin
  GetResult:=Z_RESULT^;
 end;
end;



function GetResultType: Integer;
begin
  GetResultType:=ForevZ.ResultType;
end;

procedure CreateFactMass;
var
i,j: Integer;
S: extended;
begin                   //создание массива факториалов

SetLength(Factorial,NumberFact+1);
S:=1;
for j:=1 to NumberFact do
begin
 S:=S*j;
 Factorial[j]:=S;
end;
 Factorial[0]:=1;
end;


procedure SetVar(Name:String; Addr: Pointer; TypeV: Integer);
begin
  if TypeV = T_Real then  ForevZ.SetObject(Name,Cardinal(Addr),T_Real)
  else
  if TypeV = T_Complex then  ForevZ.SetObject(Name,Cardinal(Addr),T_Complex);
end;


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////СОЗДАНИЕ КЛАССА КОМПЛЕКСНЫХ ЧИСЕЛ////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




function FPWR(x,y: TFloat): TFloat;
asm
//X^Y
//ST(0) <- X
//ST(1) <- Y

     fld      y
     fld      x

     FXCH
     FIST      MEM
     FICOM     MEM
     FNSTSW    AX
     SAHF;
     JZ        @@1
     JMP       @@2
@@1:

     FXCH
     FSTP     ST(1)
     MOV      EAX, MEM



     //PUSH     ECX
     //PUSH     EDX

     fld1
     fxch
     mov     ecx, eax
     cdq
     xor     eax, edx
     sub     eax, edx
     jnz     @@5
     fstp    ST(0)
     //POP     EDX
     //POP     ECX
     jmp     @@3
@@4: fmul    ST, ST
@@5: shr     eax,1
     jnc     @@4
     fmul    ST(1),ST
     jnz     @@4
     fstp    st
     cmp     ecx, 0

     //POP     EDX
     //POP     ECX
     jge     @@3
     fdivr   S_c1
     {fld1
     fdivrp}


     JMP     @@3

@@2:


     FXCH

     FLDZ            {.}
     FCOMP           {.}
     FSTSW   AX      {.}
     SAHF            {.}
     JZ     @@3      {.} //устраняет ошибки типа 0^F; F - дробная степень

     FYL2X
     FLD     ST(0)
     FRNDINT
     FSUB    ST(1), ST
     FXCH    ST(1)
     F2XM1
     FLD1
     FADD
     FSCALE
     FSTP  ST(1)

@@3:

end;



procedure ZPWR(x,y,x1,y1: TFloat; var x2: TFloat; var y2: TFloat);
//z1^z2; z1.RE-ST,z1.IM-ST(1),z2.RE-ST(2),z2.IM-ST(3);
var
 x3,y3: TFloat;
begin
asm
 fld   y1
 fld   x1
 fld   y
 fld   x

 fld   st
 fmul  st,st
 fxch  st(2)
 fld   st
 fmul  st,st
 faddp st(3),st
 fxch  st(2)
 fsqrt
 //LN:
 fldln2
 fxch
 fyl2x

 fxch  st(2)
 fxch
 fpatan
 fld   st
 fmul  st,st(4)
 fxch
 fmul  st,st(3)
 fxch  st(2)
 fmul  st(3),st
 fmulp st(4),st
 fsubp st(2),st
 faddp st(2),st

 //EXP:
 FLDL2E
 FMUL
 FLD     ST(0)
 FRNDINT
 FSUB    ST(1), ST
 FXCH    ST(1)
 F2XM1
 FLD1
 FADD
 FSCALE
 FSTP    ST(1)

 fxch
 fsincos
 fmul   st,st(2)
 fxch   st(2)
 fmulp
 fxch

 fstp   x3
 fstp   y3
end;

 x2:=x3; y2:=y3;
end;





procedure Z_ReCxFPWR(r,x1,y1: TFloat; var x,y: TFloat);
//Re^z2; Re-ST,z2.RE-ST(1),z2.IM-ST(2);
var
 x2,y2: TFloat;
begin

asm

 fld   y1
 fld   x1
 fld   r

 ftst
 fstsw  ax
 sahf


 fabs
 //LN:
 fldln2
 fxch
 fyl2x

 fld   st
 jnb    @@1

 fmul  st,st(2)
 fldpi
 fmul  st,st(4)
 fsubp
 fxch  st(3)
 fmulp
 fldpi
 fmulp st(2),st
 faddp
 fxch
 jmp   @@2


@@1:
 fmulp st(2),st
 fmulp st(2),st
@@2:
  //EXP:
 FLDL2E
 FMUL
 FLD     ST(0)
 FRNDINT
 FSUB    ST(1), ST
 FXCH    ST(1)
 F2XM1
 FLD1
 FADD
 FSCALE
 FSTP    ST(1)

 fxch
 fsincos
 fmul   st,st(2)
 fxch
 fmulp  st(2),st

 fstp    x2
 fstp    y2
end;
  x:=x2; y:=y2;
end;




procedure Z_CxReFPWR(x1,y1,r: TFloat; var x,y: TFloat);
//z1^Re; z1.RE-ST,z1.IM-ST(1),Re-ST(2);
var
 x2,y2: TFloat;
begin
asm

        fld     r
        fld     y1
        fld     x1

        FXCH      ST(2)
        FIST      MEM
        FICOM     MEM
        FNSTSW    AX
        SAHF;
        JZ        @@int
        FXCH      ST(2)
        JMP       @@float

@@int:
        FSTP     ST
        FXCH
        MOV      EAX, MEM

        fldz
        fxch    ST(2)
        fld1
        fxch    ST(2)
        mov     ecx, eax
        cdq
        xor     eax, edx
        sub     eax, edx
        jz      @@3
        jmp     @@2

   @@1: fld   st          //^2
        fmul  st,st
        fxch
        fmul  st,st(2)
        fmul  S_c2
        fxch  st(2)
        fmul  st,st
        fsubp

   @@2: shr     eax,1         //*z
        jnc     @@1

        fld   ST(0)
        fmul  ST(0),ST(3)
        fxch  ST(3)
        fmul  ST(0),ST(2)
        fxch  ST(4)
        fld   ST(0)
        fmul  ST(0),ST(3)
        fxch  ST(1)
        fmul  ST(0),ST(2)
        faddp ST(5),ST(0)
        fsubp ST(3),ST(0)
        jnz   @@1

@@3:
        fstp   st
        fstp   st

        cmp    ecx, 0
        jge    @@end

        //fl_FAST_ZDIV:
        fld    st
        fmul   st,st
        fxch   st(2)
        fld    st
        fmul   st,st
        faddp  st(3),st
        fld1
        fdivrp st(3),st
        fmul   st,st(2)
        fchs
        fxch   st(2)
        fmulp  st(1),st

        jmp    @@end

@@float:
        //ZPUSHST
        fld   st
        fxch  st(2)
        fld   st
        fxch  st(3)

        fmul  st,st
        fxch
        fmul  st,st
        faddp
        fsqrt

        //LN:
        fldln2
        fxch
        fyl2x

        fmul  st,st(3)

        //EXP:
        FLDL2E
        FMUL
        FLD     ST(0)
        FRNDINT
        FSUB    ST(1), ST
        FXCH    ST(1)
        F2XM1
        FLD1
        FADD
        FSCALE
        FSTP    ST(1)

        fxch  st(2)
        fxch
        fpatan
        fmulp st(2),st
        fxch
        fsincos
        fmul   st,st(2)
        fxch
        fmulp  st(2),st

@@end:
       fstp    x2
       fstp    y2
end;
       x:=x2; y:=y2;
end;



procedure Z_SQRT(x1,y1: TFloat; var x: TFloat; var y: TFloat);
var
 x2,y2: TFloat;
begin
//RE-ST(0); IM-ST(1);
asm

 fld  y1
 fld  x1

 push   ax
 fxch
 ftst
 fstsw  ax
 sahf
 fmul   st,st
 fxch
 fld    st
 fmul   st,st
 faddp st(2),st
 fxch
 fsqrt
 fld   st
 fsub  st,st(2)
 fmul  S_c05
 fsqrt
 jnb   @@1
 fchs
@@1:
 fxch  st(2)
 faddp
 fmul  S_c05
 fsqrt
 pop   ax

 fstp x2
 fstp y2
end;
  x:=x2; y:=y2;
end;




procedure Z_SQR(x1,y1: TFloat; var x: TFloat; var y: TFloat);
var
 x2,y2: TFloat;
begin
//RE-ST(0); IM-ST(1);
asm
 fld  y1
 fld  x1
 fld   st
 fmul  st,st
 fxch
 fmul  st,st(2)
 fmul  S_c2
 fxch  st(2)
 fmul  st,st
 fsubp
 fstp x2
 fstp y2
end;
  x:=x2; y:=y2;
end;


procedure Z_LN(x1,y1: TFloat; var x: TFloat; var y: TFloat);
var
 x2,y2: TFloat;
begin
//RE-ST(0); IM-ST(1);
asm

 fld  y1
 fld  x1

 fld  st
 fxch st(2)
 fld  st
 fxch st(3)
 fpatan
 fxch st(2)
 fmul st,st
 fxch
 fmul st,st
 faddp
 fldln2
 fxch
 fyl2x
 fmul dword ptr S_c05

 fstp x2
 fstp y2
end;
  x:=x2; y:=y2;
end;


procedure  Z_SIN(x1,y1: TFloat; var x: TFloat; var y: TFloat);
//RE-ST(0); IM-ST(1);
var
 x2,y2: TFloat;
begin
asm
   fld  y1
   fld  x1

   fxch
   //EXP:
   FLDL2E
   FMUL
   FLD     ST(0)
   FRNDINT
   FSUB    ST(1), ST
   FXCH    ST(1)
   F2XM1
   FLD1
   FADD
   FSCALE
   FSTP    ST(1)

   fld   st
   fdivr S_c1
   fld   st
   fadd  st,st(2)
   fmul  S_c05
   fxch  st(2)
   fsubrp
   fmul  S_c05
   fxch  st(2)
   fsincos
   fmulp st(3),st
   fmulp

   fstp x2
   fstp y2
end;
  x:=x2; y:=y2;
end;





procedure  Z_COS(x1,y1: TFloat; var x: TFloat; var y: TFloat);
//RE-ST(0); IM-ST(1);
var
 x2,y2: TFloat;
begin
asm
   fld  y1
   fld  x1

   fxch
   //EXP:
   FLDL2E
   FMUL
   FLD     ST(0)
   FRNDINT
   FSUB    ST(1), ST
   FXCH    ST(1)
   F2XM1
   FLD1
   FADD
   FSCALE
   FSTP    ST(1)

   fld   st
   fdivr S_c1
   fld   st
   fadd  st,st(2)
   fmul  S_c05
   fxch  st(2)
   fsubrp
   fmul  S_c05
   fxch  st(2)
   fsincos
   fmulp st(2),st
   fchs
   fmulp st(2),st

   fstp x2
   fstp y2
end;
  x:=x2; y:=y2;
end;



procedure Z_ARCSH(x1,y1: TFloat; var x: TFloat; var y: TFloat);
var
 x2,y2: TFloat;
begin
//RE-ST(0); IM-ST(1);
asm

 fld  y1
 fld  x1

 //ZPUSHST
 fld   st
 fxch  st(2)
 fld   st
 fxch  st(3)

 //ZSQR
 fld   st
 fmul  st,st
 fxch
 fmul  st,st(2)
 fmul  S_c2
 fxch  st(2)
 fmul  st,st
 fsubp

 fadd  S_c1

 //ZSQRT:
 push   ax
 fxch
 ftst
 fstsw  ax
 sahf
 fmul   st,st
 fxch
 fld    st
 fmul   st,st
 faddp st(2),st
 fxch
 fsqrt
 fld   st
 fsub  st,st(2)
 fmul  S_c05
 fsqrt
 jnb   @@1
 fchs
@@1:
 fxch  st(2)
 faddp
 fmul  S_c05
 fsqrt
 pop   ax

 faddp st(2),st
 faddp st(2),st

 //ZLN:
 fld  st
 fxch st(2)
 fld  st
 fxch st(3)
 fpatan
 fxch st(2)
 fmul st,st
 fxch
 fmul st,st
 faddp
 fldln2
 fxch
 fyl2x
 fmul dword ptr S_c05
   fstp x2
   fstp y2
end;
  x:=x2; y:=y2;
end;




procedure Z_ARCCH(x1,y1: TFloat; var x: TFloat; var y: TFloat);
var
 x2,y2: TFloat;
begin
//RE-ST(0); IM-ST(1);
asm

 fld  y1
 fld  x1


 //ZPUSHST
 fld   st
 fxch  st(2)
 fld   st
 fxch  st(3)

 //ZSQR
 fld   st
 fmul  st,st
 fxch
 fmul  st,st(2)
 fmul  S_c2
 fxch  st(2)
 fmul  st,st
 fsubp

 fsub  S_c1

 //ZSQRT:
 push   ax
 fxch
 ftst
 fstsw  ax
 sahf
 fmul   st,st
 fxch
 fld    st
 fmul   st,st
 faddp st(2),st
 fxch
 fsqrt
 fld   st
 fsub  st,st(2)
 fmul  S_c05
 fsqrt
 jnb   @@1
 fchs
@@1:
 fxch  st(2)
 faddp
 fmul  S_c05
 fsqrt
 pop   ax

 faddp st(2),st
 faddp st(2),st

 //ZLN:
 fld  st
 fxch st(2)
 fld  st
 fxch st(3)
 fpatan
 fxch st(2)
 fmul st,st
 fxch
 fmul st,st
 faddp
 fldln2
 fxch
 fyl2x
 fmul dword ptr S_c05
   fstp x2
   fstp y2
end;
  x:=x2; y:=y2;
end;




procedure Z_ARCTH(x1,y1: TFloat; var x: TFloat; var y: TFloat);
var
 x2,y2: TFloat;
begin
//RE-ST(0); IM-ST(1);
asm

 fld  y1
 fld  x1

  fsubr  S_c1
  fld    st
  fsubr  S_c2
  fmul   st,st(1)
  fxch
  fmul   st,st
  fxch   st(2)
  fld    st
  fmul   S_c2
  fxch
  fmul   st,st
  fsub   st(2),st
  faddp  st(3),st
  fxch   st(2)
  fdivr  S_c1
  fmul   st(1),st
  fmulp  st(2),st

//ZLN*0.5
  fld  st
  fxch st(2)
  fld  st
  fxch st(3)
  fpatan
  fmul  S_c05
  fxch st(2)
  fmul st,st
  fxch
  fmul st,st
  faddp
  fldln2
  fxch
  fyl2x
  fmul  S_c025
   fstp x2
   fstp y2
end;
  x:=x2; y:=y2;
end;




procedure Z_ARCCTH(x1,y1: TFloat; var x: TFloat; var y: TFloat);
var
 x2,y2: TFloat;
begin
//RE-ST(0); IM-ST(1);
asm

 fld  y1
 fld  x1

  fsub   S_c1
  fld    st
  fadd   S_c2
  fmul   st,st(1)
  fxch
  fmul   st,st
  fxch   st(2)
  fld    st
  fmul   S_cs2
  fxch
  fmul   st,st
  fadd   st(2),st
  faddp  st(3),st
  fxch   st(2)
  fdivr  S_c1
  fmul   st(1),st
  fmulp  st(2),st

//ZLN*0.5
  fld  st
  fxch st(2)
  fld  st
  fxch st(3)
  fpatan
  fmul  S_c05
  fxch st(2)
  fmul st,st
  fxch
  fmul st,st
  faddp
  fldln2
  fxch
  fyl2x
  fmul  S_c025
   fstp x2
   fstp y2
end;
  x:=x2; y:=y2;
end;









procedure Z_TH(x1,y1: TFloat; var x: TFloat; var y: TFloat);
var
 x2,y2: TFloat;
begin
//RE-ST(0); IM-ST(1);
asm

 fld  y1
 fld  x1
   fmul   S_c2
   fxch
   fmul   S_c2
   fxch
   //EXP:
   FLDL2E
   FMUL
   FLD     ST(0)
   FRNDINT
   FSUB    ST(1), ST
   FXCH    ST(1)
   F2XM1
   FLD1
   FADD
   FSCALE
   FSTP    ST(1)

   fld    st
   fmul   st,st
   fmul   S_c05
   fld    st
   fsub   S_c05
   fxch
   fadd   S_c05
   fxch   st(3)
   fsincos
   fmul   st,st(3)
   faddp  st(4),st
   fxch   st(3)
   fdivr  S_c1
   fxch
   fmul   st,st(1)
   fxch   st(3)
   fmulp  st(2),st
   fmulp
   fxch
   fstp x2
   fstp y2
end;
  x:=x2; y:=y2;
end;



procedure Z_CTH(x1,y1: TFloat; var x: TFloat; var y: TFloat);
var
 x2,y2: TFloat;
begin
//RE-ST(0); IM-ST(1);
asm

 fld  y1
 fld  x1
   fmul   S_c2
   fxch
   fmul   S_c2
   fxch
   //EXP:
   FLDL2E
   FMUL
   FLD     ST(0)
   FRNDINT
   FSUB    ST(1), ST
   FXCH    ST(1)
   F2XM1
   FLD1
   FADD
   FSCALE
   FSTP    ST(1)

   fld    st
   fmul   st,st
   fmul   S_c05
   fld    st
   fsub   S_c05
   fxch
   fadd   S_c05
   fxch   st(3)
   fsincos
   fmul   st,st(3)
   faddp  st(4),st
   fxch   st(3)
   fdivr  S_c1
   fxch
   fmul   st,st(1)
   fxch   st(3)
   fmulp  st(2),st
   fmulp
   fxch

     //r/z1; r-ST,z1.RE-ST(1),z1.IM-ST(2);
  fld1

  fxch st(2)
  fld  st
  fmul st,st
  fxch
  fmul st,st(3)
  fchs
  fxch st(3)
  fmul st,st(2)
  fxch st(2)
  fmul st,st
  faddp
  fdivr S_c1
  fmul  st(1),st
  fmulp st(2),st

   fstp x2
   fstp y2
end;
  x:=x2; y:=y2;
end;




procedure Z_TAN(x1,y1: TFloat; var x: TFloat; var y: TFloat);
var
 x2,y2: TFloat;
begin
//RE-ST(0); IM-ST(1);
asm

 fld  y1
 fld  x1

   fmul   S_c2
   fxch
   fmul   S_c2
   //EXP:
   FLDL2E
   FMUL
   FLD     ST(0)
   FRNDINT
   FSUB    ST(1), ST
   FXCH    ST(1)
   F2XM1
   FLD1
   FADD
   FSCALE
   FSTP    ST(1)

   fld    st
   fmul   st,st
   fmul   S_c05
   fld    st
   fsub   S_c05
   fxch
   fadd   S_c05
   fxch   st(3)
   fsincos
   fmul   st,st(3)
   faddp  st(4),st
   fxch   st(3)
   fdivr  S_c1
   fxch
   fmul   st,st(1)
   fxch   st(3)
   fmulp  st(2),st
   fmulp
   fstp x2
   fstp y2
end;
  x:=x2; y:=y2;
end;





procedure Z_COTAN(x1,y1: TFloat; var x: TFloat; var y: TFloat);
var
 x2,y2: TFloat;
begin
//RE-ST(0); IM-ST(1);
asm

 fld  y1
 fld  x1

   fmul   S_c2
   fxch
   fmul   S_c2
   //EXP:
   FLDL2E
   FMUL
   FLD     ST(0)
   FRNDINT
   FSUB    ST(1), ST
   FXCH    ST(1)
   F2XM1
   FLD1
   FADD
   FSCALE
   FSTP    ST(1)

   fld    st
   fmul   st,st
   fmul   S_c05
   fld    st
   fsub   S_c05
   fxch
   fadd   S_c05
   fxch   st(3)
   fsincos
   fmul   st,st(3)
   faddp  st(4),st
   fxch   st(3)
   fdivr  S_c1
   fxch
   fmul   st,st(1)
   fxch   st(3)
   fmulp  st(2),st
   fmulp

   //r/z1; r-ST,z1.RE-ST(1),z1.IM-ST(2);
  fld1

  fxch st(2)
  fld  st
  fmul st,st
  fxch
  fmul st,st(3)
  fchs
  fxch st(3)
  fmul st,st(2)
  fxch st(2)
  fmul st,st
  faddp
  fdivr S_c1
  fmul  st(1),st
  fmulp st(2),st

   fstp x2
   fstp y2
end;
  x:=x2; y:=y2;
end;



procedure Z_EXP(x1,y1: TFloat; var x: TFloat; var y: TFloat);
var
 x2,y2: TFloat;
begin
//RE-ST(0); IM-ST(1);
asm

 fld  y1
 fld  x1

 //EXP:
   FLDL2E
   FMUL
   FLD     ST(0)
   FRNDINT
   FSUB    ST(1), ST
   FXCH    ST(1)
   F2XM1
   FLD1
   FADD
   FSCALE
   FSTP    ST(1)

   fxch
   fsincos
   fmul  st,st(2)
   fxch
   fmulp st(2),st
   fstp x2
   fstp y2
end;
  x:=x2; y:=y2;
end;



procedure Z_SH(x1,y1: TFloat; var x: TFloat; var y: TFloat);
var
 x2,y2: TFloat;
begin
//RE-ST(0); IM-ST(1);
asm

 fld  y1
 fld  x1
  //EXP:
   FLDL2E
   FMUL
   FLD     ST(0)
   FRNDINT
   FSUB    ST(1), ST
   FXCH    ST(1)
   F2XM1
   FLD1
   FADD
   FSCALE
   FSTP    ST(1)

   fld   st
   fdivr S_c1
   fld   st
   fadd  st,st(2)
   fmul  S_c05
   fxch  st(2)
   fsubrp
   fmul  S_c05
   fxch  st(2)
   fsincos
   fmulp st(3),st
   fmulp
   fxch
   fstp x2
   fstp y2
end;
  x:=x2; y:=y2;
end;





procedure Z_CH(x1,y1: TFloat; var x: TFloat; var y: TFloat);
var
 x2,y2: TFloat;
begin
//RE-ST(0); IM-ST(1);
asm

 fld  y1
 fld  x1

 //EXP:
   FLDL2E
   FMUL
   FLD     ST(0)
   FRNDINT
   FSUB    ST(1), ST
   FXCH    ST(1)
   F2XM1
   FLD1
   FADD
   FSCALE
   FSTP    ST(1)

   fld   st
   fdivr S_c1
   fld   st
   fadd  st,st(2)
   fmul  S_c05
   fxch  st(2)
   fsubrp
   fmul  S_c05
   fxch  st(2)
   fsincos
   fmulp st(2),st
   fmulp st(2),st
   fstp x2
   fstp y2
end;
  x:=x2; y:=y2;
end;



procedure Z_ARCTAN(x1,y1: TFloat; var x: TFloat; var y: TFloat);
var
 x2,y2: TFloat;
begin
//RE-ST(0); IM-ST(1);
asm

 fld  y1
 fld  x1

  fxch
  fadd   S_c1
  fld    st
  fsubr  S_c2
  fmul   st,st(1)
  fxch
  fmul   st,st
  fxch   st(2)
  fld    st
  fmul   S_c2
  fxch
  fmul   st,st
  fsub   st(2),st
  faddp  st(3),st
  fxch   st(2)
  fdivr  S_c1
  fmul   st(1),st
  fmulp  st(2),st
   //ZLN:
   fld  st
   fxch st(2)
   fld  st
   fxch st(3)
   fpatan
   fxch st(2)
   fmul st,st
   fxch
   fmul st,st
   faddp
   fldln2
   fxch
   fyl2x
   fmul dword ptr S_c05

   fmul  S_c05
   fchs
   fxch
   fmul  S_c05
   fstp x2
   fstp y2
end;
  x:=x2; y:=y2;
end;





procedure Z_ARCCOTAN(x1,y1: TFloat; var x: TFloat; var y: TFloat);
var
 x2,y2: TFloat;
begin
//RE-ST(0); IM-ST(1);
asm

 fld  y1
 fld  x1

  fxch
  fsub   S_c1
  fld    st
  fadd   S_c2
  fmul   st,st(1)
  fxch
  fmul   st,st
  fxch   st(2)
  fld    st
  fmul   S_c2
  fxch
  fmul   st,st
  fadd   st(2),st
  faddp  st(3),st
  fxch   st(2)
  fdivr  S_c1
  fmul   st(1),st
  fmulp  st(2),st
   //ZLN:
   fld  st
   fxch st(2)
   fld  st
   fxch st(3)
   fpatan
   fxch st(2)
   fmul st,st
   fxch
   fmul st,st
   faddp
   fldln2
   fxch
   fyl2x
   fmul dword ptr S_c05

   fmul  S_c05
   fchs
   fxch
   fmul  S_c05
   fstp x2
   fstp y2
end;
  x:=x2; y:=y2;
end;



procedure Z_ARCSIN(x1,y1: TFloat; var x: TFloat; var y: TFloat);
var
 x2,y2: TFloat;
begin
//RE-ST(0); IM-ST(1);
asm

 fld  y1
 fld  x1

    //ZPUSHST:
   fld   st
   fxch  st(2)
   fld   st
   fxch  st(3)
   //ZSQR:
   fld   st
   fmul  st,st
   fxch
   fmul  st,st(2)
   fmul  S_c2
   fxch  st(2)
   fmul  st,st
   fsubp

   fsubr S_c1
   fxch
   fchs
   //ZSQRT':
   ftst
   fstsw  ax
   sahf
   fmul   st,st
   fxch
   fld    st
   fmul   st,st
   faddp st(2),st
   fxch
   fsqrt
   fld   st
   fsub  st,st(2)
   fmul  S_c05
   fsqrt
   jnb   @@1
   fchs
  @@1:
   fxch  st(2)
   faddp
   fmul  S_c05
   fsqrt

   fsubrp st(3),st
   faddp
   fxch
   //ZLN:
   fld  st
   fxch st(2)
   fld  st
   fxch st(3)
   fpatan
   fxch st(2)
   fmul st,st
   fxch
   fmul st,st
   faddp
   fldln2
   fxch
   fyl2x
   fmul dword ptr S_c05

   fchs
   fxch
   fstp x2
   fstp y2
end;
  x:=x2; y:=y2;
end;





procedure Z_ARCCOS(x1,y1: TFloat; var x: TFloat; var y: TFloat);
var
 x2,y2: TFloat;
begin
//RE-ST(0); IM-ST(1);
asm

 fld  y1
 fld  x1
   //ZPUSHST:
   fld   st
   fxch  st(2)
   fld   st
   fxch  st(3)
   //ZSQR:
   fld   st
   fmul  st,st
   fxch
   fmul  st,st(2)
   fmul  S_c2
   fxch  st(2)
   fmul  st,st
   fsubp

   fsubr S_c1
   fxch
   fchs
   //ZSQRT':
   ftst
   fstsw  ax
   sahf
   fmul   st,st
   fxch
   fld    st
   fmul   st,st
   faddp st(2),st
   fxch
   fsqrt
   fld   st
   fsub  st,st(2)
   fmul  S_c05
   fsqrt
   jnb   @@1
   fchs
  @@1:
   fxch  st(2)
   faddp
   fmul  S_c05
   fsqrt

   faddp  st(3),st
   fsubp  st(1),st
   //ZLN:
   fld  st
   fxch st(2)
   fld  st
   fxch st(3)
   fpatan
   fxch st(2)
   fmul st,st
   fxch
   fmul st,st
   faddp
   fldln2
   fxch
   fyl2x
   fmul dword ptr S_c05

   fchs
   fxch
   fstp x2
   fstp y2
end;
  x:=x2; y:=y2;
end;





procedure Z_ReCxLOG(r,x1,y1: TFloat; var x,y: TFloat);
//log(r,z); Re-ST,z2.RE-ST(1),z2.IM-ST(2);
var
 x2,y2: TFloat;
begin

asm

 fld   y1
 fld   x1
 fld   r

  ftst
  fstsw  ax
  sahf
  jb     @@pi
  fldz
  jmp    @@1
@@pi:
  fldpi
@@1:
  fxch
  fmul  st,st
  //LN:
  fldln2
  fxch
  fyl2x

  fxch  st(3)
  fld   st
  fmul  st,st
  fxch  st(3)
  fld   st
  fmul  st,st
  faddp st(4),st
  fpatan
  fxch  st(2)
  //LN:
  fldln2
  fxch
  fyl2x

  fxch
  fld   st
  fmul  st,st
  fxch  st(4)
  fld   st
  fmul  st,st
  fmul  S_c025

  faddp st(5),st
  fxch  st(4)
  fdivr S_c1
  fxch  st(4)
  fld   st
  fmul  st,st(3)
  fxch
  fmul  st,st(4)
  fxch  st(4)
  fmul  st,st(2)
  fxch  st(3)
  fmulp st(2),st
  fmul  S_c025
  faddp st(2),st
  fsubp st(2),st
  fmul  st,st(2)
  fxch
  fmul  S_c05
  fmulp st(2),st
 fstp    x2
 fstp    y2
end;
  x:=x2; y:=y2;
end;






procedure Z_CxReLOG(x1,y1,r: TFloat; var x,y: TFloat);
//log(z,r);
//RE-ST(0); z1.Re-ST(1); z1.Im-ST(2);
var
 x2,y2: TFloat;
begin
asm

        fld     r
        fld     y1
        fld     x1

  fld   st
  fmul  st,st
  fxch  st(2)
  fld   st
  fmul  st,st
  faddp st(3),st
  fxch
  fpatan
  fxch
  //LN:
  fldln2
  fxch
  fyl2x

  fxch  st(2)
  ftst
  fstsw  ax
  sahf
  jb     @@pi
  fldz
  jmp    @@1
@@pi:
  fldpi
@@1:
  fxch
  fmul  st,st
  //LN:
  fldln2
  fxch
  fyl2x

  fxch
  fxch  st(2)
  fld   st
  fmul  st,st
  fxch  st(4)
  fld   st
  fmul  st,st
  fmul  S_c025

  faddp st(5),st
  fxch  st(4)
  fdivr S_c1
  fxch  st(4)
  fld   st
  fmul  st,st(3)
  fxch
  fmul  st,st(4)
  fxch  st(4)
  fmul  st,st(2)
  fxch  st(3)
  fmulp st(2),st
  fmul  S_c025
  faddp st(2),st
  fsubp st(2),st
  fmul  st,st(2)
  fxch
  fmul  S_c05
  fmulp st(2),st
       fstp    x2
       fstp    y2
end;
       x:=x2; y:=y2;
end;




procedure Z_CxCxLOG(x,y,x1,y1: TFloat; var x2: TFloat; var y2: TFloat);
//log(z1,z2); z1.Re-ST,z1.Im-ST(1),z2.Re-ST(2),z2.Im-ST(3);
var
 x3,y3: TFloat;
begin
asm
 fld   y1
 fld   x1
 fld   y
 fld   x

  fld   st
  fmul  st,st
  fxch  st(2)
  fld   st
  fmul  st,st
  faddp st(3),st
  fxch
  fpatan
  fxch
  //LN:
  fldln2
  fxch
  fyl2x

  fxch  st(3)
  fld   st
  fmul  st,st
  fxch  st(3)
  fld   st
  fmul  st,st
  faddp st(4),st
  fpatan
  fxch  st(2)
  //LN:
  fldln2
  fxch
  fyl2x

  fxch
  fld   st
  fmul  st,st
  fxch  st(4)
  fld   st
  fmul  st,st
  fmul  S_c025

  faddp st(5),st
  fxch  st(4)
  fdivr S_c1
  fxch  st(4)
  fld   st
  fmul  st,st(3)
  fxch
  fmul  st,st(4)
  fxch  st(4)
  fmul  st,st(2)
  fxch  st(3)
  fmulp st(2),st
  fmul  S_c025
  faddp st(2),st
  fsubp st(2),st
  fmul  st,st(2)
  fxch
  fmul  S_c05
  fmulp st(2),st
 fstp   x3
 fstp   y3
end;

 x2:=x3; y2:=y3;
end;







procedure LDS1;
begin
 pf:=Pointer(ForevZ.GetAddress);
 Stack[ForevZ.GetStack].x:=pf^;
end;

procedure ADD1;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].x:=Stack[N].x+Stack[N+1].x;
end;


procedure SUB1;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].x:=Stack[N].x-Stack[N+1].x;
end;


procedure MUL1;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].x:=Stack[N].x*Stack[N+1].x;
end;


procedure DIV1;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].x:=Stack[N].x/Stack[N+1].x;
end;


procedure NEG1;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].x:=-Stack[N].x;
end;

procedure ABS1;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].x:=abs(Stack[N].x);
end;


procedure ARG1;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].x:=0;
end;


procedure FACT1;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].x:=Factorial[Trunc(Stack[N].x)];
end;


procedure SIN1;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].x:=sin(Stack[N].x);
end;

procedure SQR1;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].x:=sqr(Stack[N].x);
end;

procedure SQRT1;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].x:=sqrt(Stack[N].x);
end;

procedure EXP1;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].x:=exp(Stack[N].x);
end;


procedure COS1;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].x:=cos(Stack[N].x);
end;

procedure TAN1;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].x:=tan(Stack[N].x);
end;

procedure COTAN1;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].x:=cotan(Stack[N].x);
end;


procedure ASIN1;
var
N:Integer;
x: TFloat;
begin
 N:=ForevZ.GetStack;
 x:=Stack[N].x;
 asm
  fld   x
  FLD   ST
  FMUL  ST,ST
  FLD1
  FSUBR
  FSQRT
  FPATAN
  fstp  x
end;
  Stack[N].x:=x;
end;


procedure ACOS1;
var
N:Integer;
x: TFloat;
begin
 N:=ForevZ.GetStack;
 x:=Stack[N].x;
 asm
  fld   x
  FLD   ST
  FMUL  ST,ST
  FLD1
  FSUBR
  FSQRT
  FXCH
  FPATAN
  fstp  x
end;

  Stack[N].x:=x;
end;


procedure ATAN1;
var
N:Integer;
x: TFloat;
begin
 N:=ForevZ.GetStack;
 x:=Stack[N].x;
 asm
  fld   x
  FLD1
  FPATAN
  fstp  x
end;
  Stack[N].x:=x;
end;


procedure ACOTAN1;
var
N:Integer;
x: TFloat;
begin
 N:=ForevZ.GetStack;
 x:=Stack[N].x;
 asm
  fld   x
  FLD1
  FPATAN
  FLD  E_CPid2
  fsubrp
  fstp  x
end;
  Stack[N].x:=x;
end;


procedure SINH1;
var
N:Integer;
x: TFloat;
begin
 N:=ForevZ.GetStack;
 x:=Stack[N].x;
asm
  fld   x
  FLDL2E
  FMUL
  FLD     ST(0)
  FRNDINT
  FSUB    ST(1), ST
  FXCH    ST(1)
  F2XM1
  FLD1
  FADD
  FSCALE
  FSTP    ST(1)

  FLD   ST(0)
  FLD1
  FDIVR
  FSUB
  FMUL   S_C05
  fstp   x
end;

  Stack[N].x:=x;
end;



procedure COSH1;
var
N:Integer;
x: TFloat;
begin
 N:=ForevZ.GetStack;
 x:=Stack[N].x;
asm
  fld   x
  FLDL2E
  FMUL
  FLD     ST(0)
  FRNDINT
  FSUB    ST(1), ST
  FXCH    ST(1)
  F2XM1
  FLD1
  FADD
  FSCALE
  FSTP    ST(1)

  FLD     ST(0)
  FLD1
  FDIVR
  FADD
  FMUL  S_C05
  fstp   x
end;

  Stack[N].x:=x;
end;


procedure TANH1;
var
N:Integer;
x: TFloat;
begin
 N:=ForevZ.GetStack;
 x:=Stack[N].x;
asm
  fld   x
  FMUL   S_c2
  FLDL2E
  FMUL
  FLD     ST(0)
  FRNDINT
  FSUB    ST(1), ST
  FXCH    ST(1)
  F2XM1
  FLD1
  FADD
  FSCALE
  FSTP    ST(1)

  FLD     ST(0)
  FLD1
  FSUB
  FLD1
  FADD    ST,ST(2)
  FDIV
  FSTP    ST(1)
  fstp   x
end;

  Stack[N].x:=x;
end;



procedure COTANH1;
var
N:Integer;
x: TFloat;
begin
 N:=ForevZ.GetStack;
 x:=Stack[N].x;
asm
  fld   x
  FMUL   S_c2
  FLDL2E
  FMUL
  FLD     ST(0)
  FRNDINT
  FSUB    ST(1), ST
  FXCH    ST(1)
  F2XM1
  FLD1
  FADD
  FSCALE
  FSTP   ST(1)

  FLD     ST(0)
  FLD1
  FSUB
  FLD1
  FADD    ST,ST(2)
  FDIVR
  FSTP    ST(1)
  fstp   x
end;

  Stack[N].x:=x;
end;


procedure ARCSINH1;
var
N:Integer;
x: TFloat;
begin
 N:=ForevZ.GetStack;
 x:=Stack[N].x;
asm
  fld   x
  FLD   ST
  FMUL  ST,ST
  FLD1
  FADD
  FSQRT
  FXCH
  FADD
  FLDLN2
  FXCH  ST(1)
  FYL2X
  fstp   x
end;

  Stack[N].x:=x;
end;



procedure ARCCOSH1;
var
N:Integer;
x: TFloat;
begin
 N:=ForevZ.GetStack;
 x:=Stack[N].x;
asm
  fld   x
  FLD   ST
  FMUL  ST,ST
  FLD1
  FSUB
  FSQRT
  FXCH
  FADD
  FLDLN2
  FXCH  ST(1)
  FYL2X
  fstp   x
end;

  Stack[N].x:=x;
end;



procedure ARCTANH1;
var
N:Integer;
x: TFloat;
begin
 N:=ForevZ.GetStack;
 x:=Stack[N].x;
asm
  fld   x
  FLD  ST
  FLD1
  FADD
  FXCH
  FLD1
  FSUBR
  FDIV
  FLDLN2
  FXCH  ST(1)
  FYL2X
  FMUL  S_C05
  fstp   x
end;

  Stack[N].x:=x;
end;



procedure ARCCOTANH1;
var
N:Integer;
x: TFloat;
begin
 N:=ForevZ.GetStack;
 x:=Stack[N].x;
asm
  fld   x
  FLD  ST
  FLD1
  FADD
  FXCH
  FLD1
  FSUB
  FDIV
  FLDLN2
  FXCH  ST(1)
  FYL2X
  FMUL  S_C05
  fstp   x
end;

  Stack[N].x:=x;
end;



procedure LN1;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].x:=ln(Stack[N].x);
end;

procedure LN2;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Z_LN(Stack[N].z.x,Stack[N].z.y,Stack[N].z.x,Stack[N].z.y);
end;


procedure SQRT2;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Z_SQRT(Stack[N].z.x,Stack[N].z.y,Stack[N].z.x,Stack[N].z.y);
end;

procedure SQR2;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Z_SQR(Stack[N].z.x,Stack[N].z.y,Stack[N].z.x,Stack[N].z.y);
end;

procedure COS2;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Z_COS(Stack[N].z.x,Stack[N].z.y,Stack[N].z.x,Stack[N].z.y);
end;

procedure SIN2;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Z_SIN(Stack[N].z.x,Stack[N].z.y,Stack[N].z.x,Stack[N].z.y);
end;

procedure EXP2;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Z_EXP(Stack[N].z.x,Stack[N].z.y,Stack[N].z.x,Stack[N].z.y);
end;

procedure TAN2;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Z_TAN(Stack[N].z.x,Stack[N].z.y,Stack[N].z.x,Stack[N].z.y);
end;


procedure COTAN2;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Z_COTAN(Stack[N].z.x,Stack[N].z.y,Stack[N].z.x,Stack[N].z.y);
end;


procedure ASIN2;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Z_ARCSIN(Stack[N].z.x,Stack[N].z.y,Stack[N].z.x,Stack[N].z.y);
end;

procedure ACOS2;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Z_ARCCOS(Stack[N].z.x,Stack[N].z.y,Stack[N].z.x,Stack[N].z.y);
end;



procedure ATAN2;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Z_ARCTAN(Stack[N].z.x,Stack[N].z.y,Stack[N].z.x,Stack[N].z.y);
end;


procedure ACOTAN2;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Z_ARCCOTAN(Stack[N].z.x,Stack[N].z.y,Stack[N].z.x,Stack[N].z.y);
end;


procedure SH2;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Z_SH(Stack[N].z.x,Stack[N].z.y,Stack[N].z.x,Stack[N].z.y);
end;


procedure CH2;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Z_CH(Stack[N].z.x,Stack[N].z.y,Stack[N].z.x,Stack[N].z.y);
end;


procedure TH2;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Z_TH(Stack[N].z.x,Stack[N].z.y,Stack[N].z.x,Stack[N].z.y);
end;

procedure CTH2;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Z_CTH(Stack[N].z.x,Stack[N].z.y,Stack[N].z.x,Stack[N].z.y);
end;


procedure ASH2;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Z_ARCSH(Stack[N].z.x,Stack[N].z.y,Stack[N].z.x,Stack[N].z.y);
end;


procedure ACH2;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Z_ARCCH(Stack[N].z.x,Stack[N].z.y,Stack[N].z.x,Stack[N].z.y);
end;


procedure ATH2;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Z_ARCTH(Stack[N].z.x,Stack[N].z.y,Stack[N].z.x,Stack[N].z.y);
end;

procedure ACTH2;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Z_ARCCTH(Stack[N].z.x,Stack[N].z.y,Stack[N].z.x,Stack[N].z.y);
end;


procedure POWER1;
var
N:Integer;
x,y: TFloat;
begin
 N:=ForevZ.GetStack;
 y:=Stack[N+1].x;
 x:=Stack[N].x;

 Stack[N].x:=FPWR(x,y);
 //Stack[N].x:=power(Stack[N].x,Stack[N+1].x);
end;


procedure POWER2;
var
N:Integer;
x,y,x1,y1: TFloat;
begin
 N:=ForevZ.GetStack;
 ZPWR(Stack[N].z.x,Stack[N].z.y,Stack[N+1].z.x,Stack[N+1].z.y,Stack[N].z.x,Stack[N].z.y);
end;



procedure POWER21;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Z_CxReFPWR(Stack[N].z.x,Stack[N].z.y,Stack[N+1].x,Stack[N].z.x,Stack[N].z.y);
end;


procedure POWER12;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Z_ReCxFPWR(Stack[N].x,Stack[N+1].z.x,Stack[N+1].z.y,Stack[N].z.x,Stack[N].z.y);
end;



procedure LG2;
var
N:Integer;
x,y,x1,y1: TFloat;
begin
 N:=ForevZ.GetStack;
 Z_CxCxLog(Stack[N].z.x,Stack[N].z.y,Stack[N+1].z.x,Stack[N+1].z.y,Stack[N].z.x,Stack[N].z.y);
end;



procedure LG21;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Z_CxReLog(Stack[N].z.x,Stack[N].z.y,Stack[N+1].x,Stack[N].z.x,Stack[N].z.y);
end;


procedure LG12;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Z_ReCxLog(Stack[N].x,Stack[N+1].z.x,Stack[N+1].z.y,Stack[N].z.x,Stack[N].z.y);
end;




procedure LDS2;
begin
 pz:=Pointer(ForevZ.GetAddress);
 Stack[ForevZ.GetStack].z.x:=pz^.x;
 Stack[ForevZ.GetStack].z.y:=pz^.y;
end;

procedure ADD2;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].z.x:=Stack[N].z.x+Stack[N+1].z.x;
 Stack[N].z.y:=Stack[N].z.y+Stack[N+1].z.y;
end;


procedure SUB2;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].z.x:=Stack[N].z.x-Stack[N+1].z.x;
 Stack[N].z.y:=Stack[N].z.y-Stack[N+1].z.y;
end;


procedure MUL2;
var
N:Integer;
x,y: TFloat;
begin
 N:=ForevZ.GetStack;
 x:=Stack[N].z.x*Stack[N+1].z.x-Stack[N].z.y*Stack[N+1].z.y;
 y:=Stack[N].z.x*Stack[N+1].z.y+Stack[N+1].z.x*Stack[N].z.y;
 Stack[N].z.x:=x;
 Stack[N].z.y:=y;
end;


procedure DIV2;
var
N:Integer;
x1,y1,z: TFloat;
begin
 N:=ForevZ.GetStack;
 x1:=Stack[N].z.x*Stack[N+1].z.x+Stack[N].z.y*Stack[N+1].z.y;
 y1:=Stack[N+1].z.x*Stack[N].z.y-Stack[N].z.x*Stack[N+1].z.y;
 z:=1/(sqr(Stack[N+1].z.x)+sqr(Stack[N+1].z.y));
 Stack[N].z.x:=x1*z;
 Stack[N].z.y:=y1*z;
end;


procedure NEG2;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].z.x:=-Stack[N].z.x;
 Stack[N].z.y:=-Stack[N].z.y;
end;


procedure ABS2;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].x:=sqrt(sqr(Stack[N].z.x)+sqr(Stack[N].z.y));
end;


procedure ARG2;
var
N:Integer;
x: TFloat;
begin
 N:=ForevZ.GetStack;
 x:=Stack[N].z.y/Stack[N].z.x;
 asm
  fld   x
  FLD1
  FPATAN
  fstp  x
 end;
  Stack[N].x:=x;
end;




procedure ADD12;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].z.x:=Stack[N].x+Stack[N+1].z.x;
 Stack[N].z.y:=Stack[N+1].z.y;
end;


procedure SUB12;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].z.x:=Stack[N].x-Stack[N+1].z.x;
 Stack[N].z.y:=-Stack[N+1].z.y;
end;


procedure MUL12;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].z.x:=Stack[N].x*Stack[N+1].z.x;
 Stack[N].z.y:=Stack[N].x*Stack[N+1].z.y;
end;


procedure DIV12;
var
N:Integer;
x1,y1,z: TFloat;
begin
 N:=ForevZ.GetStack;
 x1:=Stack[N].x*Stack[N+1].z.x;
 y1:=-Stack[N].x*Stack[N+1].z.y;
 z:=1/(sqr(Stack[N+1].z.x)+sqr(Stack[N+1].z.y));
 Stack[N].z.x:=x1*z;
 Stack[N].z.y:=y1*z;
end;




procedure ADD21;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].z.x:=Stack[N+1].x+Stack[N].z.x;
end;


procedure SUB21;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].z.x:=Stack[N].z.x-Stack[N+1].x;
end;


procedure MUL21;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].z.x:=Stack[N+1].x*Stack[N].z.x;
 Stack[N].z.y:=Stack[N+1].x*Stack[N].z.y;
end;


procedure DIV21;
var
N:Integer;
r: TFloat;
begin
 N:=ForevZ.GetStack;
 r:=1/Stack[N+1].x;
 Stack[N].z.x:=Stack[N].z.x*r;
 Stack[N].z.y:=Stack[N].z.y*r;
end;



procedure RE;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].x:=Stack[N].z.x;
end;



procedure IM;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].x:=Stack[N].z.y;
end;


procedure RE1;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].x:=Stack[N].x;
end;



procedure IM1;
var
N:Integer;
begin
 N:=ForevZ.GetStack;
 Stack[N].x:=0;
end;



procedure CreateClass;
var
TF: TArrayC;
begin


SetLength(TF,2); TF[0]:=T_Real; TF[1]:=T_Real;
ForevZ.SetLoadFunction(T_Real,Cardinal(@LDS1));
ForevZ.SetFunction('add',Cardinal(@ADD1),TF,T_Real);
ForevZ.SetFunction('sub',Cardinal(@SUB1),TF,T_Real);
ForevZ.SetFunction('mul',Cardinal(@MUL1),TF,T_Real);
ForevZ.SetFunction('div',Cardinal(@DIV1),TF,T_Real);
ForevZ.SetFunction('power',Cardinal(@POWER1),TF,T_Real);
SetLength(TF,1); TF[0]:=T_Real;
ForevZ.SetFunction('neg',Cardinal(@NEG1),TF,T_Real);
ForevZ.SetFunction('abs',Cardinal(@ABS1),TF,T_Real);
ForevZ.SetFunction('re',Cardinal(@RE1),TF,T_Real);
ForevZ.SetFunction('im',Cardinal(@IM1),TF,T_Real);
ForevZ.SetFunction('arg',Cardinal(@ARG1),TF,T_Real);


ForevZ.SetFunction('sin',Cardinal(@SIN1),TF,T_Real);
ForevZ.SetFunction('cos',Cardinal(@COS1),TF,T_Real);
ForevZ.SetFunction('tan',Cardinal(@TAN1),TF,T_Real);
ForevZ.SetFunction('cotan',Cardinal(@COTAN1),TF,T_Real);
ForevZ.SetFunction('arccos',Cardinal(@ACOS1),TF,T_Real);
ForevZ.SetFunction('arcsin',Cardinal(@ASIN1),TF,T_Real);
ForevZ.SetFunction('arctan',Cardinal(@ATAN1),TF,T_Real);
ForevZ.SetFunction('arccotan',Cardinal(@ACOTAN1),TF,T_Real);

ForevZ.SetFunction('sinh',Cardinal(@SINH1),TF,T_Real);
ForevZ.SetFunction('cosh',Cardinal(@COSH1),TF,T_Real);
ForevZ.SetFunction('tanh',Cardinal(@TANH1),TF,T_Real);
ForevZ.SetFunction('cotanh',Cardinal(@COTANH1),TF,T_Real);
ForevZ.SetFunction('arccosh',Cardinal(@ARCCOSH1),TF,T_Real);
ForevZ.SetFunction('arcsinh',Cardinal(@ARCSINH1),TF,T_Real);
ForevZ.SetFunction('arctanh',Cardinal(@ARCTANH1),TF,T_Real);
ForevZ.SetFunction('arccotanh',Cardinal(@ARCCOTANH1),TF,T_Real);


ForevZ.SetFunction('ln',Cardinal(@LN1),TF,T_Real);
ForevZ.SetFunction('exp',Cardinal(@EXP1),TF,T_Real);
ForevZ.SetFunction('sqr',Cardinal(@SQR1),TF,T_Real);
ForevZ.SetFunction('sqrt',Cardinal(@SQRT1),TF,T_Real);
ForevZ.SetFunction('fact',Cardinal(@FACT1),TF,T_Real);

//ForevZ.SetFunctionEx('add',Cardinal(@ADDEx1),1,T_Real);
//ForevZ.ExtNumberArg:=3;

//Complex:
SetLength(TF,2); TF[0]:=T_Complex; TF[1]:=T_Complex;
ForevZ.SetLoadFunction(T_Complex,Cardinal(@LDS2));
ForevZ.SetFunction('add',Cardinal(@ADD2),TF,T_Complex);
ForevZ.SetFunction('sub',Cardinal(@SUB2),TF,T_Complex);
ForevZ.SetFunction('mul',Cardinal(@MUL2),TF,T_Complex);
ForevZ.SetFunction('div',Cardinal(@DIV2),TF,T_Complex);
ForevZ.SetFunction('power',Cardinal(@POWER2),TF,T_Complex);
ForevZ.SetFunction('log',Cardinal(@LG2),TF,T_Complex);

SetLength(TF,1); TF[0]:=T_Complex;
ForevZ.SetFunction('ln',Cardinal(@LN2),TF,T_Complex);
ForevZ.SetFunction('sin',Cardinal(@SIN2),TF,T_Complex);
ForevZ.SetFunction('cos',Cardinal(@COS2),TF,T_Complex);
ForevZ.SetFunction('exp',Cardinal(@EXP2),TF,T_Complex);
ForevZ.SetFunction('sqrt',Cardinal(@SQRT2),TF,T_Complex);
ForevZ.SetFunction('sqr',Cardinal(@SQR2),TF,T_Complex);


ForevZ.SetFunction('tan',Cardinal(@TAN2),TF,T_Complex);
ForevZ.SetFunction('cotan',Cardinal(@COTAN2),TF,T_Complex);
ForevZ.SetFunction('arccos',Cardinal(@ACOS2),TF,T_Complex);
ForevZ.SetFunction('arcsin',Cardinal(@ASIN2),TF,T_Complex);
ForevZ.SetFunction('arctan',Cardinal(@ATAN2),TF,T_Complex);
ForevZ.SetFunction('arccotan',Cardinal(@ACOTAN2),TF,T_Complex);
ForevZ.SetFunction('cosh',Cardinal(@CH2),TF,T_Complex);
ForevZ.SetFunction('sinh',Cardinal(@SH2),TF,T_Complex);
ForevZ.SetFunction('tanh',Cardinal(@TH2),TF,T_Complex);
ForevZ.SetFunction('cotanh',Cardinal(@CTH2),TF,T_Complex);
ForevZ.SetFunction('arccosh',Cardinal(@ACH2),TF,T_Complex);
ForevZ.SetFunction('arcsinh',Cardinal(@ASH2),TF,T_Complex);
ForevZ.SetFunction('arctanh',Cardinal(@ATH2),TF,T_Complex);
ForevZ.SetFunction('arccotanh',Cardinal(@ACTH2),TF,T_Complex);




SetLength(TF,1); TF[0]:=T_Complex;
ForevZ.SetFunction('neg',Cardinal(@NEG2),TF,T_Complex);
ForevZ.SetFunction('re',Cardinal(@RE),TF,T_Real);
ForevZ.SetFunction('im',Cardinal(@IM),TF,T_Real);
ForevZ.SetFunction('abs',Cardinal(@ABS2),TF,T_Real);
ForevZ.SetFunction('arg',Cardinal(@ARG2),TF,T_Real);



//MIX(12):
SetLength(TF,2); TF[0]:=T_Real; TF[1]:=T_Complex;
ForevZ.SetFunction('add',Cardinal(@ADD12),TF,T_Complex);
ForevZ.SetFunction('sub',Cardinal(@SUB12),TF,T_Complex);
ForevZ.SetFunction('mul',Cardinal(@MUL12),TF,T_Complex);
ForevZ.SetFunction('div',Cardinal(@DIV12),TF,T_Complex);
ForevZ.SetFunction('power',Cardinal(@POWER12),TF,T_Complex);
ForevZ.SetFunction('log',Cardinal(@LG12),TF,T_Complex);

//MIX(21):
SetLength(TF,2); TF[0]:=T_Complex; TF[1]:=T_Real;
ForevZ.SetFunction('add',Cardinal(@ADD21),TF,T_Complex);
ForevZ.SetFunction('sub',Cardinal(@SUB21),TF,T_Complex);
ForevZ.SetFunction('mul',Cardinal(@MUL21),TF,T_Complex);
ForevZ.SetFunction('div',Cardinal(@DIV21),TF,T_Complex);
ForevZ.SetFunction('power',Cardinal(@POWER21),TF,T_Complex);
ForevZ.SetFunction('log',Cardinal(@LG21),TF,T_Complex);



//Operation:
ForevZ.SetOperation('+','add',1,0);
ForevZ.SetOperation('-','sub',1,0);
ForevZ.SetOperation('*','mul',2,0);
ForevZ.SetOperation('/','div',2,0);
ForevZ.SetOperation('^','power',3,0);
ForevZ.SetOperation('-','neg',1,-1);
ForevZ.SetOperation('!','fact',2,-2);

zi.x:=0; zi.y:=1;
ForevZ.SetObject('i',Cardinal(@zi),T_Complex);


end;



initialization
begin
 ForevZ:=TForevalZ.Create;
 CreateClass;
 SetLength(CompZ,1);
 SetLength(Stack,1);
 createFactMass;
 ForevZ.ShowException:=False;
 ForevZ.VarShift:=True;
end;



finalization
begin


FreeCmplFuncList;
CompZ:=nil;
ForevZ.Destroy;

end;

end.
