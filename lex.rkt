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
 
(define value-of
  (lambda (expr env)
    (union-case expr exp
      [(const n) n]
      [(var v) (apply-env env v)]
      [(if test conseq alt)
       (if (value-of test env)
	   (value-of conseq env)
	   (value-of alt env))]
      [(mult rand1 rand2) (* (value-of rand1 env) (value-of rand2 env))]
      [(sub1 rand) (- (value-of rand env) 1)]
      [(zero rand) (zero? (value-of rand env))]
      [(capture body)
       (call/cc
	(lambda (k)
	  (value-of body (envr_extend k env))))]
      [(return vexp kexp)
       ((value-of kexp env) (value-of vexp env))]
      [(let vexp body)
       (let ((v (value-of vexp env)))
         (value-of body (envr_extend v env)))]
      [(lambda body) (clos_closure body env)]
      [(app rator rand)
       (apply-closure (value-of rator env) (value-of rand env))])))
 
(define-union envr
  (empty)
  (extend arg env))
 
(define apply-env
  (lambda (env num)
    (union-case env envr
      [(empty) (error 'env "unbound variable")]
      [(extend arg env)
       (if (zero? num)
	   arg
	   (apply-env env (sub1 num)))])))
 
(define-union clos
  (closure code env))
 
(define apply-closure
  (lambda (c a)
    (union-case c clos
      [(closure code env)
       (value-of code (envr_extend a env))])))
