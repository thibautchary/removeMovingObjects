function [image_moved_modified]=AlignImages(image_reference,image_moved,H)
    H
    %image_reference=double(imread(image));
    image_moved_modified=replaceColorValuesAllImage(image_reference,image_moved,H);
    figure; image(1/255*image_moved_modified);
end

%checked
function [V]=interpolateColorValues(V00,V10,V01,V11,x,y)
    V=x*y*V11+(1-x)*y*V01+(1-y)*x*V10+(1-x)*(1-y)*V00;
end

%checked
function [V]=interpolateColorValuesXAxis(V00,V10,x)
    V=x*V10+(1-x)*V00;
end

%checked
function [V]=interpolateColorValuesYAxis(V00,V01,y)
    V=y*V01+(1-y)*V00;
end

%checked ; problem on the edges
function [V]=findColorValue(x,y,image,channel)
    [n,p,c]=size(image);
    %V=image(round(x),round(y),channel);
    if x+1<n
        if y+1<p
            V=interpolateColorValues(image(floor(x),floor(y),channel),image(floor(x)+1,floor(y),channel),image(floor(x),floor(y)+1,channel),image(floor(x)+1,floor(y)+1,channel),x-floor(x),y-floor(y));
        else
            V=interpolateColorValuesXAxis(image(floor(x),floor(y),channel),image(floor(x)+1,floor(y),channel),x-floor(x));
        end
    else
        V=interpolateColorValuesYAxis(image(floor(x),floor(y),channel),image(floor(x),floor(y)+1,channel),y-floor(y));
    end
end

%checked
function [color]=giveColorValueOnePixelOneChannel(i,j,image_moved,H,channel)
    A = H*[i j 1]';
    color=findColorValue(A(1),A(2),image_moved,channel);
end

% VERY SLOW !! + error with negative indices
function [image_moved_modified]=replaceColorValuesAllImage(image_reference,image_moved,H)
    [n,p,c]=size(image_reference);
    nShift = round(H(1,3));
    pShift = round(H(2,3));
    image_moved_modified=image_reference;
    for i=1:min(n-nShift,n),
        display (['i=',num2str(i)]);
        for j=1:min(p-pShift,p)
            %display (['j=',num2str(j)]);
            for channel=1:1,    % ---> Could be an error?
%                try 
                    image_moved_modified(i,j,channel)=giveColorValueOnePixelOneChannel(i,j,image_moved,H,channel);
%                 catch
%                     display (['One exception here','i=',num2str(i),'j=',num2str(j)]);
%                     image_moved_modified(i,j,channel)=0;
%                 end
            end
        end
    end
end

% Faster, different method without taking mean value without colour
% interpolation (doesn't work because problem with indices)
% ------------------------------------------------------------------
%
% function [image_moved_modified]=replaceColorValuesAllImage(image_reference,image_moved,H)
%     [n, p, c] = size(image_reference);
%     refIndexes = [sort(repmat([1:n],1,p)); repmat([1:p],1,n); ones(1,n*p)];
%     mappedIndexes = round(H*refIndexes);
%     image_moved_modified = zeros(size(image_reference));
%     xindex = reshape(mappedIndexes(1,:),p,n)';
%     yindex = reshape(mappedIndexes(2,:),p,n)';
%     for i=1:n
%         for j=1:p
%             image_moved_modified(i,j,:) = image_moved(xindex(i),yindex(j),:);
%         end
%     end
% end
