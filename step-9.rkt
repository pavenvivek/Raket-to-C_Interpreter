#lang racket
(require "parenthec.rkt")
(require C311/pmatch)

(define-registers k* v* expr* env* c* a* num*)
(define-program-counter pc)

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

(define-label apply-k-ds
    (union-case k* cnt
      ((empty-k-ds) v*)
      ((inner-k-ds closure k^) 
       (begin
         (set! c* closure)
         (set! a* v*)
         (set! k* k^)
         (apply-closure)))
      ((outer-k-ds rand env k^) 
         (begin
           (set! k* (cnt_inner-k-ds v* k^))
           (set! env* env)
           (set! expr* rand)
           (value-of-cps)))
      ((if-k conseq env alt k^) 
       (if v* 
           (begin
             (set! expr* conseq)
             (set! k* k^)
             (set! env* env)
             (value-of-cps)) 
           (begin
             (set! expr* alt)
             (set! k* k^)
             (set! env* env)
             (value-of-cps))))
      ((inner-mult-k x1 k^) 
         (begin
           (set! k* k^)
           (set! v* (* x1 v*))
           (apply-k-ds)))
      ((outer-mult-k rand2 env k^) 
         (begin
           (set! k* (cnt_inner-mult-k v* k^))
           (set! expr* rand2)
           (set! env* env)
           (value-of-cps)))
      ((sub1-k k^) 
         (begin
           (set! k* k^)
           (set! v* (- v* 1))
           (apply-k-ds)))
      ((zero-k k^) 
         (begin
           (set! k* k^)
           (set! v* (zero? v*))
           (apply-k-ds)))
      ((return-k vexp env)
         (begin
           (set! expr* vexp)
           (set! k* v*)
           (set! env* env)
           (value-of-cps)))
      ((let-k body env k^) 
         (let ((z v*)) 
           (begin
             (set! expr* body)
             (set! env* (envr_extend z env))
             (set! k* k^)
             (value-of-cps))))
      ))
  
(define-label value-of-cps
    (union-case expr* exp
      [(const n)
         (begin
           (set! v* n)
           (apply-k-ds))]
      [(var v) 
         (begin
           (set! num* v)
           (apply-env))]
      [(if test conseq alt)
       (begin
         (set! k* (cnt_if-k conseq env* alt k*))
         (set! expr* test)
         (value-of-cps))]
      [(mult rand1 rand2)
         (begin
           (set! k* (cnt_outer-mult-k rand2 env* k*))
           (set! expr* rand1)
           (value-of-cps))]
      [(sub1 rand)
         (begin
           (set! k* (cnt_sub1-k k*))
           (set! expr* rand)
           (value-of-cps))]
      [(zero rand) 
         (begin
           (set! k* (cnt_zero-k k*))
           (set! expr* rand)
           (value-of-cps))]
      [(capture body)
         (begin
           (set! expr* body)
           (set! env* (envr_extend k* env*))
	   (value-of-cps))]
      [(return vexp kexp)
         (begin
           (set! k* (cnt_return-k vexp env*))
           (set! expr* kexp)
           (value-of-cps))]
      [(let vexp body)
         (begin
           (set! k* (cnt_let-k body env* k*))
           (set! expr* vexp)
           (value-of-cps))]
      [(lambda body) 
         (begin
           (set! v* (clos_closure body env*))
           (apply-k-ds))]
      [(app rator rand)
       (begin
         (set! k* (cnt_outer-k-ds rand env* k*))
         (set! expr* rator)
         (value-of-cps))]))

(define-union envr
  (empty)
  (extend arg env))
 
(define-label apply-env
    (union-case env* envr
      [(empty)
         (begin
           (set! v* (error 'env* "unbound variable"))
           (apply-k-ds))]
      [(extend arg env)
       (if (zero? num*)
           (begin
             (set! v* arg)
	     (apply-k-ds))
           (begin
             (set! num* (sub1 num*))
             (set! env* env)
	     (apply-env)))]))
 
(define-union clos
  (closure code env))
 
(define-label apply-closure
    (union-case c* clos
      [(closure code env)
         (begin
           (set! env* (envr_extend a* env))
           (set! expr* code)
           (value-of-cps))]))

(define-label main
    (begin
      (set! k* (cnt_empty-k-ds))
      (set! expr* (exp_app
                    (exp_app
                      (exp_lambda (exp_lambda (exp_var 1)))
                        (exp_const 5))
                    (exp_const 6)))
      (set! env* (envr_empty))
      (value-of-cps)))
