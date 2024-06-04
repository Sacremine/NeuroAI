This branch contains the matlab files for producing a conductance-based model of hippocampal sharp wave ripple, which includes activity from CA3, CA1, and DG regions.
June 06 2024, Karim Ghabra

Plan:

1. Create a function, called dynamic_system, which takes as input a matrix of neuronal connections (with 1s and -1s indicating excitatory and inhibitory connections)
        the output of dynamic_system should be a matrix which describes the differential equations of the whole system.

  function M = dynamic_system(pars,connections)
    % pars represents the parameter values the differential matrix, M, will be populated with
    % connections represents the matrix that designates the connections in our network.
        % for a 3 x 3 connections matrix, matrix M should be 15 x 15 (since each neuron will have 5 state variables)

2. Create a function which takes in the matrix describing the differential equations and calls on ode45 using arrayfun OR uses euler's method to integrate the matrix given a set of initial conditions
