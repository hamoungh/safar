classdef OpWorkload
% 	<Workloads kind="HL">
% 		<Users>0</Users>
% 		<WorkloadMixes openModel="false">
% 			<Mix load="100" scenario="select 0"/>
% 		</WorkloadMixes>
% 		<ThinkTimes>
% 			<ThinkTime scenario="select 0" time="0"/>
% 		</ThinkTimes>
% 	</Workloads>
    
    properties
        kind='HL';
		totUsers=0;
        openModel='false';
        scWorkloads=[]; %{'brows',ClosedWorkload(12,1)}
                                   % containers.Map({'browse'},{OpClosedWorkload(80,0.1)})
    end
    
    methods
        function obj=OpWorkload(totUsers,scWorkloads)
            obj.totUsers=totUsers;
            obj.scWorkloads =  scWorkloads; 
        end
        
        function xml=render(obj,xml)
            xml.Workloads.ATTRIBUTE.kind=obj.kind;
            xml.Workloads.Users=num2str(obj.totUsers); 
            xml.Workloads.WorkloadMixes.ATTRIBUTE.openModel='false'; 
                     
            i=1;
            for k=obj.scWorkloads.keys
                xml.Workloads.WorkloadMixes.Mix(i).ATTRIBUTE.load=num2str(obj.scWorkloads(k{1}).n);
                xml.Workloads.WorkloadMixes.Mix(i).ATTRIBUTE.scenario=k{1};
                i=i+1;
            end      
            
            i=1;
            for k=obj.scWorkloads.keys
                xml.Workloads.ThinkTimes.ThinkTime(i).ATTRIBUTE.scenario=k{1};
                xml.Workloads.ThinkTimes.ThinkTime(i).ATTRIBUTE.time=num2str(obj.scWorkloads(k{1}).tt);
                i=i+1;
            end
        end
    end
    
end

