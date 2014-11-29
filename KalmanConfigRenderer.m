classdef  KalmanConfigRenderer < handle

    properties
        
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
        
        functiffgfon obj=KalmanConfigRenderer()
            cur_file_path=mfilename('fullpath');
            [path_str, file_name, ext] = fileparts(cur_file_path);
            [parent_path_str, cur_dir_name, ext] = fileparts(path_str);            
            
            obj.file_name=file_name; 
            obj.path_str=path_str;
            obj.parent_path_str= parent_path_str;            
            
            addpath(strcat(parent_path_str,'/xml_io_tools'));
             import opera.OperaModel; %..  
        end
        
        function xml=render(obj,X,rt,util, d_csh)  
                 xml=[];             
                 % measured metrics  
                 i=1;         
                 for h=1:length(util)
                         xml.Config.MeasuredMetrics.MeasuredMetric(i).ATTRIBUTE.name=sprintf('CpuUtil_H%d',h); 
                         xml.Config.MeasuredMetrics.MeasuredMetric(i).ATTRIBUTE.default=sprintf('%d', util(h)); 
                         i=i+1; 
                 end 
                 for c=1:length(X)
                         xml.Config.MeasuredMetrics.MeasuredMetric(i).ATTRIBUTE.name=sprintf('X_class%d',c); 
                         xml.Config.MeasuredMetrics.MeasuredMetric(i).ATTRIBUTE.default=sprintf('%d', X(c)); 
                         i=i+1; 
                 end 
                  for c=1:length(rt)
                         xml.Config.MeasuredMetrics.MeasuredMetric(i).ATTRIBUTE.name=sprintf('RT_class%d',c); 
                         xml.Config.MeasuredMetrics.MeasuredMetric(i).ATTRIBUTE.default=sprintf('%d', rt(c)); 
                           i=i+1; 
                  end   
                  
                  % filtered measurement  
                 i=1;         
                 for h=1:length(util)
                         xml.Config.MeasuredMetrics.MeasuredMetric(i).ATTRIBUTE.name=sprintf('CpuUtil_H%d',h); 
                         xml.Config.MeasuredMetrics.MeasuredMetric(i).ATTRIBUTE.xPath=sprintf('/Results/Architecture/Workloads/Node[@name=''H%d'']/CPU/Utilization/text()', h);  
                         xml.Config.MeasuredMetrics.MeasuredMetric(i).ATTRIBUTE.scale='1'; 
                         i=i+1; 
                 end 
                 for c=1:length(X)
                         xml.Config.MeasuredMetrics.MeasuredMetric(i).ATTRIBUTE.name=sprintf('X_class%d',c); 
                         xml.Config.MeasuredMetrics.MeasuredMetric(i).ATTRIBUTE.xPath= sprintf('/Results/Architecture/Workloads/Scenario[@name=''class%d'']/Throughput/text()', c); 
                         xml.Config.MeasuredMetrics.MeasuredMetric(i).ATTRIBUTE.scale='1';  
                         i=i+1; 
                 end 
                  for c=1:length(rt)
                         xml.Config.MeasuredMetrics.MeasuredMetric(i).ATTRIBUTE.name=sprintf('RT_class%d',c);      
                         xml.Config.MeasuredMetrics.MeasuredMetric(i).ATTRIBUTE.xPath= sprintf('/Results/Architecture/Workloads/Scenario[@name=''class%d'']/ResponseTime/text()', c);   
                         xml.Config.MeasuredMetrics.MeasuredMetric(i).ATTRIBUTE.scale='1'; 
                           i=i+1; 
                  end 
                
                 % unknown parameters  
                 [c_,s_,h_]=ind2sub(size(d_csh), find(d_csh~=0)); 
                  for i=1:size(c_,1)
                                       c=c_(i); s=s_(i); h=h_(i); 
                                       xml.Config.ModelParameters.ModelParameter.ATTRIBUTE.name=sprintf('CPUDemand_%d_%d_%d', c,s,h);  
                                       xml.Config.ModelParameters.ModelParameter.ATTRIBUTE.default=sprintf('%d',d_csh(c,s,h)); 
                                       xml.Config.ModelParameters.ModelParameter.ATTRIBUTE.xPath=sprintf('/Model/Scenarios/Scenario[@name=''class%d'']/Call[@callee=''S%d_%h'']/Demand/@CPUDemand',c,s,h); 
                  end    
        end
        
        function write(obj,xmlModel,file_full_path)
            Pref=[]; 
            Pref.StructItem = false;
            Pref.CellItem = false;
            Pref.XmlEngine = 'Xerces';  % use Xerces xml generator directly
            Pref.Debug = false; 
            xml_write(strcat(obj.path_str,'/output/tmpKalmanConfig.config'), xmlModel, {'Model','aaa','bbb'}, Pref); 
             command= 'sed s/''<!--bbb-->''/''<!DOCTYPE Config SYSTEM "Kalman Filter.dtd">''/ <%s >%s';
             command = sprintf(command, strcat(obj.path_str, '/output/tmpKalmanConfig.config'), strcat(obj.path_str, '/output/kalmanConfig.config')); 
             [status, result] = system(command);        
             delete(strcat(obj.path_str, '/output/tmpKalmanConfig.config')); 
            end
              
        function ret=find_by_name(obj,input_col,name)
            for i=input_col
                if strcmp(i.name,name)
                    ret=i;
                    break;
                end
            end
        end 
        
        function path=render_and_write(obj,X,rt,util, d_csh)             
             obj.write(obj.render(X,rt,util, d_csh)); 
             path=strcat(obj.path_str,'/output/tmpKalmanConfig.config');
        end
        
        function test(obj)
            obj.buildtest();
            path=obj.render_and_write();
            type(path);
        end
        
    end
    
end

