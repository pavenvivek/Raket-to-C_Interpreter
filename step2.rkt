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
 
(define apply-k-fn
  (lambda(k v)
    (k v)))

(define inner-k-fn
  (lambda(closure k^)
    (lambda(v)
      (apply-closure closure v k^))))

(define outer-k-fn
  (lambda(rand env k^)
    (lambda(v)
      (value-of-cps rand env (inner-k-fn v k^)))))

(define if-k
  (lambda(conseq env alt k^)
    (lambda(v) (if v
	   (value-of-cps conseq env k^)
	   (value-of-cps alt env k^)))))

(define inner-mult-k
  (lambda(x1 k^)
    (lambda(v) (apply-k-fn k^ (* x1 v)))))

(define outer-mult-k
  (lambda(rand2 env k^)
    (lambda(v) (value-of-cps rand2 env (inner-mult-k v k^)))))

(define sub1-k
  (lambda(k^)
    (lambda(v) (apply-k-fn k^ (- v 1)))))

(define zero-k
  (lambda(k^)
    (lambda(v) (apply-k-fn k^ (zero? v)))))

(define return-k
  (lambda(vexp env)
    (lambda(v) (value-of-cps vexp env v))))

(define let-k
  (lambda(body env k^)
    (lambda(v) (let ((z v)) (value-of-cps body (envr_extend z env) k^)))))
  
(define value-of-cps
  (lambda (expr env k)
    (union-case expr exp
      [(const n) (apply-k-fn k n)]
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
      [(lambda body) (apply-k-fn k (clos_closure body env))]
      [(app rator rand)
       (value-of-cps rator env (outer-k-fn rand env k))])))

(define-union envr
  (empty)
  (extend arg env))
 
(define apply-env
  (lambda (env num k)
    (union-case env envr
      [(empty) (error 'env "unbound variable")]
      [(extend arg env)
       (if (zero? num)
	   (apply-k-fn k arg)
	   (apply-env env (sub1 num) k))])))
 
(define-union clos
  (closure code env))

(define empty-k
  (lambda()
    (lambda(v) v)))
 
(define apply-closure
  (lambda (c a k)
    (union-case c clos
      [(closure code env)
       (value-of-cps code (envr_extend a env) k)])))
