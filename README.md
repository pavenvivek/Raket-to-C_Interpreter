# Raket-to-C_Interpreter
Converting a Racket interpreter to C using ParenthC interpreter

The Racket interpreter is translated into new state by the following three transformations:
-------------------------------------------------------------------------------------------
1] Continuation passing style  
2] Registerization  
3] Trampolining  

After the above transformations, the Racket interpreter is translated to C interpreter using ParenthC interpreter.

Steps to Execute:
-----------------
(require "pc2c.rkt")  
(pc2c "interp.pc" "interp.c" "interp.h")  
