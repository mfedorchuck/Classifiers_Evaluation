# Classifiers_Evaluation
# This is a programm implementation of proposed statistically-based method
# for the binary classifiers evaluation (and comparing the proposed method with
# traditionally-used metrics for binary classifiers);

# Description of the method in the article: "Statistic Metrics for
# Evaluation of Binary Classifiers without Ground-Truth"
# https://hal.inria.fr/hal-01563615
   
Current program perform traditional evaluation metrics and statistically-based metrics for classifier evaluation.
For correct work - indicate all of folders and subfolders in path!

The program performs next stages (1-4 in the loop - for every input image):

	1 - opening the test image from graphics file;
	(For this project were used datasets from DIBCO 2009-2013 years. DIBCO - Digital Image Binarisation Contests, which were organised by ICDAR (International Conference of Digital Analysis and Recognition).

	2 - applying 10 binarization algorithms for every image;

	3 - Calculating traditional metrics for binarization algorithms, according to Ground Truth (subscribed data) and print the result;

	4 - Calculating statistically-based metrics for binarization algorithms (without Ground Truth) and print the result;
	
In the end:
  6 - Calculate how good are not-traditionally used Pseudo-metrics according to the traditionally-based system (which use subscribed data - Ground Truth)
(calculating average values through dataset):

   - Average sequence alignment cost between the order of classifiers (Statistically-based and GT-based order)
   
   - Average word-edit distance between the order of classifiers  (Statistically-based and GT-based order)
   
   - Average correlation of algorithm's order between the order given by:
   
		F-Measure and Pseudo-F-Measure	%F1 Score (Garmonic mean of Recall and Precesion);
		PSNR and Pseudo-PSNR	% Peak Signal-Noise Rate;
		NCC and Pseudo-NCC	% Normalized Cross-Correlation;
		NRM and Pseudo-NRM % Negative Rate Metric;

Feel free to use
by : Maks Fedorchuk (mfedorchuck@gmail.com)