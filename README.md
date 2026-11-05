
# Low-rank MERA Decomposition of 3D OCT Image Volume for Compression, Denoising, Feature Extraction and Diagnosis of Retinal Diseases

The script files are associated with the paper:

I. Kopriva, F. Shi, M. Štanfel, Q. Peng, J. Bao, G. Li, X. Chen, "Low-rank MERA Decomposition of 3D OCT Image Volume for Compression, Denoising, 
Feature Extraction and Diagnosis of Retinal Diseases", arXiv preprint arXiv:2610.35271

------------------------------------------------------
In main directory script GM_NSC_AMD_vs_Control_bases_estimation.m demonstrates how subspace bases
are estimated from OCT images. They are stored in Bases_AMD_Conttol_CR_2_d_11.mat for compression ratio 2 and subspace dimension 11.
Corresonding features are stored in G_features_AMD_256_CR_2.mat and G_features_Control_256_CR_2.mat. The three "mat" files are used by the 
script GM_NSC_AMD_vs_Control_classifier.m . 

In .\AMD subdirectory Grassman_classifier_G_features.m reproduces results from Table I for CR=4.

In .\Glaucoma_grading subdirectory Grassman_classifier_G_features_Glaucoma_vs_Normal.m reproduecs results from Table V for CR=7.

ACKNOWLEDGMENTS
This work was supported by the Croatian Science Foundation Grant HRZZ-IP-2022-10-6403, 
by the National Natural Science Foundation of China (62271337),
 and by the bilateral Croatian-Chinese Scientific and Technological Cooperation Project
 "Tensor models and tensor networks for compression, de-speckling, feature extraction 
and diagnosis of retinal diseases from 3D OCT images". 
 
-----------------------------------------------------

