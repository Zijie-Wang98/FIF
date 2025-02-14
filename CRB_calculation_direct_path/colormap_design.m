function my_colorbar = colormap_design(color)
    step = 5000;
    my_colorbar = [linspace(color(1,1),color(2,1),step)',linspace(color(1,2),color(2,2),step)',linspace(color(1,3),color(2,3),step)'];
    for i=2:size(color,1)-1
        my_colorbar = [my_colorbar;linspace(color(i,1),color(i+1,1),step)',linspace(color(i,2),color(i+1,2),step)',linspace(color(i,3),color(i+1,3),step)'];
    end
    my_colorbar = flipud(my_colorbar);
end

