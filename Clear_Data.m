function Clear_Data

load('DATA_DFE.mat');
    ALL69=0;
    ALL69FE=0;
    NoHole69FE=0;
    OneHole69FE=0;
    TwoHoles69FE=0;
    Other69FE=0;
    NoHole69=0;
    OneHole69=0;
    TwoHoles69=0;
    Other69=0;
 save('DATA_DFE.mat');
 
 clear
 
 load('DATA_VFE.mat');
    ALL54=0;
    ALL54FE=0;
    NoHole54FE=0;
    OneHole54FE=0;
    TwoHoles54FE=0;
    Other54FE=0;
    NoHole54=0;
    OneHole54=0;
    TwoHoles54=0;
    Other54=0;
 save('DATA_VFE.mat');

end