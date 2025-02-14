classdef Rx
    properties
        index
        location
    end

    methods 
        function obj = Rx(index_val,location_val)
            obj.index = index_val;
            obj.location = location_val;
        end

        function result = Rx_index(obj)
            result = obj.index;
        end

        function result = Rx_location(obj)
            result = obj.location;
        end

        function Rx_draw(obj)
            scatter(obj.location(1),obj.location(2),'o','MarkerEdgeColor',[239 124 0]/255,'MarkerFaceColor',[239 124 0]/255);
            hold on
            %text(obj.location(1)+0.1,obj.location(2)+0.1,['Rx ',num2str(obj.index)],'FontName','Times New Roman','FontSize',8, ...
            %    'HorizontalAlignment','left','VerticalAlignment','bottom');
            text(obj.location(1)+1,obj.location(2)+0.1,[num2str(obj.index)],'FontName','Times New Roman','FontSize',8, ...
                'HorizontalAlignment','left','VerticalAlignment','middle');
        end
    end
end