classdef OpCluster < handle
    %UNTITLED9 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name='ClientCluster';
    	containers=[];
    end
    
    methods
        function obj=OpCluster(name,containers)
            obj.name=name; 
            obj.containers=containers; 
        end
        
        function xml=render(obj,i,xml)
            xml.Topology.Cluster(i).ATTRIBUTE.name= obj.name;
            for j=1:length(obj.containers)
                xml=obj.containers(j).render(i,j,xml);
            end
        end
        
    end    
end

