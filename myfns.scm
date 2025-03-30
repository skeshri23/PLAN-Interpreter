

;; The recursive functions to evaluate PLAN expressions according to grammar
(define (eval-plan expr bindings)
  (cond
    ;; Case: Constant
    ((integer? expr) expr)

    ;; Case: Identifier
    ((symbol? expr)
     (let ((binding (assoc expr bindings)))
       (if binding
           (cdr binding)
           (begin
             (display "Error: Unbound identifier: ") (display expr) (newline)
             #f)))) ;; Return #f for unbound identifier

    ;; Case: Expressions
    ((pair? expr)
     (let ((op (car expr))
           (args (cdr expr)))
       (cond
         ;; (planAdd ⟨Expr⟩ ⟨Expr⟩)
         ((equal? op 'planAdd)
          (+ (eval-plan (car args) bindings)
             (eval-plan (cadr args) bindings)))

         ;; (planSub ⟨Expr⟩ ⟨Expr⟩)
         ((equal? op 'planSub)
          (- (eval-plan (car args) bindings)
             (eval-plan (cadr args) bindings)))

         ;; (planMul ⟨Expr⟩ ⟨Expr⟩)
         ((equal? op 'planMul)
          (* (eval-plan (car args) bindings)
             (eval-plan (cadr args) bindings)))

         ;; (planIf ⟨Expr⟩ ⟨Expr⟩ ⟨Expr⟩)
         ((equal? op 'planIf)
          (if (> (eval-plan (car args) bindings) 0)
              (eval-plan (cadr args) bindings)
              (eval-plan (caddr args) bindings)))

         ;; (planLet ⟨Id⟩ ⟨Expr⟩1 ⟨Expr⟩2)
         ((equal? op 'planLet)
          (let ((id (car args))
                (val (eval-plan (cadr args) bindings))
                (body (caddr args)))
            (eval-plan body (cons (cons id val) bindings))))

         ;; (planLet ⟨Id⟩ ⟨Function⟩ ⟨Expr⟩)
         ((and (equal? op 'planLet)
               (pair? (cadr args))
               (equal? (car (cadr args)) 'planFunction))
          (let ((id (car args))
                (func (cadr args)) ;; The function definition
                (body (caddr args)))
            (eval-plan body (cons (cons id func) bindings))))

         ;; (planFunction ⟨Id⟩ ⟨Expr⟩)
         ((equal? op 'planFunction)
          `(planFunction ,(car args) ,(cadr args)))

         ;; Function Call: (⟨Id⟩ ⟨Expr⟩)
         ((symbol? op)
          (let ((binding (assoc op bindings)))
            (if (and binding (pair? (cdr binding)) (equal? (car (cdr binding)) 'planFunction))
                (let ((param (cadr (cdr binding)))  ;; Function parameter
                      (func-body (caddr (cdr binding))) ;; Function body
                      (arg (car args))) ;; Argument passed in the call
                  (eval-plan func-body (cons (cons param (eval-plan arg bindings)) bindings)))
                (begin
                  (display "Error: Unknown operation or invalid function: ") (display op) (newline)
                  #f))))

         ;; Unknown operation
         (else
          (display "Error: Unknown operation: ") (display op) (newline)
          #f)))) ;; Return #f for unknown operation

    ;; Error: Invalid input
    (else
     (display "Error: Invalid expression: ") (display expr) (newline)
     #f))) ;; Return #f for invalid input

;; The main function to evaluate the program
(define (plan program)
  (let ((expr (cadr program))) ;; Extract the ⟨Expr⟩ from (planProg ⟨Expr⟩)
    (eval-plan expr '())))    ;; Evaluate with an empty bindings list
