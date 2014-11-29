classdef OpCall
% 			<Call bytesReceived="0" bytesSent="0" callee="Database" caller="WebServer" invocations="1" type="s">
% 				<Demand CPUDemand="11.7812" DiskDemand="0" />
% 			</Call>
    
    properties
                bytesReceived=0; 
                bytesSent=0; 
                callee='WebServer' ;
                caller='Browser'; 
                invocations=1; 
                type='s';
 				CPUDemand=41.3207; 
                DiskDemand=0;  
    end
    
    methods
        function obj=OpCall(caller, callee, invocations, CPUDemand, DiskDemand)
            obj.caller=caller; 
            obj.callee=callee; 
            obj.invocations=invocations; 
            obj.CPUDemand=CPUDemand; 
            obj.DiskDemand=DiskDemand;
        end
        
        function xml=render(obj,i,j,xml)
            xml.Scenarios.Scenario(i).Call(j).ATTRIBUTE.bytesReceived=num2str(obj.bytesReceived);
            xml.Scenarios.Scenario(i).Call(j).ATTRIBUTE.bytesSent=num2str(obj.bytesSent);
            xml.Scenarios.Scenario(i).Call(j).ATTRIBUTE.caller=obj.caller;
            xml.Scenarios.Scenario(i).Call(j).ATTRIBUTE.callee=obj.callee;
            xml.Scenarios.Scenario(i).Call(j).ATTRIBUTE.invocations=num2str(obj.invocations);
            xml.Scenarios.Scenario(i).Call(j).ATTRIBUTE.type=obj.type;
            xml.Scenarios.Scenario(i).Call(j).Demand.ATTRIBUTE.CPUDemand=num2str(obj.CPUDemand);
            xml.Scenarios.Scenario(i).Call(j).Demand.ATTRIBUTE.DiskDemand=num2str(obj.DiskDemand);
        end
    
    end
    
end

