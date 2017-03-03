#lang racket
(require "parenthec.rkt")
 
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
 
(define-union cnt
  (empty-k-ds)
  (inner-k-ds closure k^)
  (outer-k-ds rand env k^)
  (if-k conseq env alt k^)
  (inner-mult-k x1 k^)
  (outer-mult-k rand2 env k^)
  (sub1-k k^)
  (zero-k k^)
  (return-k vexp env)
  (let-k body env k^))

#|
(define empty-k-ds
  (lambda()
    `(empty-k-ds)))
|#
(define apply-k-ds
  (lambda(k v)
    (union-case k cnt
      ((empty-k-ds) v)
      ((inner-k-ds closure k^) (apply-closure closure v k^))
      ((outer-k-ds rand env k^) (value-of-cps rand env (cnt_inner-k-ds v k^)))
      ((if-k conseq env alt k^) (if v (value-of-cps conseq env k^) (value-of-cps alt env k^)))
      ((inner-mult-k x1 k^) (apply-k-ds k^ (* x1 v)))
      ((outer-mult-k rand2 env k^) (value-of-cps rand2 env (cnt_inner-mult-k v k^)))
      ((sub1-k k^) (apply-k-ds k^ (- v 1)))
      ((zero-k k^) (apply-k-ds k^ (zero? v)))
      ((return-k vexp env) (value-of-cps vexp env v))
      ((let-k body env k^) (value-of-cps body (envr_extend v env) k^))
      )))

#|(define inner-k-ds
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
    `(let-k ,body ,env ,k^)))|#
  
(define value-of-cps
  (lambda (expr env k)
    (union-case expr exp
      [(const n) (apply-k-ds k n)]
      [(var v) (apply-env env v k)]
      [(if test conseq alt)
       (value-of-cps test env (cnt_if-k conseq env alt k))]
      [(mult rand1 rand2) (value-of-cps rand1 env (cnt_outer-mult-k rand2 env k))]
      [(sub1 rand) (value-of-cps rand env (cnt_sub1-k k))]
      [(zero rand) (value-of-cps rand env (cnt_zero-k k))]
      [(capture body)
	  (value-of-cps body (envr_extend k env) k)]
      [(return vexp kexp)
       (value-of-cps kexp env (cnt_return-k vexp env))]
      [(let vexp body)
       (value-of-cps vexp env (cnt_let-k body env k))]
      [(lambda body) (apply-k-ds k (clos_closure body env))]
      [(app rator rand)
       (value-of-cps rator env (cnt_outer-k-ds rand env k))])))

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
