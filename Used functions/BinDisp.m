function BinDisp(TestImage, GrayTestImage, GTImage, TableOfNames, ArrOfValues)

figure(1);
subplot(3,1,1); imshow(TestImage); title(sprintf('Original Image'));
subplot(3,1,2); imshow(GrayTestImage); title(sprintf('Gray-colour Image'));
subplot(3,1,3); imshow(GTImage); title(sprintf('Ground Truth'));

f = 2; sp = 1;

for i = 1:length(ArrOfValues(:,1,1))
    figure(f);
    CurrentImage(:,:) = ArrOfValues(i,:,:);
    
    subplot(3,1,sp); imshow(CurrentImage); title(sprintf('%s', TableOfNames{i}));
    
    sp = sp + 1;
    if sp > 3
        sp = 1;
        f = f + 1;
    end
end
end