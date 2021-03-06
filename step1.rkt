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
 
(define value-of-cps
  (lambda (expr env k)
    (union-case expr exp
      [(const n) (k n)]
      [(var v) (apply-env env v k)]
      [(if test conseq alt)
       (value-of-cps test env (lambda(x) (if x
	   (value-of-cps conseq env k)
	   (value-of-cps alt env k))))]
      [(mult rand1 rand2) (value-of-cps rand1 env (lambda(x1) (value-of-cps rand2 env (lambda(x2) (k (* x1 x2))))))]
      [(sub1 rand) (value-of-cps rand env (lambda(x) (k (- x 1))))]
      [(zero rand) (value-of-cps rand env (lambda(x) (k (zero? x))))]
      [(capture body)
	  (value-of-cps body (envr_extend k env) k)]
      [(return vexp kexp)
       (value-of-cps kexp env (lambda(k^) (value-of-cps vexp env k^)))]
      [(let vexp body)
       (value-of-cps vexp env (lambda(x) (let ((v x)) (value-of-cps body (envr_extend v env) k))))]
      [(lambda body) (k (clos_closure body env))]
      [(app rator rand)
       (value-of-cps rator env (lambda(closure) (value-of-cps rand env (lambda(arg) (apply-closure closure arg k)))))])))

(define-union envr
  (empty)
  (extend arg env))
 
(define apply-env
  (lambda (env num k)
    (union-case env envr
      [(empty) (error 'env "unbound variable")]
      [(extend arg env)
       (if (zero? num)
	   (k arg)
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
	   (envr_empty) (empty-k)))
120
> (pretty-print
 (value-of-cps
  (exp_mult (exp_const 2)
	    (exp_capture
	     (exp_mult (exp_const 5)
		       (exp_return (exp_mult (exp_const 2) (exp_const 6))
                                   (exp_var 0)))))
  (envr_empty) (empty-k))) 
24
> |#
