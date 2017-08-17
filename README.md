# Classifiers_Evaluation
Traditionally-used and statistically-based systems for binary classifiers evaluation

   
Current program perform traditional evaluation metrics and statistically-based metrics for classifiers selection/evaluation.
For correct work - indicate all of folders and subfolders in path!

The program performs next stages (in the loop - for every input image):

1 - open the test image from graphics file;

2 - apply 10 binarization algorithms for every image;

3 - Calculate and print the table with applied traditional metrics for
binarization algorithms, according to Ground Truth;

4 - Calculate and print the table with applied statistically-based
metrics for binarization algorithms (without Ground Truth);

5 - Calculate the order of classifiers from best to worsed by using
Reference Method;

And, in the end:

6 - Calculate how good not-traditionally used evaluation systems 
(Pseudo-metrics and proposed Reference method ) are good by 
calculating (average values through dataset):

   - Average sequence alignment cost between the order of classifiers 
   - Average word-edit distance between the order of classifiers  
   - Average correlation of algorithm's order between the order given by 
   F-Measure and statistically-based approaches
