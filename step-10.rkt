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
  (empty-k-ds dismount)
  (inner-k-ds closure k^)
  (outer-k-ds rand env k^)
  (if-k conseq env alt k^)
  (inner-mult-k x1 k^)
  (outer-mult-k rand2 env k^)
  (sub1-k k^)
  (zero-k k^)
  (return-k vexp env)
  (let-k body env k^))

(define-union envr
  (empty)
  (extend arg env))

(define-union clos
  (closure code env))

(define-label apply-k-ds
    (union-case k* cnt
      ((empty-k-ds dismount) (dismount-trampoline dismount))
      ((inner-k-ds closure k^) 
        (begin
          (set! c* closure)
          (set! a* v*)
          (set! k* k^)
          (set! pc apply-closure)))
      ((outer-k-ds rand env k^) 
        (begin
          (set! k* (cnt_inner-k-ds v* k^))
          (set! env* env)
          (set! expr* rand)
          (set! pc value-of-cps)))
      ((if-k conseq env alt k^) 
        (if v* 
          (begin
            (set! expr* conseq)
            (set! k* k^)
            (set! env* env)
            (set! pc value-of-cps)) 
          (begin
            (set! expr* alt)
            (set! k* k^)
            (set! env* env)
            (set! pc value-of-cps))))
      ((inner-mult-k x1 k^) 
        (begin
          (set! k* k^)
          (set! v* (* x1 v*))
          (set! pc apply-k-ds)))
      ((outer-mult-k rand2 env k^) 
        (begin
          (set! k* (cnt_inner-mult-k v* k^))
          (set! expr* rand2)
          (set! env* env)
          (set! pc value-of-cps)))
      ((sub1-k k^) 
        (begin
          (set! k* k^)
          (set! v* (- v* 1))
          (set! pc apply-k-ds)))
      ((zero-k k^) 
        (begin
          (set! k* k^)
          (set! v* (zero? v*))
          (set! pc apply-k-ds)))
      ((return-k vexp env)
        (begin
          (set! expr* vexp)
          (set! k* v*)
          (set! env* env)
          (set! pc value-of-cps)))
      ((let-k body env k^)  
        (begin
          (set! expr* body)
          (set! env* (envr_extend v* env))
          (set! k* k^)
          (set! pc value-of-cps)))
      ))
  
(define-label apply-env
    (union-case env* envr
      [(empty) (error 'env* "unbound variable")]
      [(extend arg env)
        (if (zero? num*)
          (begin
            (set! v* arg)
	    (set! pc apply-k-ds))
          (begin
            (set! num* (sub1 num*))
            (set! env* env)
            (set! pc apply-env)))]))
  
(define-label apply-closure
    (union-case c* clos
      [(closure code env)
        (begin
          (set! env* (envr_extend a* env))
          (set! expr* code)
          (set! pc value-of-cps))]))

(define-label value-of-cps
    (union-case expr* exp
      [(const n)
        (begin
          (set! v* n)
          (set! pc apply-k-ds))]
      [(var v) 
        (begin
          (set! num* v)
          (set! pc apply-env))]
      [(if test conseq alt)
        (begin
          (set! k* (cnt_if-k conseq env* alt k*))
          (set! expr* test)
          (set! pc value-of-cps))]
      [(mult rand1 rand2)
        (begin
          (set! k* (cnt_outer-mult-k rand2 env* k*))
          (set! expr* rand1)
          (set! pc value-of-cps))]
      [(sub1 rand)
        (begin
          (set! k* (cnt_sub1-k k*))
          (set! expr* rand)
          (set! pc value-of-cps))]
      [(zero rand) 
        (begin
          (set! k* (cnt_zero-k k*))
          (set! expr* rand)
          (set! pc value-of-cps))]
      [(capture body)
        (begin
          (set! expr* body)
          (set! env* (envr_extend k* env*))
	  (set! pc value-of-cps))]
      [(return vexp kexp)
        (begin
          (set! k* (cnt_return-k vexp env*))
          (set! expr* kexp)
          (set! pc value-of-cps))]
      [(let vexp body)
        (begin
          (set! k* (cnt_let-k body env* k*))
          (set! expr* vexp)
          (set! pc value-of-cps))]
      [(lambda body) 
        (begin
          (set! v* (clos_closure body env*))
          (set! pc apply-k-ds))]
      [(app rator rand)
        (begin
          (set! k* (cnt_outer-k-ds rand env* k*))
          (set! expr* rator)
          (set! pc value-of-cps))]))
 
(define-label main
    (begin
      (set! expr* (exp_app
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
 		  (exp_sub1 (exp_var 0)))))))))
      (set! env* (envr_empty))
      (set! pc value-of-cps)
      (mount-trampoline cnt_empty-k-ds k* pc)
      (printf "Factorial of 5: ~s\n" v*)
      
      (set! expr* (exp_app
                  (exp_app
                  (exp_lambda (exp_lambda (exp_var 1)))
                  (exp_const 5))
                  (exp_const 6)))
      (set! env* (envr_empty))
      (set! pc value-of-cps)
      (mount-trampoline cnt_empty-k-ds k* pc)
      (printf "Value of expression: ~s\n" v*)
      
      (set! expr* (exp_mult (exp_const 2)
	          (exp_capture
	          (exp_mult (exp_const 5)
		  (exp_return (exp_mult (exp_const 2) (exp_const 6))
                  (exp_var 0))))))
      (set! env* (envr_empty))
      (set! pc value-of-cps)
      (mount-trampoline cnt_empty-k-ds k* pc)
      (printf "Capture and Return evaluation result: ~s\n" v*)

      (set! expr* (exp_let
	          (exp_lambda
	          (exp_lambda
	          (exp_if
	          (exp_zero (exp_var 0))
	          (exp_const 1)
	          (exp_mult
		  (exp_var 0)
		  (exp_app
		  (exp_app (exp_var 1) (exp_var 1))
		  (exp_sub1 (exp_var 0)))))))
	          (exp_app (exp_app (exp_var 0) (exp_var 0)) (exp_const 5))))
      (set! env* (envr_empty))
      (set! pc value-of-cps)
      (mount-trampoline cnt_empty-k-ds k* pc)
      (printf "Value of 5 factorial: ~s\n" v*)
      ))
