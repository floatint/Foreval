unit TestZ;



interface
uses
  Windows,  SysUtils, Classes,  Dialogs, Math, Forms, Controls, StdCtrls,
  ForevalZ;







type

  TForm1 = class(TForm)

   Button1: TButton;
    LFR: TLabel;
    Label2: TLabel;
    EF: TEdit;
    Label5: TLabel;
    IPF: TLabel;
    CTF: TLabel;
    LCT: TLabel;
    LP: TLabel;
    LCT1: TLabel;
    CB_OM: TCheckBox;
    Label1: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    E_z1x: TEdit;
    E_z2x: TEdit;
    E_z1y: TEdit;
    E_z2y: TEdit;
    E_x: TEdit;
    E_y: TEdit;
    Label4: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    E_Cnt: TEdit;
    procedure Button1Click(Sender: TObject);

    procedure FormCreate(Sender: TObject);
   
    procedure E_z1xChange(Sender: TObject);
    procedure E_z1yChange(Sender: TObject);
    procedure E_z2xChange(Sender: TObject);
    procedure E_z2yChange(Sender: TObject);
    procedure E_xChange(Sender: TObject);
    procedure E_yChange(Sender: TObject);
   


  private



  protected



  public
   X,Y,Z,T,U,V,S,P,Q,R,W,A,B,C,D: TFloat;
   Z1,Z2,Z3,Z4,Z5,ZI: TComplex;



  published




  end;

var
  ak,bk: array[1..7] of TFloat;
  C_2dqrPi: extended;


  Form1: TForm1;

  MI,MI1,MI2,MI3,MI4: Cardinal;
  NC: Cardinal;
  //Stack: TStack;

  //pz: PComplex;
 //Factorial: TArrayF;

implementation

{$R *.DFM}





procedure TForm1.Button1Click(Sender: TObject);
label endp;
const fcw: word = $1f32;
//const fw2: word = $1332;
var
S,S1,S2: String;
i: Cardinal;
T1,T2,SB: Cardinal;
NS: Cardinal;
res,r1,r2: TFloat;


FZ1,FZ2,FZ3,FZ4: TComplFunc;
zr1,zr2,zr3,zr4: TComplex;


begin
 

 //zr1:=GetResultZ(FZ1.Addr);
 //zr1:=GetResult(FZ1);

 {CompileExpression('x/y',FZ1);
 CompileExpression('x/y-sin(x)+z1',FZ2);
 CompileExpression('x*2+t*y-y/x',FZ3);
 CompileExpression('z1^log(z1,z2)',FZ4);
 GetResult(FZ1);  r1:=R_RES^;
 GetResult(FZ2);  zr1:=Z_RES^;
 GetResult(FZ3);  r2:=R_RES^;
 GetResult(FZ4);  zr2:=Z_RES^;
 FreeFunction(FZ1); FreeFunction(FZ2); FreeFunction(FZ3); FreeFunction(FZ4); }


 //res:=Z_RES^.x; r1:=Z_RES^.X; r2:=Z_RES^.Y;

 //FreeFunction(FZ2); FreeFunction(FZ3);


 {
 c1.x:=1.5;   c2.x:=2;
 MEM:=Cardinal(@c1);
 pc1:=Pointer(MEM);
 c2:=pc1^;
 L5.Caption:=FloatToStr(c2.x);
 }
 {
 Foreval.InsertBracketOperation(EF.Text,S);
 L5.Caption:=S;
 }
{ MI:=0; MI1:=0; MI2:=0;
 for i:=0 to 100 do
 begin
 M2.Lines[i]:='';
 end;
 for i:=0 to 100 do
 begin
 M1.Lines[i]:='';
 end;
 for i:=0 to 100 do
 begin
 M3.Lines[i]:='';
 end;   }


 {
 S:=EF.Text;
 Foreval.SetExtExpression(S,FS1,NS);
 SetLength(Stack,NS);
 Foreval.CalcExtFunc(FS1);
 R:=Stack[0].x;
 LFR.Caption:=FloatToStr(R);
 }







   //SetLength(Stack,NS);
   {Foreval.SetExtExpression('z1*z2',FS1,NS);
   Foreval.SetExtExpression('2*x/z1-sin(x)+cos(z1)',FS2,NS);
   Foreval.SetExtExpression('z1+2*i',FS3,NS);
   Foreval.SetExtExpression('z1+z2*x/y+cos(x*z1*2)',FS4,NS); }

   //SetLength(Stack,20);

   {Foreval.CalcExtFunc(FS1);
    S1:=FloatToStr(Stack[0].z.x); S2:=FloatToStr(Stack[0].z.y); M1.Lines[0]:=S1;   M3.Lines[0]:=S2;
   Foreval.CalcExtFunc(FS2);
    S1:=FloatToStr(Stack[0].z.x); S2:=FloatToStr(Stack[0].z.y); M1.Lines[1]:=S1;   M3.Lines[1]:=S2;
   Foreval.CalcExtFunc(FS3);
    S1:=FloatToStr(Stack[0].z.x); S2:=FloatToStr(Stack[0].z.y); M1.Lines[2]:=S1;   M3.Lines[2]:=S2;
   Foreval.CalcExtFunc(FS4);
    S1:=FloatToStr(Stack[0].z.x); S2:=FloatToStr(Stack[0].z.y); M1.Lines[3]:=S1;   M3.Lines[3]:=S2;}

 T1:=GetTickCount;
   CompileExpression(EF.Text,FZ1);
 T2:=GetTickCount;

 CTF.Caption:=IntToStr(T2-T1);
 if CB_OM.Checked then NC:=1 else NC:=abs(Trunc(StrToFloat(E_Cnt.Text)));
 if GetSyntaxError = 0 then
 begin

  T1:=GetTickCount;
  for i:=1 to NC do
  begin
   asm
    call [FZ1.Addr]
   end;
  end;

  T2:=GetTickCount;
  if not CB_OM.Checked then IPF.Caption:=IntToStr(Trunc(NC/(T2-T1)));

  if GetResultType = T_Real then  LFR.Caption:=FloatToStr(R_RESULT^)
  else
  if GetResultType = T_Complex then
  begin
   S1:=FloatToStr(Z_RESULT^.x);
   S2:=FloatToStr(Z_RESULT^.y);
   LFR.Caption:=S1+'  '+S2+'i';
  end;

 end;

 FreeFunction(FZ1);

 x:=2; y:=5; t:=1.77;
 

  //abs(z1)*cos(arg(z1))+i*abs(z1)*sin(arg(z1))
  //z1^log(z1,z2)
 //x/(z1*t-2)+t*z2-t/z1+z2/(x+1)-2*z2*(i+z1-2)
 //z1*z2/z3-z1/(z1-z2+z3)+z2
 //re(z1*z2+i+2)*im(z1/z2-i)
 //(z1+2)*x*i-2.1/(z2+i*x-1.5)+x-z2*sin(x)
 //(z1+2)*x*i-2.1/(z2+i*x-1.5)

endp:
end;

 //res:=2/(-3*x-y-t/x-(-sin(x/y-(-x-1)+1)-y)/t)-(-(-1-x)/y*2+3*x/y/t-cos(-(-x-y)/(-(-x+y*2)-x)-1)/(x+y*t/3)*x);
  //res:=2/(-x)/(-3*(-x)-y*(-y)/(-(-t))-t/x-(-1/(-sin(x/y-(-t-1)+1)-t)/x)+y*(-(-t)))-(-(-1-t)/x*2+3*x/(-y)/(-(-(-t)-2-x)-y)-cos(-(-x-y)/(-(-t+x*2)-x)-1)/(x+y*t/3)*x)-sin(-t-(-x-(1-y)-3-(-x*2))/x/(-y/(-x)-x)-1);

//2/(-3*x-y-t/x-(-sin(x/y-(-x-1)+1)-y)/t)-(-(-1-x)/y*2+3*x/y/t-cos(-(-x-y)/(-(-x+y*2)-x)-1)/(x+y*t/3)*x)
//2/(-x)/(-3*(-x)-y*(-y)/(-(-t))-t/x-(-1/(-sin(x/y-(-t-1)+1)-t)/x)+y*(-(-t)))-(-(-1-t)/x*2+3*x/(-y)/(-(-(-t)-2-x)-y)-cos(-(-x-y)/(-(-t+x*2)-x)-1)/(x+y*t/3)*x)-sin(-t-(-x-(1-y)-3-(-x*2))/x/(-y/(-x)-x)-1)
//-(-x)-(-x/(-x-1-y)-t)*(-(-(-x-1)-y-y-1)/(-y)*t/(-y)-y)*(-(-sin(x)-1-x)-y*x/(-y)/(-y)-(-(1-cos(x)-x)-y)/sin(x)+(-(-x*x-y-y+1)-sin(y)/(-t-(-x)-1)*y)*y+(x-(-sin(x)-1-y)-t/(-t*x/(-y)-1)-1)-x-1)
//x*(-(x*y+x))-2/(-3*x-y-t/x-(-sin(x/(-(x*y+x))-(-t-1)+1)-t)/x)-(-(-1-t)/x*2+3*x/y/t-cos(-(-x-y)/(-(-t+x*2)-x)-1)/(x+y*t/3)*x)
//7-x-(-(-x-1)+cos(x)-1-sin(x)-2*t-(-cos(y-(-(1-sin(t)-x)))))+2*y-t
//1-(-(-x-(-5-x-t+7*t-8)/x-9/(-x)+t/5*x/8*y-9)-7-(x-8)/9) {!!! (8)}
//sin(c*(a*x)^cos(-x^(sin(c^(-6)+x)*c+b)+d)+c*(a*x)^cos(-x^(sin(c^(-6)+x)*c+b)+d))  {!!!}
//sin(c*(a*y)^sin(-y^(sin(c^(-6)+y)*c+b)+d)+c*(a*y)^sin(-y^(sin(c^(-6)+y)*c+b)+d))
// 2*sin(4*x/t-(4*x-5)/(5*y+1)-x*5/cos(tan(2*t^(2*x/sin(4*x*y-5)+1)-3*x*y*t-t)^3)^5/(4*x*y*tan(2*x*y/(4*x-5*t+y-7/x)^7-(3*t+1)^sin(3*cos(sin(5*x/(4*t-1)-1)*tan(2/tan(4*x-t*cos(2*x+1)))*sin(5*x*y*t)*tan(3*(3*t-1)^3-2)+x*4+t-1)))))
//-(-x-y-sin(x)-7+8)-(-(-cos(x)/x-(-(-x+1))/sin(t)-5-x/tg(x)-(-1/x-4+1/t-sin(y))))
//sin(x+5)^((sin(x)^cos(y))^(sin(x+1)^cos(y+1)))+sin(x+5)^((sin(x)^cos(y))^(sin(x+1)^cos(y+1)))
//x*t-exp(t)*(exp(x*t-exp(t)*(exp(x*t-exp(t)*(exp(y*x-1))))))
//x*t-x^t*(x^(x*t-x^t*(x^(x*t-x^t*(x^t)))))
//x*t-x^(-1)*(x^(x*t-x^(-2)*(x^(x*t-x^(-3)*(x^(-4))))))
//x*t-x^7*((x*t-x^7*((x*t-x^7*(x^7))^7))^7)
//x*t-x^5*((x*t-x^5*((x*t-x^5*(x^5)+(x*(x^5))^5)^5)^5)^5)^5
//x*t-x^(-5)*((x*t-x^(-1)*((x*t-x^(-2)*(x^(-3))+(x*(x^(-4)))^(-2))^(-2))^(3))^(4))^(5)
//-(-x-y-sin(x)-7+8)-(-(-cos(x)-(-(-x+1))-5-tg(x)-(x-4-sin(y)))) !!!
//-(-x-y-sin(x)-7+8)-(-(-cos(x)/x-(-(-x+1))/sin(t)-5-x/tg(x)-(-1/x-4+1/t-sin(y))))
//5/((2/x-3)/sin(5/y+3)-2*sin(7/sin(1/(2*x+3)+4)-3/(7-5/(2*x+3)*sin(3/x+5))-3))-3*sin(2*x+3)*(3*y+4)/sin(3/x-2)+4*(2*x+3)*(3*y+4)/(5*x+6)-6*sin(x)/(7*sin(3/x-2)*sin(3/(2*y-3)-4)/(2*x+3)-2*sin(2*x+3)*(3*y+4)/sin(1-5/(2*y+3)))*(2*sin(2/x-3)*(2/sin(2*x+3)-3*sin(2/x-3)/(2*x+3)+4*(3*y-2)/sin(2*y-3)/sin(sin(2*x+3)*sin(3*y+4)/(5*x-7)-7*sin(2/x-3)/(2*y+3)-5*sin(2*x-3)*(2*y-5)/sin(2/x-4))))


//sin(x*(y*x)^cos(-x^(sin(x^(-6)+x)*y+t)+t)+x*(y*x)^cos(-x^(sin(t^(-6)+x)*x+y)+t))
//x*y*(x+y/t-t*y*x*(x+y-t)*x*t*(x+t)*(x+y)/(x+t-y)-t/(x+y)+t*(x+y)/x-(x-y)/t)*(x-t)*(x+y+t*x-y*t)/(t+y/x-t/y)-x*y*(x+t)*(x-y)*(t/(x-t+y)-x*(t+x)/(y-t+x))+(x+y+t+(x-t)*(x+y)-(x+y)/(x-t)-x*y/(t-x))
//(x*(2*x+3)*(4*t+5)*y*t/(7*y+1)+8)*(7*x*y*(2*x+1)*(2*x*y*t-1)/(3*x-4*y+5*t-7)-9)/(4*x*y*(7*x+1)*(9*t+2)*(5*y-9)*(7/(2*x+3)-8/x-9/(2*x*y*t-1)+1))-((2*x+3)/x-t/(4*x+5)-(2*x*y-1)*(3*x-4*y+5*t-7)*x*y/(5*x-7*y+8)-9)*(5*x+1)*(7*y-9)*(7*t-1)/(x/y-t/x+1)
//x-(-(7-(-sin(x)-1)-8*y+y-cos(x)))
//7-x-(-(-x-1)+cos(x)-1-sin(x)-2*t-(-cos(y-(-(1-sin(t)-x)))))+2*y-t
//1-(-(-x-(-5-x-t+7*t-8)/x-9/(-x)+t/5*x/8*y-9)-7-(x-8)/9) {!!! (8)}
//sin((a*x+b*y+c)-(a*x*y*t-d)+d*x-e)
//a*x*(b/(c*c-d)+e*x*(c*(d*x*((a*x+b)-(b*x-c))-x/((x/b-c)*c+(x/d+a)*x+c)+(a*x+b)-(b*x+c)+(c*x+d)*e*x)/(a*(b*(c*(d*(e*x-a)*(x+b)+(c*x-d)*x*a)+c*x+d)+e)/(x-d))*(x/c-d)*a*x))
//a*v1*(b/(c*c-d)+e*v1*(c*(d*v1*((a*v1+b)-(b*v1-c))-v1/((v1/b-c)*c+(v1/d+a)*v1+c)+(a*v1+b)-(b*v1+c)+(c*v1+d)*e*v1)/(a*(b*(c*(d*(e*v1-a)*(v1+b)+(c*v1-d)*v1*a)+c*v1+d)+e)/(v1-d))*(v1/c-d)*a*v1))
//sin(cos(tan(cos(sin(tan(x))))))
//a*x*sin(b*x+c)*cos(c*x+d)+x*c*(cos(c*sin(x*d+e)-c)*tan(c*x))
//(a*v1*v2*v3+v4+b)*(c*v1/(v1+v2-v3)-v4*v1*a+b)+(c*v1*(v2*(a*v3+b)-v3*(c*v4-d)/((a*v1-b*v2+c)*(v3/v4+v1/v2+c)+a*v1-b*v2-c*v3)+v1+v2-c*v3-d*v4*(a/v1+b/v2-c/v3-d/v4)))
//(a*x*y+t-b*x)*(c*(t/x+x/y*(c*x+y-t*(c+y*x*t/d+(y-x)/t)))-x/(x-b*t*y-d/(a*x*y*t-c)+a/x+b/y+c/t-e/(x*y*t))+b)
//(a*v1*v2+v3-b*v1)*(c*(v3/v1+v1/v2*(c*v1+v2-v3*(c+v3*v1*v2/d+(v2-v1)/v3)))-v1/(v1-b*v3*v2-d/(a*v1*v2*v3-c)+a/v1+b/v2+c/v3-e/(v1*v2*v3))+b)
//c*x*(x*c*(b*x*(a*x*(x*b+c)+d)+e)+d)*(c*x+d*x*(d+x+c*(b*x*(b*x+d)+e))+b)+(e*x+d+c*(b+e*x+a*(d+e*x+a*x*(c*x+d)*(b*x+e)*(a*x+c))*(c*x+d))*(c*x+b*x*(e*x+d)+b))
//c*x*(a*x*(b*x+c+d*x*(c*x+e))+(d*x+a)*c+c*x+e)*(a*x+b)*(c*x+d*(c*x+a)+d)*(a+c*x*(d*x+c+x+(c*x+e)*c+(e*x+d)*b)+c*x+d)+d*x+e*x*(a*x+c+x)+x+c*x*(a*x+b)*(c*x+d)*(d*x+e)+d*(c*x+(b*x+c)+(d*x+e)+a)+b
//c*t*(a*t*(b*t+c+d*t*(c*t+e))+(d*t+a)*c+c*t+e)*(a*t+b)*(c*t+d*(c*t+a)+d)*(a+c*t*(d*t+c+t+(c*t+e)*c+(e*t+d)*b)+c*t+d)+d*t+e*t*(a*t+c+t)+t+c*t*(a*t+b)*(c*t+d)*(d*t+e)+d*(c*t+(b*t+c)+(d*t+e)+a)+b
//c*y*(a*y*(b*y+c+d*y*(c*y+e))+(d*y+a)*c+c*y+e)*(a*y+b)*(c*y+d*(c*y+a)+d)*(a+c*y*(d*y+c+y+(c*y+e)*c+(e*y+d)*b)+c*y+d)+d*y+e*y*(a*y+c+y)+y+c*y*(a*y+b)*(c*y+d)*(d*y+e)+d*(c*y+(b*y+c)+(d*y+e)+a)+b
//c/x/(a/x/(x/b-c)-(x/d-a)-x/c-e)/(x/a-b)/(x/c-d)/(a-x/c/(x/d-c-x-(x/c-e)/c)-x/c-d)-x/d-e
//((c/x/(a/x/(x*b-c)-(x*d-a)-x*c-e)/(x*a-b)/(x*c-d)/(a-x*c/(x*d-c-x-(x*c-e)*c)-x*c-d)-x*d-e)/(c*x-d)-(x/(a*x-c)+(a*x-b)/x)/(c*x-d)+x/(c-x/(a*x+b)-(c*x-d)/x+(a*x-b)/(b*x-c)))*(a*x+b)/(c*x+d)+b*x*(c*x+d)/(a*x+d)-c*(c*x+d)*(b*x-a)/x+b
//c*x*(a*x*(b*x-c-d*x*(c*x-e))-(d*x-a)*c-c*x-e)*(a*x-b)*(c*x-d*(c*x-a)-d)*(a-c*x*(d*x-c-x-(c*x-e)*c-(e*x-d)*b)-c*x-d)-d*x-e*x*(a*x-c-x)-x-c*x*(a*x-b)*(c*x-d)*(d*x-e)-d*(c*x-(b*x-c)-(d*x-e)-a)-b
//(((2*x+3)*(3*y+4)+(3*x-5)/(4*y+6)+x*(4*y-5))*(3*x-4)+(2*x+3)*(((3*x-4)/(3*y+5)+5*x/(2*x-5)-7*y*(3*y+5)+7)/(3*x+4)-5/x-7/y))/(((3*x-4)*(4*y-5)*(5*y-7)*x-(3*x-8)*(2*y-9)/(3*x+4)+5/x-7)*(2*x-3)*(3*y+4)+x*(3*x-4)*(3*y+4)+5/x+7)+(3*x-5)*(5*y+6)/x+y*(3*x+5)/(5*x-6)+7
//(2*x*(2*t-1)/(3-x)-t-x/t/(7-y))*(3/x-t-3+(y*(x-1)-t*(5-x/t-7*(8*x-1)/(t*2/y+1))))-(2*x-x*y*t/(6*x-1)-t*(4-y)+2-5/x*(x-t*(3-x))*(x*y/(x+1)/(t-1)-2/y*(y-t))-x*y*t*(3/t+1)/(5*y/x-1))
//((x+sin(x)+3)*2*x+2*sin(x)+x+5)*2+sin(x)*x+2*sin(x)+5*sin(x)*sin(x)*x+5+x+2*(sin(x)*sin(x)*sin(x)+x*sin(x)+x+5)
//x*(2*x+3)*(3*y+4)*(4*x*y+5)+t*(2*t+3*y+4*x+5)*(2*x*y*t+3)+t*(2*x+3*y+4)*(5*x+6)-7*(5*x*y*t-8-7*x-8*y-9*t)*(2*x+3*t+4*y+5)
//power(a*power(b*power(c*x+d,2)+e,2)+b,2)         (a*(b*(c*x+d)^2+e)^2+b)^2
//sin(c*(a*x)^cos(-x^(sin(c^-6+x)*c+b)+d))   {при FOptim = False ощибка!!!}
//sin(c*power(a*x,cos(-power(x,(sin(power(c,-6)+x)*c+b))+d)))
//sin(c*(a*x)^cos(-x^(sin(c^(-6)+x)*c+b)+d)+c*(a*x)^cos(-x^(sin(c^(-6)+x)*c+b)+d))  {!!!}
//sin(c*(a*y)^sin(-y^(sin(c^(-6)+y)*c+b)+d)+c*(a*y)^sin(-y^(sin(c^(-6)+y)*c+b)+d))
//sin((x)^a+(x)^b)
//sin(b+b*x^7+x^6) {!!!}
//a*x^7+x^6
//sin(a*(sin(a*(sin(a*(sin(a*(b*x+d)^b+c))^b+c))^b+c))^b+c)
//sin(a*sin(a*(sin(a*(sin(a*(x)^2+b)^2)^2+b)^2)^2+b)^2+b)^2 {!!!}
//sin(a*sin(x)^2+b) {!!!}
//sin(a*(sin(b*x+c)^2)^2+d) {!!!}
//sin(a*(sin(sin(a*(sin(b*x+c)^2)^2+d))^2)^2+d)
//power(sin(a*power(sin(a*(sin(a*(sin(a*(x)^2+b)^2)^2+b)^2)^2+b),2)+b),2)
//sin(a*(sin(a*(x)^2+b)^2)^2+b)^2 {!!! FC}
//(a*sin(a*(sin(b))^2+b)^2+b)^2 {!!!}
//(a*(sin(a*(sin(b))^2+b)^2)+b)^2
//(sin(a*(sin(b))^2+b)^2)^2   {!!!}
//sin(a*power(power(sin(a*x+b),2),2)+b) {!!!}
//2*x*(2*sin(3*x+4)*sin(4*x+5)+5)*sin(2*x+3)+6
//sin(sin(sin(sin(x)^2+sin(x)^2)^2+sin(sin(x)^2+sin(x)^2))+sin(sin(sin(x)^2+sin(x)^2)^2+sin(sin(x)^2+sin(x)^2)))^2
//power(sin(a*power(sin(a*power(power(sin(a*power(power(sin(a*x+b),2),2)+b),2),2)+b),2)+b),2)   {!!!}
//sin(cos(tan(x/2+3)^5)^5)^5 {FC!!!}
//56:
//sin(sin(sin(sin(a*x+b)^5+sin(c*x+d)^5)^5+sin(sin(d*x+e)^5+sin(c*x+b)^5))^5+sin(sin(sin(d*x+e)^5+sin(a*x+b)^5)^5+sin(sin(d*x+e)^5+sin(c*x+d)^5)))^5
//(a*sin(a*sin(a*sin(x)^2+b)^2+b)^2+b)^2 {!!!}
//63:
//sin(sin(a*sin(a*x+b)^2+b)+sin(a*sin(a*sin(a*x+b)^2+b*sin(c*x+d)^2)^3+b)^5)^2+sin(sin(a*sin(a*sin(b*x+c)^2+b)^2+d)^2+sin(a*sin(a*sin(b*x+c)^2+d)^2+b)^2+sin(a*sin(a*sin(b*x+c)^2+d)^2+b)^2)^3
//2*x*sin(3*x*tan(pi*x)+4*x*cos(pi*x)+5*x*cotan(pi*x)+6*x*sin(pi*x))+7*x*cos(8*x*tan(pi*x)+9*x*cos(pi*x)+10*x*cotan(pi*x)+11*x*sin(pi*x))+12*x*tan(13*x*tan(pi*x)+14*x*cos(pi*x)+15*x*cotan(pi*x)+16*x*sin(pi*x))+17*x*cotan(18*x*tan(pi*x)+19*x*cos(pi*x)+20*x*cotan(pi*x)+21*x*sin(pi*x))
//2*x*sin(3*x*tan(2*x)+4*x*cos(2*x)+5*x*cotan(2*x)+6*x*sin(2*x))+7*x*cos(8*x*tan(2*x)+9*x*cos(2*x)+10*x*cotan(2*x)+11*x*sin(2*x))+12*x*tan(13*x*tan(2*x)+14*x*cos(2*x)+15*x*cotan(2*x)+16*x*sin(2*x))+17*x*cotan(18*x*tan(2*x)+19*x*cos(2*x)+20*x*cotan(2*x)+21*x*sin(2*x))
//2*x*sin(2*x+3)*cos(2*x+3)+3*x*tan(2*x+3)*arctan(sin(2*x+3)*cos(2*x+3)*x*2)/sqrt(x+3*cos(2*x+3)+4*tan(2*x+3)+5*sin(2*x+3)+2)/sqrt(x+6*sqr(7*cos(2*x+3)+1)+3)/sqrt(x+9*sqr(8*sin(2*x+3)+2)+4)/sqrt(x+4*sqr(3*tan(2*x+3)+3)+5)
//3*(2*x*(2*sin(3*x+4)*sin(4*x+5)+5)*sin(2*x+3)+6)*sin(2*x*(2*sin(3*x+4)*sin(4*x+5)+5)*sin(2*x+3)+6)+3*(2*sin(2*x*(2*sin(3*x+4)*sin(4*x+5)+5)*sin(2*x+3)+6)+3)^2+4
//(a*x*t*sin(t/a+b)*(b*x+d)*cos(c*(a*x+b*y+c*t+d)^(c*x-b)-d)-tan(a*sin(a*x+b*y+c)^2-b*cos(a*x*y*t+b)^5+c)^3)/(a*x*y*(b*t-c)^(c*x-d)*(b*t+a)-b*x*sin(a*(b*x+c)^3-b)^4+d)+a*(b*x+c*y+d*t+c)*(a*x*y*t+b)*x*y*t-(b*x*y*t*(c*sin(b*x+c)+d)^3)/(((a*x+b)*(c*y-d)*(b*t+c)*x*y*t*b+c)*sin(a*cos(c*x+d)+b)^3)
//sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(sin(x)))))))))))
//2*v1*sin(2*v2+3)*cos(2*v3+3)+3*v2*tan(2*v4+3)*arctan(sin(2*v1+3)*cos(2*v2+3)*v3*2)/sqrt(v1+3*cos(2*v2+3)+4*tan(2*v3+3)+5*sin(2*v4+3)+2)/sqrt(v3+6*sqr(7*cos(2*v2+3)+1)+3)/sqrt(v1+9*sqr(8*sin(2*v2+3)+2)+4)/sqrt(v3+4*sqr(3*tan(2*v4+3)+3)+5)
//(a*v1*v3*sin(v3/a+b)*(b*v1+d)*cos(c*(a*v1+b*v2+c*v3+d)^(c*v1-b)-d)-tan(a*sin(a*v1+b*v2+c)^2-b*cos(a*v1*v2*v3+b)^5+c)^3)/(a*v1*v2*(b*v3-c)^(c*v1-d)*(b*v3+a)-b*v1*sin(a*(b*v1+c)^3-b)^4+d)+a*(b*v1+c*v2+d*v3+c)*(a*v1*v2*v3+b)*v1*v2*v3-(b*v1*v2*v3*(c*sin(b*v1+c)+d)^3)/(((a*v1+b)*(c*v2-d)*(b*v3+c)*v1*v2*v3*b+c)*sin(a*cos(c*v1+d)+b)^3)
//(2*sin(3*x+4)*cos(x)+3*tan(x))*(3*sin(2*x+3)*tan(3*x+4)+4*sin(2*x+3)*cos(3*x+4)+5)+(2*sin(x)*cos(x)+3*tan(2*x+3)*cos(3*x+4)+4)*(3*cos(3*x+4)*tan(2*x+3)+4*sin(x)*ln(2*x+3)+4)+5
//(sin(x)*cos(x)+sin(x))*(cos(x)*sin(x)+cos(x))+(sin(x)*cos(x)+sin(x))*(cos(x)*sin(x)+cos(x))
//(((sin(x)*sin(x)+sin(x)*sin(x)+sin(x))*(sin(x)*sin(x)*sin(x)+sin(x)*sin(x)*sin(x))*(sin(x)*sin(x)*sin(x)+sin(x))+(sin(x)*sin(x)*sin(x)+sin(x)*sin(x)+sin(x))*(sin(x)*sin(x)+sin(x)*sin(x)+sin(x))+sin(x))*(sin(x)*sin(x)*sin(x)+sin(x))+sin(x))*(sin(x)*sin(x)+sin(x))*(sin(x)*sin(x)+sin(x)*sin(x))+(sin(x)*sin(x)+sin(x)*sin(x)+sin(x))*(sin(x)*sin(x)*sin(x)+sin(x)*sin(x)*sin(x))+sin(x)
//2*(2*x+3)*(3*y+4)*(4*x*y+5)+3*(2*t+3*y+4*x+5)*(2*x*y*t+3)+4*(2*x+3*y+4)*(5*x+6)+7
//5*(2*x*y*t*sin(2*x*y*t+3)*cos(2*x+3*y+4*t+5)+2*x+3*y+4*t+5)*(2*x+3*y+4*t+2*x*y*t*sin(2*x*y*t+3)+5)+2*x*y*t*sin(2*x+3*y+4*t+5)+7*((5*sin(2*x*y*t+5)*cos(2*x+3*y+5*t+7)*x*y*t+7)*(2*x*y*t*sin(2*x*y*t+3)*cos(2*x+3*y+4*t+5)+2*x+3*y+4*t+5)*(2*x*y*t*sin(2*x*y*t+3)*cos(2*x+3*y+4*t+5)+2*x+3*y+4*t+5)+(2*x*y*t*sin(2*x*y*t+3)*cos(2*x+3*y+4*t+5)+2*x+3*y+4*t+5)*(2*x*y*t*sin(2*x*y*t+3)*cos(2*x+3*y+4*t+5)+2*x+3*y+4*t+5)+(2*x*y*t*sin(2*x*y*t+3)*cos(2*x+3*y+4*t+5)+2*x+3*y+4*t+5)+5)+7
//2*(2*x*y*t*sin(2*x*y*t+3)*cos(2*x+3*y+4*t+5)+2*x+3*y+4*t+5)*(2*x*y*t*sin(2*x*y*t+3)*cos(2*x+3*y+4*t+5)+2*x+3*y+4*t+5)+sin(x)+5
//2*sin(a*(2*x*y*t+3)^(2*x+5)-7)+8 {!!!}EXTENDED/TFloat
//2*v1*v2*v3*v4*v5*v6*v7*v8*v9*v10*v11*v12+5
//2*v1-3*v2+4*v3-5*v4+6*v5-7.1*v6+7*v8-9.5*v9+v10-v11+v12-v7+15
//1-5*(-2*(-2*x+3)*sin(x))
//1-(-2*(-2*x+3)*sin(x)-1)
//(2*(x/2+3)/(y/3+4)-7)/(3*sin(x/2-3)/(sin(x/3+4)/2+3)+2)/(x/3+3)-2*(y/4-7)/sin(x/5+7)/(x/3+4)-2*sin(x/5+6)*sin(x/7+8)/(y/5+7)-(2*sin(2/x+3)*(2*x+3)/sin(x/4+5)-(5/x+7)*(2*sin(x/5+7)/(2*x+3)-5)/(x/5+7))
//(2*(x/2-3)/(5/x-7)-(x/5+7)*sin(x/3+4)/(x/5+7)-9)/sin(x/2-3) {!!!}
//(x/2-3)/(5/x-7)+(x/5+7)*2    {!!!}
//2*(sin(x)/(a*x+b)-(a*x-b)/sin(x))*(b-a*x)*sin(x)/(b-x*a)-7
//2*(2*x+3)*(3*y+4)*(4*x*y+5)+3*(2*t+3*y+4*x+5)*(2*x*y*t+3)+4*(2*x+3*y+4)*(5*x+6)+7
//1-((8-3*(2*x-3)/4*y/sin(x)-7)) {!!!}
//5/((2/x-3)/sin(5/y+3)-2*sin(7/sin(1/(2*x+3)+4)-3/(7-5/(2*x+3)*sin(3/x+5))-3))-3*sin(2*x+3)*(3*y+4)/sin(3/x-2)+4*(2*x+3)*(3*y+4)/(5*x+6)-6*sin(x)/(7*sin(3/x-2)*sin(3/(2*y-3)-4)/(2*x+3)-2*sin(2*x+3)*(3*y+4)/sin(1-5/(2*y+3)))*(2*sin(2/x-3)*(2/sin(2*x+3)-3*sin(2/x-3)/(2*x+3)+4*(3*y-2)/sin(2*y-3)/sin(sin(2*x+3)*sin(3*y+4)/(5*x-7)-7*sin(2/x-3)/(2*y+3)-5*sin(2*x-3)*(2*y-5)/sin(2/x-4))))
//sin(sin(x))*sin(x)+sin(x) {!!!} PCO
//sin(x)+sin(x)*sin(sin(x)) {!!!} PCO
//sin(x)+sin(x)*cos(sin(x)) {!!!} PCO + Operations
//sin(x)+sin(x)*sin(x)      {!!!} PCO
//2*((x+1)*3-4)/(3*x*y+4)+5 {!!!}
//sin(2*(3*x+4*t-5)^(2*i-3*j+4)+10)
//sin(2*(3*x+4*t-5)^(2*i-4)+10)
//sin((3*x+1)^i)
//sin(2*(3*x+4*y-10)^(2*i-1)-10)
//sin((3*x+4)^(2*i-1))
//sin(2*(3*x+4*y-10)^(2*i-3*j+4)-10)
//sin(2*(3*x+4*y-4*t+5*z-10)^(2*i-3*j+4*k+5*m-4)-10)
//2*(3*sin(4*(5*x+6*y-10)^(2*i+1)-11)-7)^9+12  !!!
//2*(3*sin(4*(5*x+6*y-10)^11-11)-7)+12         !!!
//2*(3*sin((5*x+6*y-10)^(2*i+1)-11))+12        !!!
//2*(3*(4*x+5*y-30)^(2*i+1)-10)^(3*j-5)-7
//2*x+3*y-4*z+5*t-v-u+s+2*p-q-3*r+5*w+2*x1+3*x2-x3-x4+2*x5-7*x6-x7+8*x8-x9-x10+2*v1-3*v2-4*v3+4*v4+1
//2*i-3*j+4*k+m-n-2*l+3*i1+i2-3*i3+4*i4-i5+i6-2*i7+i8-i9+7
//(2*x^i-5)^j
//(2*x^(i+3*j-12)-5)^(2*l+m)
//sin(2*x^(i+3*j-12)-5)^5
//sin(2*x^(i+3*j-12)-5)^(2*l+m)
//2*sin(4*x/t-(4*x-5)/(5*y+1)-x*5/cos(tan(2*t^(2*x/sin(4*x*y-5)+1)-3*x*y*t-t)^3)^5/(4*x*y*tan(2*x*y/(4*x-5*t+y-7/x)^7-(3*t+1)^sin(3*cos(sin(5*x/(4*t-1)-1)*tan(2/tan(4*x-t*cos(2*x+1)))*sin(5*x*y*t)*tan(3*(3*t-1)^3-2)+x*4+t-1)))))
//(-1)^(2*k+1)*sin(i*t*pi)^(k-i+2)*i!*x^(k-1)/(k!*(2*(2*k+3*i-15)!+5)^(i-2))
//(2*sin(3*x+4)*cos(2*x*y*t-7)*x-x*y*t*2*cos(2*x+3)/sin((4*x+2)/(4*y+1)))*x/sin(x/y*2-3)-2*x/cos(x*sin(5*x+3)/cos(5*x-7)+8)+2*sin(2*x+3*y-4*t+5)*cos(3*x*y*t+7)/(2*x+3)
//sin(x)+1+cos(x*2+3)*sin(x)+x^2+2*t+7  {!!!} Polynom
//1+x^2+2*t   {!!!}
//x*t-cos(t)*(tan(x*t-cos(t)*(tan(x*t-cos(t)*(tan(y*x-t^y)))))) {!!!}
//x*t-cos(t)*(tan(x*t-cos(t)*(tan(x*t-cos(t)*(tan(y*x-t^(-1)))))))
//FA4(sin(x+FA4(FA4(1,2,3,sin(x)),x,y,t)),cos(x)+sin(x*y+x/t-sin(x-y)),FA4(x-y,t/x,t*x*sin(x)+cos(x),7-sin(x)),-FA4(-sin(x),-cos(x),-tan(x)-x,-t))
//FA4(sin(x)-cos(x)+x*y/t,sin(x/cos(x)-tan(x)),sin(x)^cos(x),y)
//FA3(sin(x)*cos(3*FA3(sin(x)/cos(x-t+2)-2*t,x/y,x*cos(x+sin(x)))/(x-1)+4),sin(x)-2*FA3(1-sin(x),x+cos(x)-sin(x)/(x+1),t)-3,x/(sin(x)-FA3(x,t^sin(x),sin(x)^cos(x))))
//FA3(-FR3(-sin(x),-cos(t*sin(x)),3),FA3(1,FA3(sin(x),cos(x)+sin(x)*x-t,t),4-2*FR3(sin(x),cos(x)+sin(x)*x-t,t)-x*FA3(sin(x),cos(x)+sin(x)*x-t,t)),FR3(cos(x)-FA3(sin(x),cos(x)+sin(x)*x-t,t),t,sin(x)+cos(x)/(x+1)))-2*sin(x)/FR3(x-t,x*sin(x),-3/t)-FA3(sin(x)*x+cos(x),x/sin(x)+t,3-x*t/(x+1))
//FR3(sin(x)-cos(x)+x*y/t,sin(x/cos(x)-tan(x)),sin(x)^cos(x))
//cos(x)-sin(2*cos(x)+3)+sin(cos(x))+sin(x)/(cos(x)-5*sin(2*cos(x)+3)-4*sin(cos(x)))-4*cos(5*sin(2*cos(x)+3)/(7*sin(cos(x))-1))
//2/sqrt(sin(x))-sin(x)/(sqrt(sin(x))-sqrt(1-sin(x)))-sin(x)/(sqrt(sin(x))+sqrt(1-sin(x)))
//2-sin(x)-(sqrt(1+sin(x))-sqrt(1-sin(x)))/(sqrt(1+sin(x))+sqrt(1-sin(x)))
//x*t-sech(t)*(tan(x*t-sech(t)*(tan(x*t-sech(t)))))
//x*t-sech(t)*(sech(x*t-sech(t)*(sech(x*t-sech(t)))))
//x*t-sech(t)*(sech(x*t-sech(t)*(sech(x*t-sech(t)*(sech(y*x-1))))))
//x*t-sin(x)^cos(x)*(tan(x*t-sin(x)^cos(x)*(tan(x*t-sin(x)^cos(x)))))
//x*t-exp(t)*(exp(x*t-exp(t)*(exp(x*t-exp(t)))))
//x*t-exp(t)*(exp(x*t-exp(t)*(exp(x*t-exp(t)*(exp(y*x-1))))))
//x*t-x^t*(x^(x*t-x^t*(x^(x*t-x^t*(x^t)))))
//x*t-x^(-1)*(x^(x*t-x^(-2)*(x^(x*t-x^(-3)*(x^(-4))))))
//x*t-x^7*((x*t-x^7*((x*t-x^7*(x^7))^7))^7)
//x*t-x^5*((x*t-x^5*((x*t-x^5*(x^5)+(x*(x^5))^5)^5)^5)^5)^5
//x*t-x^(-5)*((x*t-x^(-1)*((x*t-x^(-2)*(x^(-3))+(x*(x^(-4)))^(-2))^(-2))^(3))^(4))^(5)
//sin(sin(x))+sin(sin(sin(x)))+sin(sin(x))+sin(sin(sin(x)))
//sin(x)+sin(sin(x))+sin(sin(sin(x)))+sin(x)+sin(sin(x))+sin(sin(sin(x)))
//(sin(2*x+4)*3-5*cos(4*x-5)/tan(5*t-7)-x*4+y*5-7)/sin(x*5-11)+7*x*cos(8*t-9) !!!!!
//(sin(x)-cos(x)-x+y)   !!!
//(v1*v2*v3*v4*v5*v6*v7*v8*v9*v10*4*x*y*t+7)^2+(v1*v2*v3*v4*v5*v6*v7*v8*v9*v10*4*x*y+7)^2 !!!
//(v1+v2+v3+v4+v5+v6+v7+v8+v9+v10+4+x+y+t+7)^2+(v1*v2*v3*v4*v5*v6*v7*v8*v9*v10*4*x*y+7)^2
//(v1*v2*v3*v4*v5*v6*v7*v8*v9*v1*4+7)^2+(v1*v2*v3*v4*v5*v6*v7*v8*v9*x*4+7)^2 !!!
//(v1+v2+v3+v4+v5+v6+v7+v8+v9+v1+4+7)^2+(v1+v2+v3+v4+v5+v6+v7+v8+v9+x+4+7)^2
//(x*x*y+7)^2  !!!
//(x*y)^2+(y*t*x)^ !!!
//-(-x-y-sin(x)-7+8)-(-(-cos(x)-(-(-x+1))-5-tg(x)-(x-4-sin(y)))) !!!









procedure TForm1.FormCreate(Sender: TObject);
begin
MI:=0; MI1:=0; MI2:=0; MI3:=0; MI4:=0;








x:=2;
y:=5;
t:=1.77;
a:=2;
b:=2;
c:=3;
d:=4;

z1.x:=2;     z1.y:=-1;
z2.x:=5;     z2.y:=-2;
z3.x:=1.77;  z3.y:=3.53;


SetVar('x',@x,T_Real);
SetVar('y',@y,T_Real);
SetVar('t',@t,T_Real);
SetVar('z1',@z1,T_Complex);
SetVar('z2',@z2,T_Complex);
SetVar('z3',@z3,T_Complex);


end;





procedure TForm1.E_z1xChange(Sender: TObject);
begin
 z1.x:=StrToFloat(E_z1x.Text);
end;

procedure TForm1.E_z1yChange(Sender: TObject);
begin
 z1.y:=StrToFloat(E_z1y.Text);
end;

procedure TForm1.E_z2xChange(Sender: TObject);
begin
 z2.x:=StrToFloat(E_z2x.Text);
end;

procedure TForm1.E_z2yChange(Sender: TObject);
begin
  z2.y:=StrToFloat(E_z2y.Text);
end;

procedure TForm1.E_xChange(Sender: TObject);
begin
 x:=StrToFloat(E_X.Text);
end;

procedure TForm1.E_yChange(Sender: TObject);
begin
  y:=StrToFloat(E_Y.Text);
end;

end.
