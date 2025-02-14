classdef Tx
    properties
        index
        location
    end

    methods 
        function obj = Tx(index_val,location_val)
            obj.index = index_val;
            obj.location = location_val;
        end

        function result = Tx_index(obj)
            result = obj.index;
        end

        function result = Tx_location(obj)
            result = obj.location;
        end

        function Tx_draw(obj)
            scatter(obj.location(1),obj.location(2),'s','MarkerEdgeColor',[0 61 124]/255,'MarkerFaceColor',[0 61 124]/255,'HandleVisibility','off');
            hold on
            %text(obj.location(1)+0.1,obj.location(2)+0.1,['Tx ',num2str(obj.index)],'FontName','Times New Roman','FontSize',8, ...
            %    'HorizontalAlignment','left','VerticalAlignment','bottom');
            text(obj.location(1)-1,obj.location(2)+0.1,num2str(obj.index),'FontName','Times New Roman','FontSize',8, ...
            'HorizontalAlignment','right','VerticalAlignment','bottom','HandleVisibility','off');
        end
        function Tx_draw_show(obj)
            scatter(obj.location(1),obj.location(2),'s','MarkerEdgeColor',[0 61 124]/255,'MarkerFaceColor',[0 61 124]/255);
            hold on
        end
        function Tx_draw_right(obj)
            scatter(obj.location(1),obj.location(2),'s','MarkerEdgeColor',[0 61 124]/255,'MarkerFaceColor',[0 61 124]/255,'HandleVisibility','off');
            hold on
            %text(obj.location(1)+0.1,obj.location(2)+0.1,['Tx ',num2str(obj.index)],'FontName','Times New Roman','FontSize',8, ...
            %    'HorizontalAlignment','left','VerticalAlignment','bottom');
            text(obj.location(1)+5,obj.location(2)+0.1,num2str(obj.index),'FontName','Times New Roman','FontSize',8, ...
            'HorizontalAlignment','left','VerticalAlignment','middle','HandleVisibility','off');
        end
    end
end

