classdef Neuron
    %NEURON This will be the object which we instantiate to model the units
    %in the neuron circuit.
    %   Detailed explanation goes here, or maybe do it in Java
    
    properties
        static
    end
    
    methods
        function obj = Neuron(inputArg1,inputArg2)
            %NEURON Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

