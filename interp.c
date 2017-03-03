#include <setjmp.h>
#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include "interp.h"

void *closr_closure(void *code, void *env) {
clos* _data = (clos*)malloc(sizeof(clos));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _closure_clos;
  _data->u._closure._code = code;
  _data->u._closure._env = env;
  return (void *)_data;
}

void *envrr_empty() {
envr* _data = (envr*)malloc(sizeof(envr));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _empty_envr;
  return (void *)_data;
}

void *envrr_extend(void *arg, void *env) {
envr* _data = (envr*)malloc(sizeof(envr));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _extend_envr;
  _data->u._extend._arg = arg;
  _data->u._extend._env = env;
  return (void *)_data;
}

void *cntr_emptyr__m__kr__m__ds(void *dismount) {
cnt* _data = (cnt*)malloc(sizeof(cnt));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _emptyr__m__kr__m__ds_cnt;
  _data->u._emptyr__m__kr__m__ds._dismount = dismount;
  return (void *)_data;
}

void *cntr_innerr__m__kr__m__ds(void *closure, void *kr__ex__) {
cnt* _data = (cnt*)malloc(sizeof(cnt));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _innerr__m__kr__m__ds_cnt;
  _data->u._innerr__m__kr__m__ds._closure = closure;
  _data->u._innerr__m__kr__m__ds._kr__ex__ = kr__ex__;
  return (void *)_data;
}

void *cntr_outerr__m__kr__m__ds(void *rand, void *env, void *kr__ex__) {
cnt* _data = (cnt*)malloc(sizeof(cnt));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _outerr__m__kr__m__ds_cnt;
  _data->u._outerr__m__kr__m__ds._rand = rand;
  _data->u._outerr__m__kr__m__ds._env = env;
  _data->u._outerr__m__kr__m__ds._kr__ex__ = kr__ex__;
  return (void *)_data;
}

void *cntr_ifr__m__k(void *conseq, void *env, void *alt, void *kr__ex__) {
cnt* _data = (cnt*)malloc(sizeof(cnt));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _ifr__m__k_cnt;
  _data->u._ifr__m__k._conseq = conseq;
  _data->u._ifr__m__k._env = env;
  _data->u._ifr__m__k._alt = alt;
  _data->u._ifr__m__k._kr__ex__ = kr__ex__;
  return (void *)_data;
}

void *cntr_innerr__m__multr__m__k(void *xr1, void *kr__ex__) {
cnt* _data = (cnt*)malloc(sizeof(cnt));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _innerr__m__multr__m__k_cnt;
  _data->u._innerr__m__multr__m__k._xr1 = xr1;
  _data->u._innerr__m__multr__m__k._kr__ex__ = kr__ex__;
  return (void *)_data;
}

void *cntr_outerr__m__multr__m__k(void *randr2, void *env, void *kr__ex__) {
cnt* _data = (cnt*)malloc(sizeof(cnt));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _outerr__m__multr__m__k_cnt;
  _data->u._outerr__m__multr__m__k._randr2 = randr2;
  _data->u._outerr__m__multr__m__k._env = env;
  _data->u._outerr__m__multr__m__k._kr__ex__ = kr__ex__;
  return (void *)_data;
}

void *cntr_subr1r__m__k(void *kr__ex__) {
cnt* _data = (cnt*)malloc(sizeof(cnt));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _subr1r__m__k_cnt;
  _data->u._subr1r__m__k._kr__ex__ = kr__ex__;
  return (void *)_data;
}

void *cntr_zeror__m__k(void *kr__ex__) {
cnt* _data = (cnt*)malloc(sizeof(cnt));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _zeror__m__k_cnt;
  _data->u._zeror__m__k._kr__ex__ = kr__ex__;
  return (void *)_data;
}

void *cntr_returnr__m__k(void *vexp, void *env) {
cnt* _data = (cnt*)malloc(sizeof(cnt));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _returnr__m__k_cnt;
  _data->u._returnr__m__k._vexp = vexp;
  _data->u._returnr__m__k._env = env;
  return (void *)_data;
}

void *cntr_letr__m__k(void *body, void *env, void *kr__ex__) {
cnt* _data = (cnt*)malloc(sizeof(cnt));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _letr__m__k_cnt;
  _data->u._letr__m__k._body = body;
  _data->u._letr__m__k._env = env;
  _data->u._letr__m__k._kr__ex__ = kr__ex__;
  return (void *)_data;
}

void *expr_const(void *n) {
exp* _data = (exp*)malloc(sizeof(exp));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _const_exp;
  _data->u._const._n = n;
  return (void *)_data;
}

void *expr_var(void *v) {
exp* _data = (exp*)malloc(sizeof(exp));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _var_exp;
  _data->u._var._v = v;
  return (void *)_data;
}

void *expr_if(void *test, void *conseq, void *alt) {
exp* _data = (exp*)malloc(sizeof(exp));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _if_exp;
  _data->u._if._test = test;
  _data->u._if._conseq = conseq;
  _data->u._if._alt = alt;
  return (void *)_data;
}

void *expr_mult(void *randr1, void *randr2) {
exp* _data = (exp*)malloc(sizeof(exp));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _mult_exp;
  _data->u._mult._randr1 = randr1;
  _data->u._mult._randr2 = randr2;
  return (void *)_data;
}

void *expr_subr1(void *rand) {
exp* _data = (exp*)malloc(sizeof(exp));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _subr1_exp;
  _data->u._subr1._rand = rand;
  return (void *)_data;
}

void *expr_zero(void *rand) {
exp* _data = (exp*)malloc(sizeof(exp));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _zero_exp;
  _data->u._zero._rand = rand;
  return (void *)_data;
}

void *expr_capture(void *body) {
exp* _data = (exp*)malloc(sizeof(exp));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _capture_exp;
  _data->u._capture._body = body;
  return (void *)_data;
}

void *expr_return(void *vexp, void *kexp) {
exp* _data = (exp*)malloc(sizeof(exp));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _return_exp;
  _data->u._return._vexp = vexp;
  _data->u._return._kexp = kexp;
  return (void *)_data;
}

void *expr_let(void *vexp, void *body) {
exp* _data = (exp*)malloc(sizeof(exp));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _let_exp;
  _data->u._let._vexp = vexp;
  _data->u._let._body = body;
  return (void *)_data;
}

void *expr_lambda(void *body) {
exp* _data = (exp*)malloc(sizeof(exp));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _lambda_exp;
  _data->u._lambda._body = body;
  return (void *)_data;
}

void *expr_app(void *rator, void *rand) {
exp* _data = (exp*)malloc(sizeof(exp));
if(!_data) {
  fprintf(stderr, "Out of memory\n");
  exit(1);
}
  _data->tag = _app_exp;
  _data->u._app._rator = rator;
  _data->u._app._rand = rand;
  return (void *)_data;
}

int main()
{
exprr__t__ = (void *)expr_app(expr_lambda(expr_app(expr_app(expr_var((void *)0),expr_var((void *)0)),expr_const((void *)5))),expr_lambda(expr_lambda(expr_if(expr_zero(expr_var((void *)0)),expr_const((void *)1),expr_mult(expr_var((void *)0),expr_app(expr_app(expr_var((void *)1),expr_var((void *)1)),expr_subr1(expr_var((void *)0))))))));
envr__t__ = (void *)envrr_empty();
pc = &valuer__m__ofr__m__cps;
mount_tram();
printf("Factorial of 5: %d\n", (int)vr__t__);exprr__t__ = (void *)expr_app(expr_app(expr_lambda(expr_lambda(expr_var((void *)1))),expr_const((void *)5)),expr_const((void *)6));
envr__t__ = (void *)envrr_empty();
pc = &valuer__m__ofr__m__cps;
mount_tram();
printf("Value of expression: %d\n", (int)vr__t__);exprr__t__ = (void *)expr_mult(expr_const((void *)2),expr_capture(expr_mult(expr_const((void *)5),expr_return(expr_mult(expr_const((void *)2),expr_const((void *)6)),expr_var((void *)0)))));
envr__t__ = (void *)envrr_empty();
pc = &valuer__m__ofr__m__cps;
mount_tram();
printf("Capture and Return evaluation result: %d\n", (int)vr__t__);exprr__t__ = (void *)expr_let(expr_lambda(expr_lambda(expr_if(expr_zero(expr_var((void *)0)),expr_const((void *)1),expr_mult(expr_var((void *)0),expr_app(expr_app(expr_var((void *)1),expr_var((void *)1)),expr_subr1(expr_var((void *)0))))))),expr_app(expr_app(expr_var((void *)0),expr_var((void *)0)),expr_const((void *)5)));
envr__t__ = (void *)envrr_empty();
pc = &valuer__m__ofr__m__cps;
mount_tram();
printf("Value of 5 factorial: %d\n", (int)vr__t__);}

void valuer__m__ofr__m__cps()
{
exp* _c = (exp*)exprr__t__;
switch (_c->tag) {
case _const_exp: {
void *n = _c->u._const._n;
vr__t__ = (void *)n;
pc = &applyr__m__kr__m__ds;
break; }
case _var_exp: {
void *v = _c->u._var._v;
numr__t__ = (void *)v;
pc = &applyr__m__env;
break; }
case _if_exp: {
void *test = _c->u._if._test;
void *conseq = _c->u._if._conseq;
void *alt = _c->u._if._alt;
kr__t__ = (void *)cntr_ifr__m__k(conseq,envr__t__,alt,kr__t__);
exprr__t__ = (void *)test;
pc = &valuer__m__ofr__m__cps;
break; }
case _mult_exp: {
void *randr1 = _c->u._mult._randr1;
void *randr2 = _c->u._mult._randr2;
kr__t__ = (void *)cntr_outerr__m__multr__m__k(randr2,envr__t__,kr__t__);
exprr__t__ = (void *)randr1;
pc = &valuer__m__ofr__m__cps;
break; }
case _subr1_exp: {
void *rand = _c->u._subr1._rand;
kr__t__ = (void *)cntr_subr1r__m__k(kr__t__);
exprr__t__ = (void *)rand;
pc = &valuer__m__ofr__m__cps;
break; }
case _zero_exp: {
void *rand = _c->u._zero._rand;
kr__t__ = (void *)cntr_zeror__m__k(kr__t__);
exprr__t__ = (void *)rand;
pc = &valuer__m__ofr__m__cps;
break; }
case _capture_exp: {
void *body = _c->u._capture._body;
exprr__t__ = (void *)body;
envr__t__ = (void *)envrr_extend(kr__t__,envr__t__);
pc = &valuer__m__ofr__m__cps;
break; }
case _return_exp: {
void *vexp = _c->u._return._vexp;
void *kexp = _c->u._return._kexp;
kr__t__ = (void *)cntr_returnr__m__k(vexp,envr__t__);
exprr__t__ = (void *)kexp;
pc = &valuer__m__ofr__m__cps;
break; }
case _let_exp: {
void *vexp = _c->u._let._vexp;
void *body = _c->u._let._body;
kr__t__ = (void *)cntr_letr__m__k(body,envr__t__,kr__t__);
exprr__t__ = (void *)vexp;
pc = &valuer__m__ofr__m__cps;
break; }
case _lambda_exp: {
void *body = _c->u._lambda._body;
vr__t__ = (void *)closr_closure(body,envr__t__);
pc = &applyr__m__kr__m__ds;
break; }
case _app_exp: {
void *rator = _c->u._app._rator;
void *rand = _c->u._app._rand;
kr__t__ = (void *)cntr_outerr__m__kr__m__ds(rand,envr__t__,kr__t__);
exprr__t__ = (void *)rator;
pc = &valuer__m__ofr__m__cps;
break; }
}
}

void applyr__m__closure()
{
clos* _c = (clos*)cr__t__;
switch (_c->tag) {
case _closure_clos: {
void *code = _c->u._closure._code;
void *env = _c->u._closure._env;
envr__t__ = (void *)envrr_extend(ar__t__,env);
exprr__t__ = (void *)code;
pc = &valuer__m__ofr__m__cps;
break; }
}
}

void applyr__m__env()
{
envr* _c = (envr*)envr__t__;
switch (_c->tag) {
case _empty_envr: {
fprintf(stderr, "unbound variable");
 exit(1);
break; }
case _extend_envr: {
void *arg = _c->u._extend._arg;
void *env = _c->u._extend._env;
if((numr__t__ == 0)) {
  vr__t__ = (void *)arg;
pc = &applyr__m__kr__m__ds;

} else {
  numr__t__ = (void *)(void *)((int)numr__t__ - 1);
envr__t__ = (void *)env;
pc = &applyr__m__env;

}
break; }
}
}

void applyr__m__kr__m__ds()
{
cnt* _c = (cnt*)kr__t__;
switch (_c->tag) {
case _emptyr__m__kr__m__ds_cnt: {
void *dismount = _c->u._emptyr__m__kr__m__ds._dismount;
_trstr *trstr = (_trstr *)dismount;
longjmp(*trstr->jmpbuf, 1);
break; }
case _innerr__m__kr__m__ds_cnt: {
void *closure = _c->u._innerr__m__kr__m__ds._closure;
void *kr__ex__ = _c->u._innerr__m__kr__m__ds._kr__ex__;
cr__t__ = (void *)closure;
ar__t__ = (void *)vr__t__;
kr__t__ = (void *)kr__ex__;
pc = &applyr__m__closure;
break; }
case _outerr__m__kr__m__ds_cnt: {
void *rand = _c->u._outerr__m__kr__m__ds._rand;
void *env = _c->u._outerr__m__kr__m__ds._env;
void *kr__ex__ = _c->u._outerr__m__kr__m__ds._kr__ex__;
kr__t__ = (void *)cntr_innerr__m__kr__m__ds(vr__t__,kr__ex__);
envr__t__ = (void *)env;
exprr__t__ = (void *)rand;
pc = &valuer__m__ofr__m__cps;
break; }
case _ifr__m__k_cnt: {
void *conseq = _c->u._ifr__m__k._conseq;
void *env = _c->u._ifr__m__k._env;
void *alt = _c->u._ifr__m__k._alt;
void *kr__ex__ = _c->u._ifr__m__k._kr__ex__;
if(vr__t__) {
  exprr__t__ = (void *)conseq;
kr__t__ = (void *)kr__ex__;
envr__t__ = (void *)env;
pc = &valuer__m__ofr__m__cps;

} else {
  exprr__t__ = (void *)alt;
kr__t__ = (void *)kr__ex__;
envr__t__ = (void *)env;
pc = &valuer__m__ofr__m__cps;

}
break; }
case _innerr__m__multr__m__k_cnt: {
void *xr1 = _c->u._innerr__m__multr__m__k._xr1;
void *kr__ex__ = _c->u._innerr__m__multr__m__k._kr__ex__;
kr__t__ = (void *)kr__ex__;
vr__t__ = (void *)(void *)((int)xr1 * (int)vr__t__);
pc = &applyr__m__kr__m__ds;
break; }
case _outerr__m__multr__m__k_cnt: {
void *randr2 = _c->u._outerr__m__multr__m__k._randr2;
void *env = _c->u._outerr__m__multr__m__k._env;
void *kr__ex__ = _c->u._outerr__m__multr__m__k._kr__ex__;
kr__t__ = (void *)cntr_innerr__m__multr__m__k(vr__t__,kr__ex__);
exprr__t__ = (void *)randr2;
envr__t__ = (void *)env;
pc = &valuer__m__ofr__m__cps;
break; }
case _subr1r__m__k_cnt: {
void *kr__ex__ = _c->u._subr1r__m__k._kr__ex__;
kr__t__ = (void *)kr__ex__;
vr__t__ = (void *)(void *)((int)vr__t__ - (int)(void *)1);
pc = &applyr__m__kr__m__ds;
break; }
case _zeror__m__k_cnt: {
void *kr__ex__ = _c->u._zeror__m__k._kr__ex__;
kr__t__ = (void *)kr__ex__;
vr__t__ = (void *)(vr__t__ == 0);
pc = &applyr__m__kr__m__ds;
break; }
case _returnr__m__k_cnt: {
void *vexp = _c->u._returnr__m__k._vexp;
void *env = _c->u._returnr__m__k._env;
exprr__t__ = (void *)vexp;
kr__t__ = (void *)vr__t__;
envr__t__ = (void *)env;
pc = &valuer__m__ofr__m__cps;
break; }
case _letr__m__k_cnt: {
void *body = _c->u._letr__m__k._body;
void *env = _c->u._letr__m__k._env;
void *kr__ex__ = _c->u._letr__m__k._kr__ex__;
exprr__t__ = (void *)body;
envr__t__ = (void *)envrr_extend(vr__t__,env);
kr__t__ = (void *)kr__ex__;
pc = &valuer__m__ofr__m__cps;
break; }
}
}

int mount_tram ()
{
srand (time (NULL));
jmp_buf jb;
_trstr trstr;
void *dismount;
int _status = setjmp(jb);
trstr.jmpbuf = &jb;
dismount = &trstr;
if(!_status) {
kr__t__= (void *)cntr_emptyr__m__kr__m__ds(dismount);
for(;;) {
pc();
}
}
return 0;
}
