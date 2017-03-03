#lang racket
(require "parenthec.rkt")
(require C311/pmatch)
 
(define-union exp
  (const n)
  (var v)
  (if test conseq alt)
  (mult rand1 rand2)
  (sub1 rand)
  (zero rand)
  (capture body)
  (return vexp kexp)
  (let vexp body)
  (lambda body)
  (app rator rand))
 
(define empty-k-ds
  (lambda()
    `(empty-k-ds)))

(define apply-k-ds
  (lambda(k v)
    (pmatch k
      (`(empty-k-ds) v)
      (`(inner-k-ds ,closure ,k^) (apply-closure closure v k^))
      (`(outer-k-ds ,rand ,env ,k^) (value-of-cps rand env (inner-k-ds v k^)))
      (`(if-k ,conseq ,env ,alt ,k^) (if v (value-of-cps conseq env k^) (value-of-cps alt env k^)))
      (`(inner-mult-k ,x1 ,k^) (apply-k-ds k^ (* x1 v)))
      (`(outer-mult-k ,rand2 ,env ,k^) (value-of-cps rand2 env (inner-mult-k v k^)))
      (`(sub1-k ,k^) (apply-k-ds k^ (- v 1)))
      (`(zero-k ,k^) (apply-k-ds k^ (zero? v)))
      (`(return-k ,vexp ,env) (value-of-cps vexp env v))
      (`(let-k ,body ,env ,k^) (value-of-cps body (envr_extend v env) k^))
      )))

(define inner-k-ds
  (lambda(closure k^)
    `(inner-k-ds ,closure ,k^)))

(define outer-k-ds
  (lambda(rand env k^)
    `(outer-k-ds ,rand ,env ,k^)))

(define if-k
  (lambda(conseq env alt k^)
    `(if-k ,conseq ,env ,alt ,k^)))

(define inner-mult-k
  (lambda(x1 k^)
    `(inner-mult-k ,x1 ,k^)))

(define outer-mult-k
  (lambda(rand2 env k^)
    `(outer-mult-k ,rand2 ,env ,k^)))

(define sub1-k
  (lambda(k^)
    `(sub1-k ,k^)))

(define zero-k
  (lambda(k^)
    `(zero-k ,k^)))

(define return-k
  (lambda(vexp env)
    `(return-k ,vexp ,env)))

(define let-k
  (lambda(body env k^)
    `(let-k ,body ,env ,k^)))
  
(define value-of-cps
  (lambda (expr env k)
    (union-case expr exp
      [(const n) (apply-k-ds k n)]
      [(var v) (apply-env env v k)]
      [(if test conseq alt)
       (value-of-cps test env (if-k conseq env alt k))]
      [(mult rand1 rand2) (value-of-cps rand1 env (outer-mult-k rand2 env k))]
      [(sub1 rand) (value-of-cps rand env (sub1-k k))]
      [(zero rand) (value-of-cps rand env (zero-k k))]
      [(capture body)
	  (value-of-cps body (envr_extend k env) k)]
      [(return vexp kexp)
       (value-of-cps kexp env (return-k vexp env))]
      [(let vexp body)
       (value-of-cps vexp env (let-k body env k))]
      [(lambda body) (apply-k-ds k (clos_closure body env))]
      [(app rator rand)
       (value-of-cps rator env (outer-k-ds rand env k))])))

(define-union envr
  (empty)
  (extend arg env))
 
(define apply-env
  (lambda (env num k)
    (union-case env envr
      [(empty) (error 'env "unbound variable")]
      [(extend arg env)
       (if (zero? num)
	   (apply-k-ds k arg)
	   (apply-env env (sub1 num) k))])))
 
(define-union clos
  (closure code env))
 
(define apply-closure
  (lambda (c a k)
    (union-case c clos
      [(closure code env)
       (value-of-cps code (envr_extend a env) k)])))

#|
> (pretty-print
 (value-of-cps (exp_app
	    (exp_lambda
	     (exp_app
	      (exp_app (exp_var 0) (exp_var 0))
	      (exp_const 5)))
	    (exp_lambda
	     (exp_lambda
	      (exp_if (exp_zero (exp_var 0))
		      (exp_const 1)
		      (exp_mult (exp_var 0)
				(exp_app
				 (exp_app (exp_var 1) (exp_var 1))
				 (exp_sub1 (exp_var 0))))))))
	   (envr_empty) (empty-k-ds)))
120
> 
|#
