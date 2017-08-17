function [OutArr AltOutArr] = CompByRef(ArrOfValues)

% Excluded: NofBest, PVal
% 
% Input: 
%   ArrOfValues - 3D array of all the binariszed images [Amount_Of_Images, 
%   Length, Width]
%
% Output: 
%   OutTable - table with summed marks for every clasification system (table)
%   NofBest - Number of the best clasification system (int8)

[z, x, y] = size(ArrOfValues);
% OE(:,:) = zeros(x,y);
% SumOfSys(1,:,:) = Bin(2,:,:);

% for Zz = 1:z
%     SumOfSys(1,:,:) = SumOfSys(1,:,:) | Bin(Zz,:,:);
% end;

% SumOfSysNum(:,:) = SumOfSys(1,:,:);
% TotalQuantity = sum(sum(SumOfSysNum(:,:)));
Ptest(1:z,1:z,1:z) = 0;
PQmark(1:z,1:z,1:z) = 0;
AltPQmark(1:z,1:z,1:z) = 0;

for j = 1:z
    R(:,:) = ArrOfValues(j,:,:);
    fprintf('%d ',j);

    for k = 1:z
        BinName{k,1} = sprintf('Method %d', k);
        P(:,:) = ArrOfValues(k,:,:);
        
%         if  j == k
%             SysMark(k,j) = 0;
%         else
%             InterleavePR(:,:) = (R(:,:) & P(:,:));% | (~R(:,:) & ~P(:,:)); 
%             SysMark(k,j) = (sum(sum(InterleavePR(:,:)))) / (x * y);
%         end
        
        
        
        for e = 1:z
            if e ~= j && e ~= k
                Q(:,:) = ArrOfValues(e,:,:);
            
                PnQR(:,:) = R(:,:) & P(:,:) & ~Q(:,:);
                NPnQR = sum(sum(PnQR(:,:)));
                nPQR(:,:) = R(:,:) & ~P(:,:) & Q(:,:);
                NnPQR = sum(sum(nPQR(:,:)));
                NPQ = NPnQR + NnPQR;

            
                if NPnQR == NnPQR
                    Ptest(j,k,e) = 1;
                    PQmark(j,k,e) = 0;
                    AltPQmark(j,k,e) = 0;
                
                elseif NPnQR > NnPQR
                    Ptest(j,k,e) = sum(binopdf(NPnQR:NPQ,NPQ,0.5));
                    PQmark(j,k,e) = 1;
                
                    if Ptest(j,k,e) < 0.01
                        AltPQmark(j,k,e) = 1;
                    end
                
%                 elseif NPnQR < NnPQR
%                     Ptest(j,k,e) = sum(binopdf(0:NPnQR,NPQ,0.5));
%                     PQmark(j,k,e) = -1;
                
%                     if Ptest(j,k,e) < 0.01
%                         AltPQmark(j,k,e) = -1;
%                     end
%                 end
            else
                Ptest(j,k,e) = 0;
                PQmark(j,k,e) = 0;
                AltPQmark(j,k,e) = 0;
            end
        end

%          PMark(k,j) = sum(Ptest(:)) / (z-2);
        
    end
end
% 
% PQmark
% AltPQmark
% % PVal(:,:) = PMark(:,:);
% for i = 1:z
%     for l = 1:z
%         MergedPQ(i,j) = sum(PQmark(:,i,j));
%         AltMergPQ(i,j) = sum(AltPQmark(:,i,j));
%     end
% %     PVal(i, z + 1) = sum(PVal(i,:));
% end

OutArr(:,:,:) = PQmark(:,:,:); 
AltOutArr(:,:,:) = AltPQmark(:,:,:);

% [MVal, NofBest] = max(OutArr(:, z + 1));
end