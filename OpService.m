classdef OpService < handle
% <Model>
% 	<Scenarios>
% 		<Services>
% 			<Service canMigrate="false" name="Browser" runsInContainer="Client"/>
% 			<Service canMigrate="false" name="WebServer" runsInContainer="WebContainer"/>
% 			<Service canMigrate="false" name="Database" runsInContainer="DataContainer"/>
% 		</Services>

    properties
        canMigrate='false';
        name='Browser';
        runsInContainer='Client';
        utilization=0; 
    end
    
    methods
        function obj=OpService(name,runsInContainer)
            obj.name=name;
            obj.runsInContainer=runsInContainer; 
        end
        
        function xml=render(obj,i,xml)
            xml.Scenarios.Services.Service(i).ATTRIBUTE.canMigrate=obj.canMigrate;
            xml.Scenarios.Services.Service(i).ATTRIBUTE.name=obj.name;
            xml.Scenarios.Services.Service(i).ATTRIBUTE.runsInContainer=obj.runsInContainer;
        end
    end
    
end

