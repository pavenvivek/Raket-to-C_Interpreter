void *kr__t__, *vr__t__, *exprr__t__, *envr__t__, *cr__t__, *ar__t__, *numr__t__;

void (*pc)();

struct exp;
typedef struct exp exp;
struct exp {
  enum {
    _const_exp,
    _var_exp,
    _if_exp,
    _mult_exp,
    _subr1_exp,
    _zero_exp,
    _capture_exp,
    _return_exp,
    _let_exp,
    _lambda_exp,
    _app_exp
  } tag;
  union {
    struct { void *_n; } _const;
    struct { void *_v; } _var;
    struct { void *_test; void *_conseq; void *_alt; } _if;
    struct { void *_randr1; void *_randr2; } _mult;
    struct { void *_rand; } _subr1;
    struct { void *_rand; } _zero;
    struct { void *_body; } _capture;
    struct { void *_vexp; void *_kexp; } _return;
    struct { void *_vexp; void *_body; } _let;
    struct { void *_body; } _lambda;
    struct { void *_rator; void *_rand; } _app;
  } u;
};

void *expr_const(void *n);
void *expr_var(void *v);
void *expr_if(void *test, void *conseq, void *alt);
void *expr_mult(void *randr1, void *randr2);
void *expr_subr1(void *rand);
void *expr_zero(void *rand);
void *expr_capture(void *body);
void *expr_return(void *vexp, void *kexp);
void *expr_let(void *vexp, void *body);
void *expr_lambda(void *body);
void *expr_app(void *rator, void *rand);

struct cnt;
typedef struct cnt cnt;
struct cnt {
  enum {
    _emptyr__m__kr__m__ds_cnt,
    _innerr__m__kr__m__ds_cnt,
    _outerr__m__kr__m__ds_cnt,
    _ifr__m__k_cnt,
    _innerr__m__multr__m__k_cnt,
    _outerr__m__multr__m__k_cnt,
    _subr1r__m__k_cnt,
    _zeror__m__k_cnt,
    _returnr__m__k_cnt,
    _letr__m__k_cnt
  } tag;
  union {
    struct { void *_dismount; } _emptyr__m__kr__m__ds;
    struct { void *_closure; void *_kr__ex__; } _innerr__m__kr__m__ds;
    struct { void *_rand; void *_env; void *_kr__ex__; } _outerr__m__kr__m__ds;
    struct { void *_conseq; void *_env; void *_alt; void *_kr__ex__; } _ifr__m__k;
    struct { void *_xr1; void *_kr__ex__; } _innerr__m__multr__m__k;
    struct { void *_randr2; void *_env; void *_kr__ex__; } _outerr__m__multr__m__k;
    struct { void *_kr__ex__; } _subr1r__m__k;
    struct { void *_kr__ex__; } _zeror__m__k;
    struct { void *_vexp; void *_env; } _returnr__m__k;
    struct { void *_body; void *_env; void *_kr__ex__; } _letr__m__k;
  } u;
};

void *cntr_emptyr__m__kr__m__ds(void *dismount);
void *cntr_innerr__m__kr__m__ds(void *closure, void *kr__ex__);
void *cntr_outerr__m__kr__m__ds(void *rand, void *env, void *kr__ex__);
void *cntr_ifr__m__k(void *conseq, void *env, void *alt, void *kr__ex__);
void *cntr_innerr__m__multr__m__k(void *xr1, void *kr__ex__);
void *cntr_outerr__m__multr__m__k(void *randr2, void *env, void *kr__ex__);
void *cntr_subr1r__m__k(void *kr__ex__);
void *cntr_zeror__m__k(void *kr__ex__);
void *cntr_returnr__m__k(void *vexp, void *env);
void *cntr_letr__m__k(void *body, void *env, void *kr__ex__);

struct envr;
typedef struct envr envr;
struct envr {
  enum {
    _empty_envr,
    _extend_envr
  } tag;
  union {
    struct { char dummy; } _empty;
    struct { void *_arg; void *_env; } _extend;
  } u;
};

void *envrr_empty();
void *envrr_extend(void *arg, void *env);

struct clos;
typedef struct clos clos;
struct clos {
  enum {
    _closure_clos
  } tag;
  union {
    struct { void *_code; void *_env; } _closure;
  } u;
};

void *closr_closure(void *code, void *env);

void applyr__m__kr__m__ds();
void applyr__m__env();
void applyr__m__closure();
void valuer__m__ofr__m__cps();
int main();
int mount_tram();

struct _trstr;
typedef struct _trstr _trstr;
struct _trstr {
  jmp_buf *jmpbuf;
  int value;
};

