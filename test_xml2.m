
% <Model>
% 	<Scenarios>
% 		<Services>
% 			<Service canMigrate="false" name="Browser" runsInContainer="Client"/>
% 			<Service canMigrate="false" name="WebServer" runsInContainer="WebContainer"/>
% 			<Service canMigrate="false" name="Database" runsInContainer="DataContainer"/>
% 		</Services>
% 
% 		<Scenario name="select 0" triggeredByService="Browser">
% 			<Call bytesReceived="0" bytesSent="0" callee="WebServer" caller="Browser" invocations="1" type="s">
% 				<Demand CPUDemand="41.3207" DiskDemand="0" />
% 			</Call>
% 			<Call bytesReceived="0" bytesSent="0" callee="Database" caller="WebServer" invocations="1" type="s">
% 				<Demand CPUDemand="11.7812" DiskDemand="0" />
% 			</Call>
% 		</Scenario>
% 
% 	</Scenarios>
% 
% 	<Topology> 
% 		<Node CPUParallelism="1" CPURatio="1" DiskParallelism="1" DiskRatio="1" name="ClientHost" type="client"/>
% 		<Node CPUParallelism="2" CPURatio="1" DiskParallelism="1" DiskRatio="1" name="WebHost" type="server"/>
% 		<Node CPUParallelism="1" CPURatio="1" DiskParallelism="1" DiskRatio="1" name="DataHost" type="server"/>
% 
% 		<Cluster name="ClientCluster">
% 			<Container canMigrate="false" name="Client" parallelism="1000" runsOnNode="ClientHost" server="false"/>
% 		</Cluster>
% 		<Cluster name="WebCluster">
% 			<Container canMigrate="false" name="WebContainer" parallelism="400" runsOnNode="WebHost" server="true"/>
% 		</Cluster>
% 		<Cluster name="DataCluster">
% 			<Container canMigrate="false" name="DataContainer" parallelism="150" runsOnNode="DataHost" server="true"/>
% 		</Cluster>
% 
% 		<Middlware fixedOverheadReceive="0" fixedOverheadSend="0" name="http" overheadPerByteReceived="0" overheadPerByteSent="0"/>
% 		<Network connectsNodes="ClientHost WebHost DataHost" latency="0" name="Internet" overheadPerByte="0"/>
% 	</Topology>
% 
% 	<Workloads kind="HL">
% 		<Users>0</Users>
% 		<WorkloadMixes openModel="false">
% 			<Mix load="100" scenario="select 0"/>
% 		</WorkloadMixes>
% 		<ThinkTimes>
% 			<ThinkTime scenario="select 0" time="0"/>
% 		</ThinkTimes>
% 	</Workloads>
% 
% 	<Requirements>
% 		<ResponseTime maxResponseTime="100000" minResponseTime="100" scenario="select 0"/>
% 	</Requirements>
% 
% </Model>

addpath('../xml_io_tools')
Model=[];
Model.Scenarios.Scenario(1).ATTRIBUTE.name='select 0';
Model.Scenarios.Scenario(1).ATTRIBUTE.triggeredByService='Browser';

Model.Scenarios.Services.Service(1).ATTRIBUTE.canMigrate='false'
Model.Scenarios.Services.Service(1).ATTRIBUTE.name='Browser' 
Model.Scenarios.Services.Service(1).ATTRIBUTE.runsInContainer='Client'

Model.Scenarios.Scenario(1).ATTRIBUTE.name='select 0';
Model.Scenarios.Scenario(1).ATTRIBUTE.triggeredByService='Browser';
Model.Scenarios.Scenario(1).Call(1).ATTRIBUTE.bytesReceived='0'
Model.Scenarios.Scenario(1).Call(1).ATTRIBUTE.bytesSent='0'
Model.Scenarios.Scenario(1).Call(1).ATTRIBUTE.caller='Browser' 
Model.Scenarios.Scenario(1).Call(1).ATTRIBUTE.callee='WebServer'
Model.Scenarios.Scenario(1).Call(1).ATTRIBUTE.invocations='1'
Model.Scenarios.Scenario(1).Call(1).ATTRIBUTE.type='s'
Model.Scenarios.Scenario(1).Call(1).Demand.ATTRIBUTE.CPUDemand='41.3207'
Model.Scenarios.Scenario(1).Call(1).Demand.ATTRIBUTE.DiskDemand='0' 

Model.Topology.Node(1).ATTRIBUTE.CPUParallelism='1'
Model.Topology.Node(1).ATTRIBUTE.CPURatio='1'
Model.Topology.Node(1).ATTRIBUTE.DiskParallelism='1'
Model.Topology.Node(1).ATTRIBUTE.DiskRatio='1'
Model.Topology.Node(1).ATTRIBUTE.name='ClientHost'
Model.Topology.Node(1).ATTRIBUTE.type='client'
Model.Topology.Cluster(1).ATTRIBUTE.name='ClientCluster'
Model.Topology.Cluster(1).Container.ATTRIBUTE.canMigrate='false'
Model.Topology.Cluster(1).Container.ATTRIBUTE.name='Client' 
Model.Topology.Cluster(1).Container.ATTRIBUTE.parallelism='1000'
Model.Topology.Cluster(1).Container.ATTRIBUTE.runsOnNode='ClientHost'
Model.Topology.Cluster(1).Container.ATTRIBUTE.server='false'
Model.Topology.Middlware.ATTRIBUTE.fixedOverheadReceive='0'
Model.Topology.Middlware.ATTRIBUTE.fixedOverheadSend='0'
Model.Topology.Middlware.ATTRIBUTE.name='http'
Model.Topology.Middlware.ATTRIBUTE.overheadPerByteReceived='0'
Model.Topology.Middlware.ATTRIBUTE.overheadPerByteSent='0'
Model.Topology.Network.ATTRIBUTE.connectsNodes='ClientHost WebHost DataHost'
Model.Topology.Network.ATTRIBUTE.latency='0'
Model.Topology.Network.ATTRIBUTE.name='Internet'
Model.Topology.Network.ATTRIBUTE.overheadPerByte='0'

Model.Workloads.ATTRIBUTE.kind='HL'
Model.Workloads.Users='0'
Model.Workloads.Mix.ATTRIBUTE.load='100'
Model.Workloads.Mix.ATTRIBUTE.scenario='select 0'
Model.Workloads.ThinkTimes.ThinkTime.ATTRIBUTE.scenario='select 0'
Model.Workloads.ThinkTimes.ThinkTime.ATTRIBUTE.time='0'

Model.Requirements.ResponseTime.ATTRIBUTE.maxResponseTime='100000'
Model.Requirements.ResponseTime.ATTRIBUTE.minResponseTime='100'
Model.Requirements.ResponseTime.ATTRIBUTE.scenario='select 0'

Pref=[]; 
Pref.StructItem = false;
Pref.CellItem = false;
Pref.XmlEngine = 'Xerces';  % use Xerces xml generator directly
xml_write('test2.xml', Model, 'Model', Pref);

%xml_write('test.xml', MyTree, 'MyTree',wPref);
 type('test2.xml')
 