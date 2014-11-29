classdef OpScenario < handle
% 		<Scenario name="select 0" triggeredByService="Browser">
% 			<Call bytesReceived="0" bytesSent="0" callee="WebServer" caller="Browser" invocations="1" type="s">
% 				<Demand CPUDemand="41.3207" DiskDemand="0" />
% 			</Call>
% 			<Call bytesReceived="0" bytesSent="0" callee="Database" caller="WebServer" invocations="1" type="s">
% 				<Demand CPUDemand="11.7812" DiskDemand="0" />
% 			</Call>
% 		</Scenario>
    
    properties
         name='select 0';
         triggeredByService='Browser';
         calls=[];
         responseTime=0;
         throughput=0;
    end
    
    methods
        function obj=OpScenario(name,triggeredByService)  % ,calls)
            obj.name=name;
            obj.triggeredByService=triggeredByService;
            %  obj.calls=calls;
        end
        
        function addCall(obj,call) 
            obj.calls = [obj.calls  call];    
        end
        
        function xml=render(obj,i,xml)
            xml.Scenarios.Scenario(i).ATTRIBUTE.name=obj.name;
            xml.Scenarios.Scenario(i).ATTRIBUTE.triggeredByService=obj.triggeredByService;
            for j=1:length(obj.calls)
                xml=obj.calls(j).render(i,j,xml);
            end
        end
    end
    
end

