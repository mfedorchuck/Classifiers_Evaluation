function OutArray = ErrAdd(InIm, Err)
FullSize = numel(InIm);
OutArray = InIm;
p = randperm(FullSize);

QuantityErr = int32(FullSize * (Err/ 100));

for i = 1:QuantityErr
	OutArray(p(i)) = ~OutArray(p(i));
end;