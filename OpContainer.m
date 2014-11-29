classdef OpContainer < handle
    %UNTITLED10 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        canMigrate='false';
        name='Client';
        parallelism='1000';
 		runsOnNode='ClientHost' ;
        server='false';   
        utilization=0;
    end
    
    methods
        % OpContainer( 'Client', 1000, 'ClientHost', 'false' )
        function obj=OpContainer( name, parallelism, runsOnNode, server)
            obj.name=name;
            obj.parallelism=parallelism;
            obj.runsOnNode=runsOnNode; 
            obj.server=server;
        end
        
        function xml=render(obj,i,j,xml)
                    xml.Topology.Cluster(i).Container(j).ATTRIBUTE.canMigrate=obj.canMigrate;
                    xml.Topology.Cluster(i).Container(j).ATTRIBUTE.name=obj.name;
                    xml.Topology.Cluster(i).Container(j).ATTRIBUTE.parallelism=num2str(obj.parallelism); 
                    xml.Topology.Cluster(i).Container(j).ATTRIBUTE.runsOnNode=obj.runsOnNode;
                    xml.Topology.Cluster(i).Container(j).ATTRIBUTE.server=obj.server; 
        end
    end
    
end

