function  ResultsComparing(Ps_FM_Distance, EditPS_FM_distance, OrdCorrPsFM, NumIm)

AvPsFMDistance = sum(Ps_FM_Distance, 'omitnan') / NumIm;
fprintf('\n Average sequence alignment cost between order');
fprintf('\n given by F-Measure and Pseudo F-Measure: %.4g \n', AvPsFMDistance);

AvRefWordDistance = sum(EditPS_FM_distance, 'omitnan') / NumIm;
fprintf('\n Average word-edit distance between order');
fprintf('\n given by F-Measure and Pseudo F-Measure: %.4g \n', AvRefWordDistance);

AvgCorrelationOfPsFM = sum(OrdCorrPsFM, 'omitnan') / NumIm;
fprintf('\n Average correlation of algorithm`s order between order');
fprintf('\n given by F-Measure and Pseudo F-Measure: %.4g \n', AvgCorrelationOfPsFM);

end