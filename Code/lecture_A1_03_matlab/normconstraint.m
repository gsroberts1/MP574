function [constraintIneq,constraintEq] =  normconstraint(x,c)

constraintIneq = norm(x)^2 - c;
constraintEq = [];