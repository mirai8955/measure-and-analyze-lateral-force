%%%%一行削除したらインデックスは一段下がるのか？

a = [1 2 3 4 5 6;
    1 2 3 4 5 6];
a(:,2) = [];

%%%yes


%%%How all() could work?
% 
% a = [1 1];
% if all(a)
%     disp(yes)
% end

%%%%whether all number 1 or not


a = [1 9 9 9];
b = [2 3 4];
c = min(length(a),length(b));
a(1,2)


