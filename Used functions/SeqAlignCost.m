function FinalScore = SeqAlignCost(string1,string2)

% Function for calculation sequence alignments cost
% Input: 
% string1, string2 - string of symbols (char type)
% In the present implementation both should be the same length
%
% Output: FinalScore - optimal cost of compared both input string

% The penalties to apply
GapCost = 2; 
DiferCost = 3; SimilarCost = 1; MatchCost = 0;

% Initializing of array for optimum path cost calculations
ArrSize = length(string1) + 1; Opt = zeros(ArrSize);
string1Exp(2:ArrSize) = string1(:); string1Exp(ArrSize + 1) = ' ';
string2Exp(2:ArrSize) = string2(:); string2Exp(ArrSize + 1) = ' ';

% First of all, compute insertions and deletions at 1st row/column
for i = 1:ArrSize - 1
    Opt(i + 1, 1) = Opt(i, 1) + GapCost;
    Opt(1, i + 1) = Opt(1, i) + GapCost;
end

for i = 2:ArrSize
    for j = 2:ArrSize
        
        if string1(i - 1) == string2(j - 1)
            m = MatchCost; % same symbol
        elseif string1Exp(i) == string2Exp(j + 1) || string1Exp(i) == string2Exp(j - 1)
            m = SimilarCost; % related symbol
        else
            m = DiferCost; % different symbol
        end
        
        DiagMark = Opt(i - 1, j - 1) + m; % symbols comparing
        LeftMark = Opt(i, j - 1) + GapCost; % insertion
        UpMark = Opt(i - 1, j) + GapCost; % deletion
        
        % than we take the minimum 
        Opt(i, j) = min(DiagMark, min(LeftMark, UpMark));
    end
end

FinalScore = Opt(ArrSize, ArrSize);
% Opt(:,:)