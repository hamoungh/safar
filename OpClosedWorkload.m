classdef OpClosedWorkload < handle
    
    properties
        tt=0;
        n=0;
    end
    
    methods
        function obj=OpClosedWorkload(n,tt)
            obj.n=n;
            obj.tt=tt;
        end
    end
    
end

