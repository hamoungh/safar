classdef OpModel < handle
%   			  *Service
%      		  *Scenario 
%     		  *Node 
%               *Cluster 
 
% 		<Middlware fixedOverheadReceive="0" fixedOverheadSend="0" name="http" overheadPerByteReceived="0" overheadPerByteSent="0"/>
% 		<Network connectsNodes="ClientHost WebHost DataHost" latency="0" name="Internet" overheadPerByte="0"/>
% 	</Topology>
% 
% 
% 	<Requirements>
% 		<ResponseTime maxResponseTime="100000" minResponseTime="100" scenario="select 0"/>
% 	</Requirements>
% 
% </Model>

    properties
        services=[];
        scenarios=[];
        calls=[]; 
        nodes=[];
        clusters=[];
        containers=[]; 
        workload=[];
        networks=[];
        
        %  results
        scenario_container=[];
        scenario_service=[];
        
        parent_path_str=[]; 
        path_str=[]; file_name=[];
    end
    
    methods 
        function include_jar(obj,jarname,full_path)
            % javaclasspath         
            a=javaclasspath('-dynamic'); 
            for i=1:size(a,1)
                if (not(isempty( strfind(a{1}, jarname))))
                    return;
                end
            end
            javaaddpath({full_path});            
        end
        
        function obj=OpModel()
            cur_file_path=mfilename('fullpath');
            [path_str, file_name, ext] = fileparts(cur_file_path);
            [parent_path_str, cur_dir_name, ext] = fileparts(path_str);            
            
            obj.file_name=file_name; 
            obj.path_str=path_str;
            obj.parent_path_str= parent_path_str;            
            
            addpath(strcat(parent_path_str,'/xml_io_tools'));
            % addpath(strcat(parent_path_str,'/str2num'));
%             obj.include_jar('model.jar','/home/zigorat/workspace2/model/dist/model.jar');
%             obj.include_jar('opera.jar','/home/zigorat/workspace2/Opera/dist/opera.jar'); 
%              javaaddpath({'/home/zigorat/workspace2/model/dist/model.jar',...
%                                     '/home/zigorat/workspace2/Opera/dist/opera.jar'});

            % import aperaTests.common.Model;
            %.. import model.Model;
             import opera.OperaModel; %..  
        end
        
        function obj=setModel(services,scenarios,nodes,clusters,workload)
            obj.services=services;
            obj.scenarios=scenarios;
            obj.nodes=nodes;
            obj.clusters=clusters;
            obj.workload=workload; 
        end
        
        function buildtest(obj)
            obj.services=[OpService('Browser','Client'),...
                        OpService('WebServer','WebContainer'),...
                        OpService('Database','DataContainer'),...
                        OpService('Database2','DataContainer2')]; 

            obj.calls=[OpCall('Browser', 'WebServer', 1, 41.3207, 0),...
                      OpCall('WebServer', 'Database', 1, 11.7812, 0),...
                      OpCall('WebServer', 'Database2', 1, 11.7812, 0)];
            
            obj.scenarios=OpScenario('select','Browser');
            obj.scenarios.calls = obj.calls;

            obj.nodes= [OpNode('ClientHost','client',1,1),...
                        OpNode('WebHost','server',2,1),...
                        OpNode('DataHost','server',1,1)]; 

            obj.containers=[OpContainer('Client', 1000, 'ClientHost', 'false' ),...
                            OpContainer('WebContainer', 400, 'WebHost', 'true' ),...
                            OpContainer( 'DataContainer', 150, 'DataHost', 'true' ),...
                            OpContainer( 'DataContainer2', 150, 'DataHost', 'true' )];
                        
            obj.clusters=[OpCluster('ClientCluster',[obj.containers(1)]),...
                            OpCluster('WebCluster',[obj.containers(2)]),...
                            OpCluster('DataCluster',[obj.containers(3),obj.containers(4)])];

             scWorkloads=containers.Map({'select'},{OpClosedWorkload(100,0.1)});            
             obj.workload = OpWorkload(100,scWorkloads);              
        end
        
        function xml=render(obj)
                 xml=[];             
                for i=1:length(obj.services)
                    xml=obj.services(i).render(i,xml); 
                end
                for i=1:length(obj.scenarios)
                    xml=obj.scenarios(i).render(i,xml);
                end   
                for i=1:length(obj.nodes)
                    xml=obj.nodes(i).render(i,xml);
                end
                for i=1:length(obj.clusters)
                    xml=obj.clusters(i).render(i,xml);
                end
                xml=obj.workload.render(xml);            
                
                xml.Topology.Middlware.ATTRIBUTE.fixedOverheadReceive='0';
                xml.Topology.Middlware.ATTRIBUTE.fixedOverheadSend='0';
                xml.Topology.Middlware.ATTRIBUTE.name='http';
                xml.Topology.Middlware.ATTRIBUTE.overheadPerByteReceived='0';
                xml.Topology.Middlware.ATTRIBUTE.overheadPerByteSent='0';
             
                for i=1:length(obj.networks)
                    xml=obj.networks(i).render(i,xml);
                end
                
                 for i=1:length(obj.scenarios)
                      xml.Requirements.ResponseTime(i).ATTRIBUTE.maxResponseTime='100000';
                      xml.Requirements.ResponseTime(i).ATTRIBUTE.minResponseTime='100';
                      xml.Requirements.ResponseTime(i).ATTRIBUTE.scenario=obj.scenarios(i).name;
                 end     
        end
        
        function ret=find_by_name(obj,input_col,name)
            for i=input_col
                if strcmp(i.name,name)
                    ret=i;
                    break;
                end
            end
        end
  
%       just in case Java XML API complains about the encoding, do this:         
%         A quite simple procedure to globally set the file encoding for all
%             JVMs is given in the answer by erickson in this stackoverflow question.
%             All you need to do, is to specify a envirnoment variable called JAVA_TOOL_OPTIONS.
%             If you set this variable to -Dfile.encoding=UTF8, everytime a JVM is started, it 
%             will pick up this information.
        function solve(obj)
              % path=obj.render_and_write(); 
                path=strcat(obj.path_str,'/output/input.pxl');
                obj.write(obj.render(),path);
                m = opera.OperaModel(); %.. m=model.Model();
                m.setModel(path); 
                m.solve();
                %tmp_file =  strcat(obj.path_str,'/output/tmp.xml');                    
                result_file =  strcat(obj.path_str,'/output/output.xml');                    
                m.SaveResultsToXmlFile( result_file ); 
                %sed.Sed().replaceSelected(tmp_file, result_file,...
                %    'Cp1252', 'UTF-8');
                [tree treeName] = xml_read (result_file);
                % disp([treeName{1} ' ='])
                % gen_object_display(tree); 

                for o=1:size(tree.Architecture.Workloads.Scenario,1)
                    i=tree.Architecture.Workloads.Scenario(o);
                    scenario=obj.find_by_name(obj.scenarios, i.ATTRIBUTE.name); 
                    scenario.responseTime= i.ResponseTime;
                    scenario.throughput= i.Throughput;
                end
                
                 for o=1:size(tree.Architecture.Workloads.Container,1)
                      i=tree.Architecture.Workloads.Container(o);
                      container=obj.find_by_name(obj.containers , i.ATTRIBUTE.name); 
                      container.utilization = i.ATTRIBUTE.Utilization; 
                      for oo=1:size(i.Scenario,1)  
                            j=i.Scenario(oo); 
                            obj.scenario_container.(j.ATTRIBUTE.scenarioName).(i.ATTRIBUTE.name)=...
                                                 j.ATTRIBUTE.responseTime;    
                       end
                 end                                                   
 
%              tree.Architecture.Workloads.Service(1).ATTRIBUTE.name
%              tree.Architecture.Workloads.Service(1).ATTRIBUTE.Utilization       
%              tree.Architecture.Workloads.Service(1).Scenario.ATTRIBUTE.name
%              tree.Architecture.Workloads.Service(1).Scenario.ATTRIBUTE.responseTime
                 for o=1:size(tree.Architecture.Workloads.Service,1)
                      i=tree.Architecture.Workloads.Service(o);
                      service=obj.find_by_name(obj.services , i.ATTRIBUTE.name); 
                      service.utilization = i.ATTRIBUTE.Utilization; 
                      for oo=1:size(i.Scenario,1)  
                            j=i.Scenario(oo); 
                            obj.scenario_service.(j.ATTRIBUTE.name).(i.ATTRIBUTE.name)=...
                                                 j.ATTRIBUTE.responseTime;    
                       end
                 end                                                   

                 % 
%                 tree.Architecture.Workloads.Node(1).ATTRIBUTE.name
%                 tree.Architecture.Workloads.Node(1).CPU.Utilization
%                 tree.Architecture.Workloads.Node(1).DISK.Utilization
                 for o=1:size(tree.Architecture.Workloads.Node,1)
                    i=tree.Architecture.Workloads.Node(o);
                    node=obj.find_by_name(obj.nodes, i.ATTRIBUTE.name); 
                    node.cpuUtilization = i.CPU.Utilization;
                    node.diskUtilization = i.DISK.Utilization; 
                end
        end
        
        function write(obj,xmlModel,file_full_path)                         
            Pref=[]; 
            Pref.StructItem = false;
            Pref.CellItem = false;
            Pref.XmlEngine = 'Xerces';  % use Xerces xml generator directly
            Pref.Debug = false; 
            xml_write(strcat(obj.path_str,'/output/tmp.pxl'), xmlModel, {'Model','aaa','bbb'}, Pref);

            %xml_write('test.xml', MyTree, 'MyTree',wPref);
             % type('./output/output.pxl');   
             
            % command= 'sed s/''<!--bbb-->''/''<!DOCTYPE Model SYSTEM "Opera.dtd">''/ <%s >%s';
            % command = sprintf(command, strcat(obj.path_str, '/output/tmp.pxl'), strcat(obj.path_str, '/output/input.pxl'));
            % [status, result] = system(command);  
           %  sed.Sed().replaceSelected(strcat(obj.path_str, '/output/tmp.pxl')  ,...
           %         strcat(obj.path_str, '/output/tmp1.pxl'),...
           %          'Cp1252', 'UTF-8');
            sed.Sed().replaceSelected(strcat(obj.path_str, '/output/tmp.pxl')  ,...
                    file_full_path,...
                    '<!--bbb-->', '<!DOCTYPE Model SYSTEM "Opera.dtd">');
        end
        
%         function path=render_and_write(obj)             
%              obj.write(obj.render()); 
%              path=strcat(obj.path_str,'/output/input.pxl');
%             %obj.render_and_write();
%         end
        
        function test(obj)
            obj.buildtest();
            obj.render_and_write();
            type(path);
        end
        
    end
    
end

