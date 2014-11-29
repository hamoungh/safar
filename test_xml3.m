classdef test_xml3 < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function test(obj)            
            ll=OpModel();
            ll.buildtest;
            xmlModel=ll.render();
            
            addpath('xml_io_tools')
            Pref=[]; 
            Pref.StructItem = false;
            Pref.CellItem = false;
            Pref.XmlEngine = 'Xerces';  % use Xerces xml generator directly
            xml_write('test3.xml', xmlModel, 'Model', Pref);

            %xml_write('test.xml', MyTree, 'MyTree',wPref);
             type('test3.xml')
        end
    end
    
end

