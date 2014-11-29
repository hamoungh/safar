classdef OpNetwork
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        connectsNodes=[];
    end
    
    methods
            function obj=OpNetwork(connectsNodes)                
                obj.connectsNodes=connectsNodes; 
            end
        
            function xml=render(obj,i,xml)
               xml.Topology.Network(i).ATTRIBUTE.connectsNodes=obj.connectsNodes; 
                xml.Topology.Network(i).ATTRIBUTE.latency='0'; 
                xml.Topology.Network(i).ATTRIBUTE.name='Internet'; 
                xml.Topology.Network(i).ATTRIBUTE.overheadPerByte='0'; 
            end
    end
    
end

