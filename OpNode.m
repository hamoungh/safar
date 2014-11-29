classdef OpNode < handle
% 	<Topology> 
% 		<Node CPUParallelism="1" CPURatio="1" DiskParallelism="1" DiskRatio="1" name="ClientHost" type="client"/>
    
    properties
        CPUParallelism=1 ;
        CPURatio=1;
        DiskParallelism=1;
        DiskRatio=1; 
        name='ClientHost' ;
        type='client'; 
        
        cpuUtilization = 0;
        diskUtilization = 0;
    end
    
    methods
        % OpNode('ClientHost','client',1,1)
        function obj=OpNode(name,type,CPUParallelism,DiskParallelism,varargin)
            obj.name=name;
            obj.type=type;
            obj.CPUParallelism=CPUParallelism;
            obj.DiskParallelism=DiskParallelism;
            nVarargs = length(varargin);
            if (nVarargs~=0)
                obj.CPURatio=varargin{1};
                obj.DiskRatio=varargin{2};
            end
        end
        
        function xml=render(obj,i,xml)
            xml.Topology.Node(i).ATTRIBUTE.CPUParallelism=num2str(obj.CPUParallelism);
            xml.Topology.Node(i).ATTRIBUTE.CPURatio=num2str(obj.CPURatio);
            xml.Topology.Node(i).ATTRIBUTE.DiskParallelism=num2str(obj.DiskParallelism);
            xml.Topology.Node(i).ATTRIBUTE.DiskRatio=num2str(obj.DiskRatio); 
            xml.Topology.Node(i).ATTRIBUTE.name=obj.name;
            xml.Topology.Node(i).ATTRIBUTE.type=obj.type; 
        end
    end
    
end

