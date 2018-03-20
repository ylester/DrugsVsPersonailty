% in: nx1 original numerical array
% keys: mx2 [ map from value, map to value ]
% out: nx1 new numerical array with values from keys(:,2)

% Example: Map [0.2 ; 0.3 ; 0.5] to [2 ; 1 ; 3]
% in = [ 0.2 ; 0.3 ; 0.5 ];
% keys = [ 0.3, 1 ; 0.2, 2 ; 0.5, 3 ]; 0.3 map to 1, 0.2 map to 2, etc.
% out = map(in, keys);
function [out] = map(in, keys)
    out = ones(length(in),1)*-1;
    for i = 1:length(in)
       in_value = in(i,1);
       for ii = 1:length(keys)
           key_value = keys(ii,1);
           if in_value == key_value
              out(i,1) = keys(ii,2);
              break
           end
       end
    end
end