clear; close all; clc;

confmat = [298     2       1     0       1       1     3      1       1       0;
     0     293     7     4       1       0     5      2       0       0;
     1     3      263    0       8       0     0      3       0       2;
     1     5       0     261     4       0     3      2       0       1;
     0     0       10    0     254       3     0     10       2       1;
     0     4       1     1       4       300   0      1       0       0;
     1     3       2     0       0       0     264    0       7       1;
     3     5       3     1       7       1     0      289     1       0;
     0     1       3     13      1       0     11     1       289     0;
     0     6       0     1       6       1     2      1       4       304];
  
[Result_special,ReferenceResult] = multiclass_metrics_special(confmat)
Result_common = multiclass_metrics_common(confmat)

 

