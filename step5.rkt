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

(define-union envr
  (empty)
  (extend arg env))

(define-union clos
  (closure code env))

(define apply-k-ds
  (lambda(k v)
    (union-case k cnt
      ((empty-k-ds) v)
      ((inner-k-ds closure k^) 
        (let* ((c closure)
               (a v)
               (k k^))
              (apply-closure c a k)))
      ((outer-k-ds rand env k^) 
        (let* ((k (cnt_inner-k-ds v k^))
               (expr rand))
              (value-of-cps expr env k)))
      ((if-k conseq env alt k^) 
        (if v 
          (let* ((k k^)
                 (expr conseq))
                (value-of-cps expr env k))
          (let* ((k k^)
                 (expr alt))
                (value-of-cps expr env k))))
      ((inner-mult-k x1 k^) 
        (let* ((k k^)
               (v (* x1 v)))
              (apply-k-ds k v)))
      ((outer-mult-k rand2 env k^) 
        (let* ((k (cnt_inner-mult-k v k^))
               (expr rand2))
              (value-of-cps expr env k)))
      ((sub1-k k^) 
        (let* ((k k^)
               (v (- v 1)))
              (apply-k-ds k v)))
      ((zero-k k^) 
        (let* ((k k^)
               (v (zero? v)))
              (apply-k-ds k v)))
      ((return-k vexp env) 
        (let* ((k v)
               (expr vexp))
              (value-of-cps expr env k)))
      ((let-k body env k^) 
        (let* ((k k^)
               (env (envr_extend v env))
               (expr body))
              (value-of-cps expr env k)))
      )))

(define apply-env
  (lambda (env num k)
    (union-case env envr
      [(empty) (error 'env "unbound variable")]
      [(extend arg env)
       (if (zero? num)
	   (let* ((v arg))
                 (apply-k-ds k v))
	   (let* ((num (sub1 num)))
                 (apply-env env num k)))])))
  
(define apply-closure
  (lambda (c a k)
    (union-case c clos
      [(closure code env)
       (let* ((env (envr_extend a env))
              (expr code))
             (value-of-cps expr env k))])))

(define value-of-cps
  (lambda (expr env k)
    (union-case expr exp
      [(const n) 
        (let* ((v n))
              (apply-k-ds k v))]
      [(var v) 
        (let* ((num v))
              (apply-env env num k))]
      [(if test conseq alt)
        (let* ((k (cnt_if-k conseq env alt k))
               (expr test))
              (value-of-cps expr env k))]
      [(mult rand1 rand2) 
        (let* ((k (cnt_outer-mult-k rand2 env k))
               (expr rand1))
              (value-of-cps expr env k))]
      [(sub1 rand) 
        (let* ((k (cnt_sub1-k k))
               (expr rand))
              (value-of-cps expr env k))]
      [(zero rand) 
        (let* ((k (cnt_zero-k k))
               (expr rand))
              (value-of-cps expr env k))]
      [(capture body)
	(let* ((env (envr_extend k env))
               (expr body))
              (value-of-cps expr env k))]
      [(return vexp kexp)
        (let* ((k (cnt_return-k vexp env))
               (expr kexp))
              (value-of-cps expr env k))]
      [(let vexp body)
        (let* ((k (cnt_let-k body env k))
               (expr vexp))
              (value-of-cps expr env k))]
      [(lambda body) 
        (let* ((v (clos_closure body env)))
              (apply-k-ds k v))]
      [(app rator rand)
        (let* ((k (cnt_outer-k-ds rand env k))
               (expr rator))
              (value-of-cps expr env k))])))

(let* ((k (cnt_empty-k-ds))
       (expr (exp_app
             (exp_app
             (exp_lambda (exp_lambda (exp_var 1)))
             (exp_const 5))
             (exp_const 6)))
       (env (envr_empty)))
      (value-of-cps expr env k))


(let* ((k (cnt_empty-k-ds))
       (expr (exp_app
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
       (env (envr_empty)))
      (value-of-cps expr env k))

(let* ((k (cnt_empty-k-ds))
       (expr (exp_mult (exp_const 2)
	     (exp_capture
	     (exp_mult (exp_const 5)
		       (exp_return (exp_mult (exp_const 2) (exp_const 6))
                                   (exp_var 0))))))
       (env (envr_empty)))
      (value-of-cps expr env k))

(let* ((k (cnt_empty-k-ds))
       (expr (exp_let
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
       (env (envr_empty)))
      (value-of-cps expr env k))
