classdef AnalyzeForceFunction
    
    methods(Static) % 静的メソッドの宣言


        function positionData = onlyOneDirectionForce(positionData,indexOfPosition,interval)
            n = indexOfPosition;
            temp_pos = positionData(:,n);
            for i = length(positionData(:,n)):-interval:interval   %後ろから配列を削除していくことでindexを崩さない
                diff_pos = temp_pos(i,1) - temp_pos( i-(interval-1), 1);
                if diff_pos < 0
                    positionData(i-(interval-1):i,:) = [];
                end
            end
        end

        function indexedForce = makeIndexedForce(Data)
            MAXPOS = int8(max(Data(:,3)));
            MINPOS = int8(min(Data(:,3)));
            SLIDELENGTH = MAXPOS - MINPOS + 1;
            LeftForce_index = zeros(SLIDELENGTH,1);
            
            for i = MINPOS:1:MAXPOS
                temp_PositionData = Data;
                j = i - MINPOS + 1;
            
                Cond_index = temp_PositionData(:,3) >= i & temp_PositionData(:,3) < i+1;
                if any(Cond_index) 
                    temp_LeftForce_index = temp_PositionData(Cond_index,2);
                    temp_LeftForce_index = rmoutliers(temp_LeftForce_index); %標準偏差の3倍以上を外れ値削除
                    LeftForce_index(j,1) = mean(temp_LeftForce_index,'all');
                end
            end
        
            indexedForce = LeftForce_index;
        end

        
        
    end
end






