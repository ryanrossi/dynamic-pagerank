function [ colors,symbol ] = plot_colors( n )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if nargin > 0,
    if n == 1,
        colors{1} = rgb('Blue');
    end
    if n == 2,
        colors{1} = rgb('DodgerBlue');
        colors{2} = rgb('Crimson');
    end
    if n == 3,
        colors{1} = rgb('DodgerBlue');
        colors{2} = rgb('LimeGreen');
        colors{3} = rgb('MediumPurple');
    end
    if n == 4,
        colors{1} = rgb('DodgerBlue');
        colors{2} = rgb('Crimson');
        colors{3} = rgb('LimeGreen');
        colors{4} = rgb('MediumPurple');
    end
    if n == 5,
        colors{1} = rgb('Black');
        colors{2} = rgb('DodgerBlue');
        colors{3} = rgb('Lime');
        colors{4} = rgb('MediumPurple');
        %colors{4} = rgb('Crimson');
        colors{5} = rgb('Red');
        %colors{4} = rgb('MediumPurple');
        %colors{5} = rgb('HotPink');
        %colors{5} = rgb('DeepPink');
    end
    if n == 4,
        colors{1} = rgb('Blue');
        colors{2} = rgb('Lime');
        colors{3} = rgb('MediumPurple');
        colors{4} = rgb('Red');
        %colors{4} = rgb('Crimson');
        %colors{4} = rgb('Red');
        %colors{4} = rgb('MediumPurple');
        %colors{5} = rgb('HotPink');
        %colors{5} = rgb('DeepPink');
    end
    if n == 9,
        colors{1} = 'b';
        colors{2} = rgb('DodgerBlue');
        colors{3} = rgb('Cyan');
        colors{4} = rgb('LimeGreen');
        colors{5} = 'g';%rgb('Green');
        colors{6} = rgb('MediumPurple');
        colors{7} = 'magenta';
        colors{8} = rgb('HotPink');
        colors{9} = rgb('Crimson');
        %colors{9} = rgb('Red');
        
    end
    if n == 11,
        colors{1} = 'b';
        colors{2} = rgb('DodgerBlue');
        colors{3} = rgb('Cyan');
        colors{4} = rgb('LimeGreen');
        colors{5} = 'g'%rgb('Green');
        colors{6} = rgb('MediumPurple');
        colors{7} = 'magenta';
        colors{8} = rgb('HotPink');
        colors{9} = rgb('Orange');
        colors{10} = rgb('Crimson');
        colors{11} = rgb('Red');
    end
    
    if n == 13,
        colors{1} = rgb('Crimson');
        colors{2} = rgb('HotPink');
        colors{5} = rgb('LimeGreen');
        
        colors{6} = rgb('DodgerBlue');
        %colors{4} = rgb('Blue');
        colors{3} = rgb('MediumPurple');
        colors{4} = 'b';
        %colors{5} = 'red';
        %colors{5} = rgb('SkyBlue');
        
        %multi (active only)
        colors{7} = rgb('Blue');
        colors{9} = rgb('Cyan');
        colors{11} = rgb('MediumPurple');
        
        colors{8} = rgb('HotPink');
        colors{10} = rgb('Crimson');
        
        %baseline
        %colors{12} = 'black'
        colors{13} = 'r'
        colors{12} = rgb('DeepPink');
        colors{14} = rgb('MediumPurple');
        
    end
    if n == 14,
        colors{1} = rgb('Crimson');
        colors{2} = rgb('HotPink');
        colors{3} = rgb('Lime');
        
        colors{4} = rgb('DodgerBlue');
        %colors{4} = rgb('Blue');
        colors{5} = rgb('MediumPurple');
        %colors{5} = 'red';
        %colors{5} = rgb('SkyBlue');
        
        %multi (active only)
        colors{7} = rgb('Blue');
        colors{9} = rgb('Cyan');
        colors{11} = rgb('MediumPurple');
        
        %multi (both active/inactive)
        colors{6} = rgb('Red');
        colors{8} = rgb('HotPink');
        colors{10} = rgb('Crimson');
        
        %baseline
        colors{12} = 'black'
        colors{13} = 'r'
        %colors{13} = rgb('DeepPink');
        colors{14} = rgb('MediumPurple');
        
    end
    if n == 12,
        colors{1} = rgb('DodgerBlue');
        colors{2} = rgb('Crimson');
        colors{3} = rgb('DeepPink');
        colors{4} = rgb('Lime');
        colors{5} = 'b';
        %colors{4} = rgb('Blue');
        colors{6} = rgb('Cyan');
        %colors{5} = 'red';
        %colors{5} = rgb('SkyBlue');
        
        %multi (active only)
        %colors{7} = rgb('Blue');
        %colors{9} = rgb('Cyan');
        colors{7} = rgb('MediumPurple');
        
        %multi (both active/inactive)
        colors{8} = rgb('Red');
        colors{9} = rgb('HotPink');
        colors{10} = rgb('MediumPurple');
        colors{11} = 'magenta';
        colors{12} = rgb('Green');
        
        %baseline
        %colors{12} = 'black'
        %colors{13} = 'r'
        %colors{13} = rgb('DeepPink');
        
    end
else
    
        %single models
%     colors{15} = 'b'
%     colors{14} = rgb('DodgerBlue');
%     colors{13} = rgb('Lime');
%     colors{12} = rgb('Green');
%     colors{11} = 'magenta';
%     %colors{5} = rgb('SkyBlue');
%     
%     %multi (active only)
%     colors{10} = rgb('Blue');
%     colors{9} = rgb('RoyalBlue');
%     colors{8} = rgb('MediumPurple');
%     
%     %multi (both active/inactive)
%     colors{7} = rgb('Red');
%     colors{6} = rgb('HotPink');
%     colors{5} = rgb('Crimson');
%     
%     %baseline
%     colors{4} = rgb('Orange');
%     colors{3} = rgb('DeepPink');
%     colors{2} = rgb('MediumPurple');
%     colors{1} = rgb('Purple');
    
    
    colors{1} = 'b';
    colors{2} = rgb('DodgerBlue');
    colors{3} = rgb('Cyan');
    colors{4} = rgb('LimeGreen');
    colors{5} = 'g';%rgb('Green');
    colors{6} = rgb('MediumPurple');
    colors{7} = 'magenta';
    colors{8} = rgb('HotPink');
    colors{9} = rgb('Orange');
    colors{10} = rgb('Crimson');
    colors{11} = rgb('Red');
    

    
    %baseline
    colors{12} = rgb('Orange');
    colors{13} = rgb('DeepPink');
    colors{14} = rgb('MediumPurple');
    colors{15} = rgb('Purple');
    colors{16} = rgb('RoyalBlue');
    
    if 0
        
    end
end



symbol = ['-*', '-s', '-^', '-o', '-x', '-d', '-+', '-<', '->', '-h',];

end

